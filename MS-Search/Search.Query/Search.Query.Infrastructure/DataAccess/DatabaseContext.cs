using System.Data;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Search.Query.Domain.DTOs;
using Search.Query.Domain.Entities;

namespace Search.Query.Infrastructure.DataAccess
{
    public class DatabaseContext : DbContext
    {
        public DatabaseContext(DbContextOptions options) : base(options)
        {
        }

        public DbSet<SearchEntity> Searches { get; set; }    
        public DbSet<SearchHistoryEntity> SearchHistories { get; set; }      
      

        public async Task<List<SearchContent>> GetSearchCategoryContentAsync(string searchText, string contentType, int client, int countryValue)
        {
            var searchContents = new List<SearchContent>();

            var parameters = new[]
            {
                new SqlParameter("@p_searchText", searchText),
                new SqlParameter("@p_contentType", contentType),
                new SqlParameter("@client", client),
                new SqlParameter("@countryValue", countryValue)
            };

            using (var connection = new SqlConnection(Database.GetDbConnection().ConnectionString))
            {
                await connection.OpenAsync();
                using (var command = connection.CreateCommand())
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "[Music_Streaming].[dbo].[spCategoryContentSearchV6.1]";
                    command.Parameters.AddRange(parameters);

                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            var searchContent = new SearchContent
                            {                           
                                // Map reader columns to properties of your SearchContent DTO
                                // For example:
                                // Property1 = reader["ColumnName1"] != DBNull.Value ? (int)reader["ColumnName1"] : 0,
                                // Property2 = reader["ColumnName2"] != DBNull.Value ? (string)reader["ColumnName2"] : null,
                                // etc.
                                ContentId = reader["id"] != DBNull.Value ? reader["id"].ToString() : null,
                                ContentType = reader["ContentType"] != DBNull.Value ? reader["ContentType"].ToString() : null,
                                ArtistId = reader["artistid"] != DBNull.Value ? reader["artistid"].ToString() : null,
                                Artist = reader["artist"] != DBNull.Value ? reader["artist"].ToString() : null,
                                ImageUrl = reader["ImageUrl"] != DBNull.Value ? reader["ImageUrl"].ToString() : null,                                
                                Title =  reader["title"] != DBNull.Value ? reader["title"].ToString() : null,
                                PlayUrl =  reader["PlayUrl"] != DBNull.Value ? reader["PlayUrl"].ToString() : null,
                                AlbumId =  reader["AlbumId"] != DBNull.Value ? reader["AlbumId"].ToString() : null,
                                AlbumTitle =  reader["AlbumTitle"] != DBNull.Value ? reader["AlbumTitle"].ToString() : null,
                                ResultType =  reader["ResultType"] != DBNull.Value ? reader["ResultType"].ToString() : null
                            };

                            searchContents.Add(searchContent);
                        }
                    }
                }
            }

            return searchContents;
        }

        public async Task<List<SearchContent>> GetContentByCategoryTypeAsync(string searchText, string contentType, int client, int countryValue)
        {
            var searchContents = new List<SearchContent>();

            var parameters = new[]
            {
                new SqlParameter("@p_searchText", searchText),
                new SqlParameter("@p_contentType", contentType),
                new SqlParameter("@client", client),
                new SqlParameter("@countryValue", countryValue)
            };

            using (var connection = new SqlConnection(Database.GetDbConnection().ConnectionString))
            {
                await connection.OpenAsync();
                using (var command = connection.CreateCommand())
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "[Music_Streaming].[dbo].[usp_GetContentbyType]";
                    command.Parameters.AddRange(parameters);

                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            var searchContent = new SearchContent
                            {                           
                                // Map reader columns to properties of your SearchContent DTO
                                // For example:
                                // Property1 = reader["ColumnName1"] != DBNull.Value ? (int)reader["ColumnName1"] : 0,
                                // Property2 = reader["ColumnName2"] != DBNull.Value ? (string)reader["ColumnName2"] : null,
                                // etc.
                                ContentId = reader["id"] != DBNull.Value ? reader["id"].ToString() : null,      
                                ContentType = reader["ContentType"] != DBNull.Value ? reader["ContentType"].ToString() : null,                                 
                                ArtistId = reader["artistid"] != DBNull.Value ? reader["artistid"].ToString() : null,
                                Artist = reader["artist"] != DBNull.Value ? reader["artist"].ToString() : null,
                                ImageUrl = reader["ImageUrl"] != DBNull.Value ? reader["ImageUrl"].ToString() : null,   
                                Title =  reader["title"] != DBNull.Value ? reader["title"].ToString() : null,
                                PlayUrl =  reader["PlayUrl"] != DBNull.Value ? reader["PlayUrl"].ToString() : null,
                                AlbumId =  reader["AlbumId"] != DBNull.Value ? reader["AlbumId"].ToString() : null,
                                AlbumTitle =  reader["AlbumTitle"] != DBNull.Value ? reader["AlbumTitle"].ToString() : null,
                                ResultType =  reader["ResultType"] != DBNull.Value ? reader["ResultType"].ToString() : null
                            };

                            searchContents.Add(searchContent);
                        }
                    }
                }
            }

            return searchContents;
        }

        public async Task<List<SearchSuggestion>> GetSearchSuggestionsFromHistoryAsync(string searchText, string userCode)
        {
             var searchSuggestions = new List<SearchSuggestion>();

            var parameters = new[]
            {
                new SqlParameter("@p_userCode", userCode),     
                new SqlParameter("@p_searchText", searchText),                          
            };

            using (var connection = new SqlConnection(Database.GetDbConnection().ConnectionString))
            {
                await connection.OpenAsync();
                using (var command = connection.CreateCommand())
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "[Music_Streaming].[dbo].[usp_getSearchCloseMatchHistory]";
                    command.Parameters.AddRange(parameters);

                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            var searchSuggestion = new SearchSuggestion
                            {                           
                                // Map reader columns to properties of your SearchContent DTO
                                // For example:
                                // Property1 = reader["ColumnName1"] != DBNull.Value ? (int)reader["ColumnName1"] : 0,
                                // Property2 = reader["ColumnName2"] != DBNull.Value ? (string)reader["ColumnName2"] : null,
                                // etc.
                                Source = reader["Source"] != DBNull.Value ? reader["Source"].ToString() : null,
                                ContentId = reader["ContentId"] != DBNull.Value ? reader["ContentId"].ToString() : null,
                                ContentName = reader["ContentName"] != DBNull.Value ? reader["ContentName"].ToString() : null,
                                Type =  reader["type"] != DBNull.Value ? reader["type"].ToString() : null,
                                Similarity = reader["Similarity"] != DBNull.Value ? decimal.Parse(reader["Similarity"].ToString()) : 0,
                                GroupNumber = reader["group_rn"] != DBNull.Value ? Int32.Parse(reader["group_rn"].ToString()) : 0,
                            };

                            searchSuggestions.Add(searchSuggestion);
                        }
                    }
                }
            }

            return searchSuggestions;
        }

        public async Task<List<SearchSuggestion>> GetSearchSuggestionsAsync(string searchText)
        {
             var searchSuggestions = new List<SearchSuggestion>();

            var parameters = new[]
            {                  
                new SqlParameter("@p_searchText", searchText),                          
            };

            using (var connection = new SqlConnection(Database.GetDbConnection().ConnectionString))
            {
                await connection.OpenAsync();
                using (var command = connection.CreateCommand())
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "[Music_Streaming].[dbo].[usp_getSearchCloseMatchDB]";
                    command.Parameters.AddRange(parameters);

                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            var searchSuggestion = new SearchSuggestion
                            {                           
                                // Map reader columns to properties of your SearchContent DTO
                                // For example:
                                // Property1 = reader["ColumnName1"] != DBNull.Value ? (int)reader["ColumnName1"] : 0,
                                // Property2 = reader["ColumnName2"] != DBNull.Value ? (string)reader["ColumnName2"] : null,
                                // etc.
                                Source = reader["Source"] != DBNull.Value ? reader["Source"].ToString() : null,
                                ContentId = reader["ContentId"] != DBNull.Value ? reader["ContentId"].ToString() : null,
                                ContentName = reader["ContentName"] != DBNull.Value ? reader["ContentName"].ToString() : null,
                                Type =  reader["type"] != DBNull.Value ? reader["type"].ToString() : null,
                                Similarity = reader["Similarity"] != DBNull.Value ? decimal.Parse(reader["Similarity"].ToString()) : 0,
                                GroupNumber = reader["group_rn"] != DBNull.Value ? Int32.Parse(reader["group_rn"].ToString()) : 0,
                            };

                            searchSuggestions.Add(searchSuggestion);
                        }
                    }
                }
            }

            return searchSuggestions;
        } 

        public async Task<List<PlayListItem>> GetDefaultPlayListAsync(int pageSize)
        {
            var searchSuggestions = new List<PlayListItem>();
         
            var parameters = new[]
            {                  
                new SqlParameter("@PageSize", pageSize),                          
            };

            using (var connection = new SqlConnection(Database.GetDbConnection().ConnectionString))
            {
                await connection.OpenAsync();
                using (var command = connection.CreateCommand())
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "[Music_Streaming].[dbo].[usp_GetTopPlayList]";
                    command.Parameters.AddRange(parameters);

                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            var searchSuggestion = new PlayListItem
                            {                           
                                // Map reader columns to properties of your SearchContent DTO
                                // For example:
                                // Property1 = reader["ColumnName1"] != DBNull.Value ? (int)reader["ColumnName1"] : 0,
                                // Property2 = reader["ColumnName2"] != DBNull.Value ? (string)reader["ColumnName2"] : null,
                                // etc.
                                // PlayListId=reader["PlayListId"] != DBNull.Value ? reader["PlayListId"].ToString() : null,
                                // PlayListName = reader["PlayListName"] != DBNull.Value ? reader["PlayListName"].ToString() : null,
                                // Image = reader["Image"] != DBNull.Value ? reader["Image"].ToString() : null,
                                // Expired = reader["expired"] != DBNull.Value ? reader["expired"].ToString() : null,
                                // GenreId = reader["GenreId"] != DBNull.Value ? reader["GenreId"].ToString() : null
                                ContentId = reader["id"] != DBNull.Value ? reader["id"].ToString() : null,  
                                ContentType = reader["ContentType"] != DBNull.Value ? reader["ContentType"].ToString() : null,                               
                                ArtistId = reader["artistid"] != DBNull.Value ? reader["artistid"].ToString() : null,
                                Artist = reader["artist"] != DBNull.Value ? reader["artist"].ToString() : null,
                                ImageUrl = reader["ImageUrl"] != DBNull.Value ? reader["ImageUrl"].ToString() : null,   
                                Title =  reader["title"] != DBNull.Value ? reader["title"].ToString() : null,
                                PlayUrl =  reader["PlayUrl"] != DBNull.Value ? reader["PlayUrl"].ToString() : null,
                                AlbumId =  reader["AlbumId"] != DBNull.Value ? reader["AlbumId"].ToString() : null,
                                AlbumTitle =  reader["AlbumTitle"] != DBNull.Value ? reader["AlbumTitle"].ToString() : null,
                                ResultType =  reader["ResultType"] != DBNull.Value ? reader["ResultType"].ToString() : null
                            };

                            searchSuggestions.Add(searchSuggestion);
                        }
                    }
                }
            }

            return searchSuggestions;
        }    

        public async Task<List<SearchHistory>> GetSearchHistoryListAsync(string UserCode)
        {
            var searchHistoryList = new List<SearchHistory>();
         
            var parameters = new[]
            {                  
                new SqlParameter("@userCode", UserCode),                          
            };

            using (var connection = new SqlConnection(Database.GetDbConnection().ConnectionString))
            {
                await connection.OpenAsync();
                using (var command = connection.CreateCommand())
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.CommandText = "[Music_Streaming].[dbo].[usp_GetUserSearchHistory]";
                    command.Parameters.AddRange(parameters);

                    using (var reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            var searchHistory = new SearchHistory
                            {                           
                                // Map reader columns to properties of your SearchContent DTO
                                // For example:
                                // Property1 = reader["ColumnName1"] != DBNull.Value ? (int)reader["ColumnName1"] : 0,
                                // Property2 = reader["ColumnName2"] != DBNull.Value ? (string)reader["ColumnName2"] : null,
                                // etc.
                                Id=reader["id"] != DBNull.Value ? reader["id"].ToString() : null,
                                ContentId = reader["ContentId"] != DBNull.Value ? reader["ContentId"].ToString() : null,
                                Type=reader["type"] != DBNull.Value ? reader["type"].ToString() : null,                                
                                Title=reader["title"] != DBNull.Value ? reader["title"].ToString() : null,
                                ImageUrl=reader["image"] != DBNull.Value ? reader["image"].ToString() : null,
                                Artist =reader["artist"] != DBNull.Value ? reader["artist"].ToString() : null,
                                PlayUrl=reader["PlayUrl"] != DBNull.Value ? reader["PlayUrl"].ToString() : null,
                                Image=reader["image"] != DBNull.Value ? reader["image"].ToString() : null,
                                Duration=reader["duration"] != DBNull.Value ? Int32.Parse(reader["duration"].ToString()) : 0,
                                CreateDate=reader["CreateDate"] != DBNull.Value ? reader["CreateDate"].ToString() : null,
                                TrackType = reader["TrackType"] != DBNull.Value ? reader["TrackType"].ToString() : null
                               
                            };

                            searchHistoryList.Add(searchHistory);
                        }
                    }
                }
            }

            return searchHistoryList;
        }    



    }
}