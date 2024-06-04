using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using MongoDB.Bson;
using Search.Query.Domain.DTOs;
using Search.Query.Domain.Entities;
using Search.Query.Domain.Repositories;
using Search.Query.Infrastructure.DataAccess;

namespace Search.Query.Infrastructure.Repositories
{
    public class SearchRepository : ISearchRepository
    {
        //Get a new instance of database context
        private readonly DatabaseContextFactory _contextFactory;

        public SearchRepository(DatabaseContextFactory contextFactory)
        {
            _contextFactory = contextFactory;
        }
  
        public async Task CreateAsync(SearchEntity search)
        {
            using DatabaseContext context = _contextFactory.CreateDbContext();
            context.Searches.Add(search);

            _ = await context.SaveChangesAsync();
        }

        public async Task DeleteAsync(Guid searchId)
        {
            using DatabaseContext context = _contextFactory.CreateDbContext();
            var search = await GetByIdAsync(searchId);

            if (search == null) return;

            context.Searches.Remove(search);
            _ = await context.SaveChangesAsync();
        }

        public async Task<List<SearchEntity>> ListByUserNameAsync(string userName)
        {
            using DatabaseContext context = _contextFactory.CreateDbContext();
            return await context.Searches.AsNoTracking()                    
                    .Where(x => x.UserName.Contains(userName))
                    .ToListAsync();
        }

        public async Task<SearchEntity> GetByIdAsync(Guid searchId)
        {
            using DatabaseContext context = _contextFactory.CreateDbContext();
            //context.Database.ExecuteSqlRawAsync();
            return await context.Searches                    
                    .FirstOrDefaultAsync(x => x.SearchId == searchId);
        }

        public async Task<SearchHistoryEntity> GetByHistoryIdAsync(Guid searchHistoryId)
        {
            using DatabaseContext context = _contextFactory.CreateDbContext();
            //context.Database.ExecuteSqlRawAsync();
            return await context.SearchHistories                    
                    .FirstOrDefaultAsync(x => x.Id == searchHistoryId);
        }

        public async Task<List<SearchEntity>> ListAllAsync()
        {
            //No tracking queries executes faster : .AsNoTracking()
            using DatabaseContext context = _contextFactory.CreateDbContext();
            return await context.Searches.AsNoTracking()
//                    .Include(i => i.Comments).AsNoTracking()
                    .ToListAsync();
        }

        public async Task<List<SearchContent>> GetContentsBySearchTextAsync(string searchText, string contentType, int client, int countryValue)
        {
            using DatabaseContext context = _contextFactory.CreateDbContext();
            List<SearchContent> searchContents = await context.GetSearchCategoryContentAsync(searchText, contentType, client, countryValue);          
        return searchContents;
        }

        public async Task<List<SearchContent>> GetContentsByCategoryTypeAsync(string searchText, string contentType, int client, int countryValue)
        {
            using DatabaseContext context = _contextFactory.CreateDbContext();
            List<SearchContent> searchContents = await context.GetContentByCategoryTypeAsync(searchText, contentType, client, countryValue);          
        return searchContents;
        }

        public async Task<List<SearchSuggestion>> GetSuggestionBySearchTextFromHistoryAsync(string searchText, string UserCode)
        {
            using DatabaseContext context = _contextFactory.CreateDbContext();
            List<SearchSuggestion> searchSuggestions = await context.GetSearchSuggestionsFromHistoryAsync(searchText, UserCode);
            return searchSuggestions;
        }

        public async Task<List<SearchSuggestion>> GetSuggestionBySearchTextAsync(string searchText)
        {
            using DatabaseContext context = _contextFactory.CreateDbContext();
            List<SearchSuggestion> searchSuggestions = await context.GetSearchSuggestionsAsync(searchText);
            return searchSuggestions;
        }

        public async Task<List<PlayListItem>> GetDefaultPlayListAsync(int pageSize)
        {
            using DatabaseContext context = _contextFactory.CreateDbContext();
            List<PlayListItem> searchSuggestions = await context.GetDefaultPlayListAsync(pageSize);
            return searchSuggestions;
        }

        public async Task<List<SearchHistory>> GetSearchHistoriesByUserNameAsync(string userCode)
        {
            using DatabaseContext context = _contextFactory.CreateDbContext();
            List<SearchHistory> searchHistories = await context.GetSearchHistoryListAsync(userCode);
            return searchHistories;
        }

        public async Task CreateAsync(SearchHistoryEntity search)
        {
              using DatabaseContext context = _contextFactory.CreateDbContext();
            context.SearchHistories.Add(search);

            _ = await context.SaveChangesAsync();
        }

        public async Task<List<SearchHistoryEntity>> SearchHistoryListByUserCodeAsync(string userCode)
        {
            using DatabaseContext context = _contextFactory.CreateDbContext();
            return await context.SearchHistories.AsNoTracking()                    
                    .Where(x => x.UserCode.Contains(userCode))
                    .ToListAsync();
        }

        public async Task DeleteHistoryAsync(Guid searchHistoryId)
        {
            using DatabaseContext context = _contextFactory.CreateDbContext();
            SearchHistoryEntity search = await GetByHistoryIdAsync(searchHistoryId);

            if (search == null) return;
            
            search.IsDeleted = true;
            context.SearchHistories.Update(search);
            _ = await context.SaveChangesAsync();
        }
      

        public async Task DeleteAllHistoryAsync(string UserCode)
        {
            using DatabaseContext context = _contextFactory.CreateDbContext();
            List<SearchHistoryEntity> searchHistoryList = await SearchHistoryListByUserCodeAsync(UserCode);

            if (searchHistoryList == null || !searchHistoryList.Any())
            {
                return;
            }
            
            searchHistoryList.ForEach(x =>
            {
                x.IsDeleted=true;
            });   
                        
            context.SearchHistories.UpdateRange(searchHistoryList);
            _ = await context.SaveChangesAsync();
        }

        public async Task<List<SearchSuggestion>> GetSuggestionBySearchKeyAsync(string searchText)
        {
            using DatabaseContext context = _contextFactory.CreateDbContext();
            List<SearchSuggestion> searchSuggestions = await context.GetSearchSuggestionsBySearchKeyAsync(searchText);            
            return searchSuggestions;
        }

        public async Task<List<ItemUrls>> GetItemUrlsAsync(DataTable dataTable)
        {
            using DatabaseContext context = _contextFactory.CreateDbContext();
            List<ItemUrls> itemUrls = await context.GetItemUrlsAsync(dataTable);            
            return itemUrls;        
        }
    }
}
