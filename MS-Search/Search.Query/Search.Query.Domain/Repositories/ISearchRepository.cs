using Search.Query.Domain.Entities;
using Search.Query.Domain.DTOs;
using System.Data;

namespace Search.Query.Domain.Repositories
{
    public interface ISearchRepository
    {
        Task CreateAsync(SearchEntity search);      
        Task CreateAsync(SearchHistoryEntity search);        
        Task DeleteAsync(Guid searchId);

        Task DeleteHistoryAsync(Guid searchHistoryId);

        Task DeleteAllHistoryAsync(string UserCode);

        Task<SearchEntity> GetByIdAsync(Guid searchId);        
        Task<List<SearchEntity>> ListAllAsync();
        Task<List<SearchEntity>> ListByUserNameAsync(string userName);

        Task<List<SearchContent>> GetContentsBySearchTextAsync(string searchText, string contentType, int client, int countryValue);

        Task<List<SearchContent>> GetContentsByCategoryTypeAsync(string searchText, string contentType, int client, int countryValue);

        Task<List<SearchSuggestion>> GetSuggestionBySearchTextFromHistoryAsync(string searchText, string UserName);

        Task<List<SearchSuggestion>> GetSuggestionBySearchTextAsync(string searchText);

         Task<List<PlayListItem>> GetDefaultPlayListAsync(int pageSize);

        Task<List<SearchHistory>> GetSearchHistoriesByUserNameAsync(string userCode);

        Task<List<SearchSuggestion>> GetSuggestionBySearchKeyAsync(string searchText);

        Task<List<ItemUrls>> GetItemUrlsAsync(DataTable dataTable);
    }
}