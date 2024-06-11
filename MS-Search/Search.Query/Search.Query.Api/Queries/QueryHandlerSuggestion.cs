using IronPython.Hosting;
using IronPython.Runtime;
using Microsoft.Extensions.Caching.Memory;
using Search.Query.Api.DTOs;
using Search.Query.Api.Helper;
using Search.Query.Domain.DTOs;
using Search.Query.Domain.Entities;
using Search.Query.Domain.Repositories;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;

namespace Search.Query.Api.Queries
{
    /// <summary>
    /// Implement a query handler that depends on search repository
    /// </summary>
    public class QueryHandlerSuggestion : IQueryHandlerSuggestion, IDisposable
    {
        private readonly ISearchRepository _searchRepository;
        private readonly IMemoryCache _memoryCache;
        private readonly object _cacheLock = new object();
        private readonly IronPythonExecutor _ironPythonExecutor;
        private bool _disposed;

        public QueryHandlerSuggestion(ISearchRepository searchRepository, IMemoryCache memoryCache)
        {
            _searchRepository = searchRepository;
            _memoryCache = memoryCache;
            _ironPythonExecutor = new IronPythonExecutor();
        }

        // Handle the final Search Query that invokes the list       
        public async Task<List<SearchSuggestion>> HandleAsync(FindSuggestionsBySearchTextFromHistoryQuery query)
        {
            try
            {
                return await _searchRepository.GetSuggestionBySearchTextFromHistoryAsync(query.SearchText, query.UserCode);
            }
            catch (Exception ex)
            {
                // Log the exception (logging mechanism not shown in this snippet)
                Console.WriteLine($"Error in HandleAsync(FindSuggestionsBySearchTextFromHistoryQuery): {ex.Message}");
                return new List<SearchSuggestion>(); // Return an empty list or handle as needed
            }
        }

        public async Task<List<SearchSuggestion>> HandleAsync(FindSuggestionsBySearchTextQuery query)
        {
            try
            {
                return await _searchRepository.GetSuggestionBySearchTextAsync(query.SearchText);
            }
            catch (Exception ex)
            {
                // Log the exception
                Console.WriteLine($"Error in HandleAsync(FindSuggestionsBySearchTextQuery): {ex.Message}");
                return new List<SearchSuggestion>(); // Return an empty list or handle as needed
            }
        }

        public async Task<List<SearchSuggestion>> HandleAsync(FindSuggestionsBySearchKeyQuery query)
        {
            List<SearchSuggestion> closeMatchContents = new();

            if (string.IsNullOrEmpty(query.SearchText))
            {
                return new List<SearchSuggestion>();
            }

            List<SearchSuggestion> rowSearchResult = new();
            dynamic result = string.Empty;

            try
            {
                string[] nameList;

                // Lock around memory cache access
                lock (_cacheLock)
                {
                    bool isNameListCached = _memoryCache.TryGetValue(query.SearchText.ToUpper().Trim(), out nameList);
                    bool isRowSearchResultCached = _memoryCache.TryGetValue(query.SearchText + "Row".ToUpper().Trim(), out rowSearchResult);

                    if (!isNameListCached && !isRowSearchResultCached)
                    {
                        // Retrieve the search suggestions asynchronously
                        rowSearchResult = _searchRepository.GetSuggestionBySearchKeyAsync(query.SearchText).Result; // Use .Result to avoid async issues inside lock

                        // Extract names from the search suggestions
                        nameList = rowSearchResult.Select(suggestion => suggestion.Type + ":" + suggestion.ContentId + ":" + suggestion.ParentId + ":" + suggestion.ContentName + ":" + suggestion.Artist + ":" + suggestion.TrackType + ":" + suggestion.ImageUrl + ":" + suggestion.PlayUrl).ToArray();

                        //Cache artist_names for 60 minutes
                        var cacheEntryOptions = new MemoryCacheEntryOptions()
                            .SetSize(rowSearchResult.Count) // Set the size of the cache entry to the number of items in the list
                            .SetSlidingExpiration(TimeSpan.FromMinutes(10))
                            .SetAbsoluteExpiration(TimeSpan.FromMinutes(10)); // Absolute expiration after 10 minutes   

                        // Cache artist_names for 10 minutes
                        _memoryCache.Set(query.SearchText.ToUpper().Trim(), nameList, cacheEntryOptions);
                        _memoryCache.Set(query.SearchText + "Row".ToUpper().Trim(), rowSearchResult, cacheEntryOptions);
                    }
                }

                if (query.SearchText.Length != 1)
                {
                    // Calling python script to get matching names from the given arrays
                    result = _ironPythonExecutor.ExecutePythonScript(nameList, query.SearchText, query.Limit);

                    try
                    {
                        // Converting type 'Python.Runtime.PyObject' to 'List<Tuple<string, int>>'
                        foreach (PythonTuple item in result)
                        {
                            string name = item[0].ToString();
                            decimal score = Int32.Parse(item[1].ToString());
                            string[] nameParts = name.Split(':');

                            closeMatchContents.Add(new SearchSuggestion
                            {
                                Source = "DB",
                                ContentId = nameParts[1],
                                ContentName = nameParts[3],
                                Artist = nameParts[4],
                                Type = nameParts[0],
                                Similarity = score,
                                GroupNumber = 0,
                            });
                        }
                    }
                    finally
                    {
                        // Clean up any Python objects that may need disposal
                        if (result != null && result is PythonList)
                        {
                            foreach (PythonTuple item in result)
                            {
                                if (item is IDisposable disposableItem)
                                {
                                    disposableItem.Dispose();
                                }
                            }
                        }

                        // Null the result object to allow garbage collection
                        result = null;

                    }

                    using (DataTable myTable = new DataTable())
                    {
                        myTable.Columns.Add("ContentId", typeof(int));
                        myTable.Columns.Add("ContentType", typeof(string));

                        foreach (var item in closeMatchContents)
                        {
                            myTable.Rows.Add(item.ContentId, item.Type);
                        }

                        List<ItemUrls> itemUrls = await _searchRepository.GetItemUrlsAsync(myTable);

                        // Join the lists
                        List<SearchSuggestion> joinedList = (from closeMatchContent in closeMatchContents
                                                             join itemUrl in itemUrls
                                                             on new { closeMatchContent.ContentId, ContentType = closeMatchContent.Type }
                                                             equals new { itemUrl.ContentId, itemUrl.ContentType }
                                                             select new SearchSuggestion
                                                             {
                                                                 Source = closeMatchContent.Source,
                                                                 ContentId = closeMatchContent.ContentId,
                                                                 ParentId = itemUrl.ParentId,
                                                                 ContentName = closeMatchContent.ContentName,
                                                                 Artist = closeMatchContent.Artist,
                                                                 Type = closeMatchContent.Type,
                                                                 Similarity = closeMatchContent.Similarity,
                                                                 GroupNumber = closeMatchContent.GroupNumber,
                                                                 TrackType = itemUrl.TrackType,
                                                                 ImageUrl = itemUrl.ImageUrl,
                                                                 PlayUrl = itemUrl.PlayUrl
                                                             }).ToList();

                        return joinedList;
                    }
                }
                else
                {
                    using (DataTable myTable = new DataTable())
                    {
                        myTable.Columns.Add("ContentId", typeof(int));
                        myTable.Columns.Add("ContentType", typeof(string));

                        // Use LINQ to project the list into DataRows
                        foreach (var item in rowSearchResult)
                        {
                            myTable.Rows.Add(item.ContentId, item.Type);
                        }

                        List<ItemUrls> itemUrls2 = await _searchRepository.GetItemUrlsAsync(myTable);

                        // Join the lists
                        List<SearchSuggestion> joinedList2 = (from closeMatchContent in rowSearchResult
                                                              join itemUrl in itemUrls2
                                                              on new { closeMatchContent.ContentId, ContentType = closeMatchContent.Type }
                                                              equals new { itemUrl.ContentId, itemUrl.ContentType }
                                                              select new SearchSuggestion
                                                              {
                                                                  Source = closeMatchContent.Source,
                                                                  ContentId = closeMatchContent.ContentId,
                                                                  ParentId = itemUrl.ParentId,
                                                                  ContentName = closeMatchContent.ContentName,
                                                                  Artist = closeMatchContent.Artist,
                                                                  Type = closeMatchContent.Type,
                                                                  Similarity = closeMatchContent.Similarity,
                                                                  GroupNumber = closeMatchContent.GroupNumber,
                                                                  TrackType = itemUrl.TrackType,
                                                                  ImageUrl = itemUrl.ImageUrl,
                                                                  PlayUrl = itemUrl.PlayUrl
                                                              }).ToList();

                        return joinedList2;
                    }
                }
            }
            catch (Exception ex)
            {
                // Log the exception
                Console.WriteLine($"Error in HandleAsync(FindSuggestionsBySearchKeyQuery): {ex.Message}");
                return new List<SearchSuggestion>(); // Return an empty list or handle as needed
            }
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (_disposed)
                return;

            if (disposing)
            {
                // Dispose managed resources
                _ironPythonExecutor?.Dispose();
            }

            // Free unmanaged resources

            _disposed = true;
        }
    }
}