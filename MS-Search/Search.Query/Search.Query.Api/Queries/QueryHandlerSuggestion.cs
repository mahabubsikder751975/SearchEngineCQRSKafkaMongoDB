using IronPython.Runtime;
using Microsoft.Extensions.Caching.Memory;
using Search.Query.Api.DTOs;
using Search.Query.Api.Helper;
using Search.Query.Domain.DTOs;
using Search.Query.Domain.Entities;
using Search.Query.Domain.Repositories;
using System.Data;
using System.Linq;

namespace Search.Query.Api.Queries
{
    /// <summary>
    /// Implement a query handler that depends on search repository
    /// </summary>
    public class QueryHandlerSuggestion : IQueryHandlerSuggestion
    {
        private readonly ISearchRepository _searchRepository;
        private IMemoryCache _memoryCache;
        private object _cacheLock = new object();
        IronPythonExecutor _ironPythonExecutor;


        public QueryHandlerSuggestion(ISearchRepository searchRepository)
        {
            _searchRepository = searchRepository;
            _ironPythonExecutor = new();
        }

        //Handle the final Search Query that invokes the list       

        public async Task<List<SearchSuggestion>> HandleAsync(FindSuggestionsBySearchTextFromHistoryQuery query)
        {
            return await _searchRepository.GetSuggestionBySearchTextFromHistoryAsync(query.SearchText,query.UserCode);
        }

        public async Task<List<SearchSuggestion>> HandleAsync(FindSuggestionsBySearchTextQuery query)
        {
            return await _searchRepository.GetSuggestionBySearchTextAsync(query.SearchText);
 
        }

        public async Task<List<SearchSuggestion>> HandleAsync(FindSuggestionsBySearchKeyQuery query)
        {
            _memoryCache = query.MemoryCache;
            _ironPythonExecutor = new();

            // Create the DataTable
            DataTable myTable = new DataTable();
            myTable.Columns.Add("ContentId", typeof(int));
            myTable.Columns.Add("ContentType", typeof(string));
            
            List<SearchSuggestion> closeMatchContents = new();

            if (string.IsNullOrEmpty(query.SearchText))
            {
                return new List<SearchSuggestion>();
            }

            List<SearchSuggestion> rowSearchResult=new();
            dynamic result = string.Empty;

            if (!string.IsNullOrEmpty(query.SearchText))
            {
                string firstLetter = query.SearchText;
                string[] nameList;

                // Lock around memory cache access
                lock (_cacheLock)
                {
                    
                    bool isNameListCached = _memoryCache.TryGetValue(query.SearchText, out nameList);
                    bool isRowSearchResultCached = _memoryCache.TryGetValue(query.SearchText + "Row", out rowSearchResult);

                    if (!isNameListCached && !isRowSearchResultCached)
                    {
                        // Retrieve the search suggestions asynchronously
                         rowSearchResult = _searchRepository.GetSuggestionBySearchKeyAsync(query.SearchText).Result; // Use .Result to avoid async issues inside lock

                        // Extract names from the search suggestions
                        nameList = rowSearchResult.Select(suggestion => suggestion.Type +":"+ suggestion.ContentId +":"+ suggestion.ParentId +":"+ suggestion.ContentName+":"+ suggestion.Artist+":"+ suggestion.TrackType+":"+ suggestion.ImageUrl+":"+ suggestion.PlayUrl).ToArray();
                        //nameList = rowSearchResult.Select(suggestion => suggestion.Type +":"+ suggestion.ContentId +":"+ suggestion.ContentName+":"+ suggestion.TrackType).ToArray();

                        //Cache artist_names for 10 minutes

                        _memoryCache.Set(query.SearchText, nameList, TimeSpan.FromMinutes(10));
                        _memoryCache.Set(query.SearchText+"Row", rowSearchResult, TimeSpan.FromMinutes(10));
                    }
                }
          

                if (query.SearchText.Length != 1)
                {                   
                    // Calling python script to get matching names from the given arrays
                    result = _ironPythonExecutor.ExecutePythonScript(nameList, query.SearchText,query.Limit);

                    // Converting type 'Python.Runtime.PyObject' to 'List<Tuple<string, int>>'                    

                    foreach (PythonTuple item in result)
                    {
                        string name = item[0].ToString();
                        decimal score = Int32.Parse(item[1].ToString());
                        string cType = name.Split(":")[0];
                        string contentId = name.Split(":")[1];
                        string parentId = name.Split(":")[2];
                        string cName = name.Split(":")[3];   
                        string cartist = name.Split(":")[4]; 

                        string trackType = name.Split(":")[5];                        
                        string imageUrl = name.Split(":")[6];   
                        string playUrl = name.Split(":")[7];                           

                        closeMatchContents.Add(new SearchSuggestion { 
                           Source= "DB", 
                           ContentId= contentId,
                           ContentName= cName,
                           Artist = cartist,
                           Type= cType,
                           Similarity= score,
                           GroupNumber = 0,
                         });
                         
                        myTable.Rows.Add(contentId,cType);

                    }

                    List<ItemUrls> itemUrls = await _searchRepository.GetItemUrlsAsync(myTable);
            
                     // Join the lists
                    List<SearchSuggestion> joinedList = (from closeMatchContent in closeMatchContents
                         join itemUrl in itemUrls
                         on new { closeMatchContent.ContentId, ContentType = closeMatchContent.Type }
                         equals new { itemUrl.ContentId, itemUrl.ContentType }
                         select new SearchSuggestion
                         {
                            
                             Source=closeMatchContent.Source,
                             ContentId= closeMatchContent.ContentId,
                             ParentId= itemUrl.ParentId,
                             ContentName= closeMatchContent.ContentName, 
                             Artist =  closeMatchContent.Artist,                           
                             Type= closeMatchContent.Type,
                             Similarity= closeMatchContent.Similarity,
                             GroupNumber= closeMatchContent.GroupNumber,
                             TrackType= itemUrl.TrackType,
                             ImageUrl= itemUrl.ImageUrl,
                             PlayUrl= itemUrl.PlayUrl
                         }).ToList();

                    
                    return joinedList;
                }
                else{

                     // Use LINQ to project the list into DataRows
                    foreach (var item in rowSearchResult)
                    {
                         myTable.Rows.Add(item.ContentId,item.Type);
                    }
                       
                 
                    List<ItemUrls> itemUrls2 = await _searchRepository.GetItemUrlsAsync(myTable);

                // Join the lists
                    List<SearchSuggestion> joinedList2 = (from closeMatchContent in rowSearchResult
                    join itemUrl in itemUrls2
                    on new { closeMatchContent.ContentId, ContentType = closeMatchContent.Type  }
                    equals new { itemUrl.ContentId, itemUrl.ContentType}
                    select new SearchSuggestion
                    {
                    
                        Source=closeMatchContent.Source,
                        ContentId= closeMatchContent.ContentId,
                        ParentId= itemUrl.ParentId,
                        ContentName= closeMatchContent.ContentName, 
                        Artist =  closeMatchContent.Artist,                            
                        Type= closeMatchContent.Type,
                        Similarity= closeMatchContent.Similarity,
                        GroupNumber= closeMatchContent.GroupNumber,
                        TrackType= itemUrl.TrackType,
                        ImageUrl= itemUrl.ImageUrl,
                        PlayUrl= itemUrl.PlayUrl
                    }).ToList();


                    return joinedList2;
                }                
            }

           
            


          

            return rowSearchResult;
        }

        

    }
}