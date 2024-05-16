using System.ComponentModel.DataAnnotations;
using CQRS.Core.Infrastructure;
using CQRS.Core.Queries;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Formatters;
using Microsoft.Extensions.Options;
using Search.Common.DTOs;
using Search.Query.Api.DTOs;
using Search.Query.Api.Queries;
using Search.Query.Domain.DTOs;
using Search.Query.Domain.Entities;

namespace Search.Query.Api.Controllers
{
    [ApiController]
    [Route("api/v1/[controller]")]    
    public class SearchLookupController : ControllerBase
    {
        private readonly BasicSetting _basicSetting;
        private readonly ILogger<SearchLookupController> _logger;
        private readonly IQueryDispatcher<SearchEntity> _queryDispatcher;

        private readonly IQueryDispatcher<SearchContent> _queryDispatcherContent;

        private readonly IQueryDispatcher<PlayListItem> _queryDispatcherPlayListItem;

        private readonly IQueryDispatcher<SearchSuggestion> _queryDispatcherSuggestion;

        private readonly IQueryDispatcher<SearchHistory> _queryDispatcherSearchHistory;
        public SearchLookupController(ILogger<SearchLookupController> logger, IQueryDispatcher<SearchEntity> queryDispatcher
        , IQueryDispatcher<SearchContent> queryDispatcherContent, IQueryDispatcher<SearchSuggestion> queryDispatcherSuggestion
        ,IQueryDispatcher<PlayListItem> queryDispatcherPlayListItem
        ,IQueryDispatcher<SearchHistory> queryDispatcherSearchHistory
       , BasicSetting basicSetting

        )
        {
            _logger = logger;
            _queryDispatcher = queryDispatcher;
            _queryDispatcherContent = queryDispatcherContent;
            _queryDispatcherSuggestion = queryDispatcherSuggestion;
            _queryDispatcherPlayListItem = queryDispatcherPlayListItem;
            _queryDispatcherSearchHistory = queryDispatcherSearchHistory;  
            _basicSetting = basicSetting;          
        }

        [HttpGet]
        public async Task<ActionResult> GetAllSearchsAsync()
        {
            try
            {
                var searches = await _queryDispatcher.SendAsync(new FindAllSearchesQuery());
                return NormalResponse(searches);
            }
            catch (Exception ex)
            {
                const string SAFE_ERROR_MESSAGE = "Error while processing request to retrieve all searches!";
                return ErrorResponse(ex, SAFE_ERROR_MESSAGE);
            }
        }

        [HttpGet("byId/{searchId}")]
        public async Task<ActionResult> GetBySearchIdAsync(Guid searchId)
        {
            try
            {
                var searches = await _queryDispatcher.SendAsync(new FindSearchByIdQuery { Id = searchId });

                if (searches == null || !searches.Any())
                    return NoContent();

                return Ok(new SearchLookupResponse
                {
                    Searches = searches,
                    Message = "Successfully returned search!"
                });
            }
            catch (Exception ex)
            {
                const string SAFE_ERROR_MESSAGE = "Error while processing the request!";
                return ErrorResponse(ex, SAFE_ERROR_MESSAGE);
            }
        }

        [HttpGet("byUserName/{username}")]
        public async Task<ActionResult> GetSearchesByAuthorAsync(string username)
        {
            try
            {
                var searches = await _queryDispatcher.SendAsync(new FindSearchesByUserNameQuery { UserName = username });
                return NormalResponse(searches);
            }
            catch (Exception ex)
            {
                const string SAFE_ERROR_MESSAGE = "Error while processing the request!";
                return ErrorResponse(ex, SAFE_ERROR_MESSAGE);
            }
        }

       [HttpGet("GetAllContentsByText")]
        public async Task<ActionResult> GetAllContentsBySearchTextAsync([Required] string searchText,[Required] string contentType, int client, int countryValue)
        {
            try
            {
                List<SearchContent> contents = await _queryDispatcherContent.SendAsync(new FindContentsBySearchTextQuery { 
                    SearchText = searchText,
                    ConentType =  contentType,
                    Client=client,
                    CountryValue=countryValue
                    });

                contents.ForEach(x =>
                {
                    x.ImageUrl = _basicSetting.content_url.ToString() + x.ImageUrl.ToString();
                   // x.PlayUrl = _basicSetting.content_url.ToString() + x.PlayUrl.ToString();;
                    // Add more property updates as needed
                });                
            
                return Ok(new SearchContentResponse
                {
                    Contents = contents,
                    Message = "Successfully returned the contents!"
                });
            }
            catch (Exception ex)
            {
                const string SAFE_ERROR_MESSAGE = "Error while processing the request!";
                return ErrorResponse(ex, SAFE_ERROR_MESSAGE);
            }
        }

        [HttpGet("GetAllContentsBySearchTextMatch")]
        public async Task<ActionResult> GetAllContentsBySearchTextMatchAsync([Required] string searchText,[Required] string userCode, int client, int countryValue)
        {
            List<SearchSuggestion> searchResult=new();
            try
            {
                 List<SearchSuggestion> searchSuggestion1 = await _queryDispatcherSuggestion.SendAsync(new FindSuggestionsBySearchTextFromHistoryQuery { 
                    SearchText = searchText,
                    UserCode =  userCode
                    });
                foreach (var item in searchSuggestion1)
                {
                    searchResult.Add(item);
                }                

                List<SearchSuggestion> searchSuggestion2 = await _queryDispatcherSuggestion.SendAsync(new FindSuggestionsBySearchTextQuery { 
                    SearchText = searchText                    
                    });
                
                foreach (var item in searchSuggestion2)
                {
                    searchResult.Add(item);
                }

                SearchSuggestion searchSuggestion = searchResult.FirstOrDefault();

                var contents = await _queryDispatcherContent.SendAsync(new FindContentsBySearchTextQuery { 
                    SearchText = searchSuggestion.ContentName,
                    ConentType =  searchSuggestion.Type,
                    Client=client,
                    CountryValue=countryValue
                    });
                
                 contents.ForEach(x =>
                {
                    x.ImageUrl = _basicSetting.content_url.ToString() + x.ImageUrl.ToString();
                    //x.PlayUrl = _basicSetting.content_url.ToString() + x.PlayUrl.ToString();;
                    // Add more property updates as needed
                });    
         

                return Ok(new SearchContentResponse
                {
                    Contents = contents,
                    Message = "Successfully returned the contents!"
                });
            }
            catch (Exception ex)
            {
                const string SAFE_ERROR_MESSAGE = "Error while processing the request!";
                return ErrorResponse(ex, SAFE_ERROR_MESSAGE);
            }
        }

        [HttpGet("GetContentsByCategoryTypeAsync")]
        public async Task<ActionResult> GetContentsByCategoryTypeAsync([Required] string searchText, [Required]string contentType, int client, int countryValue)
        {
            try
            {
                var contents = await _queryDispatcherContent.SendAsync(new FindContentsByCategoryTypeQuery { 
                    SearchText = searchText,
                    ConentType =  contentType,
                    Client=client,
                    CountryValue=countryValue
                    });
                
                contents.ForEach(x =>
                {
                    x.ImageUrl = _basicSetting.content_url.ToString() + x.ImageUrl.ToString();
                   // x.PlayUrl = _basicSetting.content_url.ToString() + x.PlayUrl.ToString();;
                    // Add more property updates as needed
                });    


                return Ok(new SearchContentResponse
                {
                    Contents = contents,
                    Message = "Successfully returned the contents!"
                });

            }
            catch (Exception ex)
            {
                const string SAFE_ERROR_MESSAGE = "Error while processing the request!";
                return ErrorResponse(ex, SAFE_ERROR_MESSAGE);
            }
        }

        [HttpGet("GetSuggestionByTextFromHistory")]
        public async Task<ActionResult> GetSuggestionsBySearchTextFromHistoryAsync([Required] string searchText,[Required] string userCode)
        {
            try
            {
                var contents = await _queryDispatcherSuggestion.SendAsync(new FindSuggestionsBySearchTextFromHistoryQuery { 
                    SearchText = searchText,
                    UserCode =  userCode
                    });
                

                if (contents == null || !contents.Any())
                    return NoContent();

                return Ok(new SearchSuggestionResponse
                {
                    Contents = contents,
                    Message = "Successfully returned the contents!"
                });
            }
            catch (Exception ex)
            {
                const string SAFE_ERROR_MESSAGE = "Error while processing the request!";
                return ErrorResponse(ex, SAFE_ERROR_MESSAGE);
            }
        }

        [HttpGet("GetSuggestionByText")]
        public async Task<ActionResult> GetSuggestionsBySearchTextAsync([Required] string searchText)
        {
            try
            {
                var contents = await _queryDispatcherSuggestion.SendAsync(new FindSuggestionsBySearchTextQuery { 
                    SearchText = searchText                    
                    });
                

                if (contents == null || !contents.Any())
                    return NoContent();

                return Ok(new SearchSuggestionResponse
                {
                    Contents = contents,
                    Message = "Successfully returned the contents!"
                });
            }
            catch (Exception ex)
            {
                const string SAFE_ERROR_MESSAGE = "Error while processing the request!";
                return ErrorResponse(ex, SAFE_ERROR_MESSAGE);
            }
        }


        [HttpGet("GetTopPlayList")]        
        public async Task<ActionResult> GetTopPlayListAsync(int pageSize)
        {
            try
            {
                var contents = await _queryDispatcherPlayListItem.SendAsync(new FindTopPlayListQuery { 
                    PageSize = pageSize                    
                    });
                
                contents.ForEach(x =>
                {
                    x.ImageUrl = _basicSetting.content_url.ToString() + x.ImageUrl.ToString();
                    x.PlayUrl = _basicSetting.content_url.ToString() + x.PlayUrl.ToString();;
                    // Add more property updates as needed
                });    

                if (contents == null || !contents.Any())
                    return NoContent();

                return Ok(new DefaultPlayListResponse
                {
                    Contents = contents,
                    Message = "Successfully returned the contents!"
                });
            }
            catch (Exception ex)
            {
                const string SAFE_ERROR_MESSAGE = "Error while processing the request!";
                return ErrorResponse(ex, SAFE_ERROR_MESSAGE);
            }
        }

        [HttpGet("GetSearchHistories")]
        public async Task<ActionResult> GetSearchHistories(string userCode)
        {
            try
            {
                var contents = await _queryDispatcherSearchHistory.SendAsync(new FindSearchHistoryListQuery { 
                    UserCode = userCode                    
                    });
                
                contents.ForEach(x =>
                {
                    x.ImageUrl = _basicSetting.content_url.ToString() + x.ImageUrl.ToString();
                   // x.PlayUrl = _basicSetting.content_url.ToString() + x.PlayUrl.ToString();;
                    // Add more property updates as needed
                });     

                if (contents == null || !contents.Any())
                    return NoContent();

                return Ok(new DefaultSearchHistoryResponse
                {
                    Contents = contents,
                    Message = "Successfully returned the contents!"
                });
            }
            catch (Exception ex)
            {
                const string SAFE_ERROR_MESSAGE = "Error while processing the request!";
                return ErrorResponse(ex, SAFE_ERROR_MESSAGE);
            }
        }

        private ActionResult NormalResponse(List<SearchEntity> searches)
        {
            if (searches == null || !searches.Any())
                return NoContent();

            var count = searches.Count;
            return Ok(new SearchLookupResponse
            {
                Searches = searches,
                Message = $"Successfully returned {count} content{(count > 1 ? "s" : string.Empty)}!"
            });
        }

        private ActionResult ErrorResponse(Exception ex, string safeErrorMessage)
        {
            _logger.LogError(ex, safeErrorMessage);

            return StatusCode(StatusCodes.Status500InternalServerError, new BaseResponse
            {
                Message = safeErrorMessage
            });
        }
    }

   
}