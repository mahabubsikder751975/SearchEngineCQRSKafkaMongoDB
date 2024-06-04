using Confluent.Kafka;
using CQRS.Core.Consumers;
using Microsoft.EntityFrameworkCore;
using Search.Query.Infrastructure.Consumers;
using Search.Query.Domain.Repositories;
using Search.Query.Infrastructure.Consumers;
using Search.Query.Infrastructure.DataAccess;
using Search.Query.Infrastructure.Handlers;
using Search.Query.Infrastructure.Repositories;
using Search.Query.Api.Queries;
using Search.Query.Infrastructure.Dispatchers;
using CQRS.Core.Infrastructure;
using Search.Query.Domain.Entities;
using Search.Query.Domain.DTOs;
using Search.Query.Api.DTOs;
using Microsoft.Extensions.Caching.Memory;

var builder = WebApplication.CreateBuilder(args);

//Enable CORS
 builder.Services.AddCors();
// Add services to the container.
//Action<DbContextOptionsBuilder> configureDbContext = o => o.UseLazyLoadingProxies().UseSqlServer(builder.Configuration.GetConnectionString("SqlServer"));
Action<DbContextOptionsBuilder> configureDbContext;
var env = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");

if (env.Equals("Development.PostgreSQL"))
{
    configureDbContext = o => o.UseLazyLoadingProxies().UseNpgsql(builder.Configuration.GetConnectionString("SqlServer"));
}
else
{
    configureDbContext = o => o.UseLazyLoadingProxies().UseSqlServer(builder.Configuration.GetConnectionString("SqlServer"));
}

BasicSetting  basicSetting = new();

basicSetting.content_url = builder.Configuration.GetSection("BasicSetting:content_url").Value;
basicSetting.news_image_url = builder.Configuration.GetSection("BasicSetting:news_image_url").Value;
basicSetting.news_content_url = builder.Configuration.GetSection("BasicSetting:news_content_url").Value;
basicSetting.data_url = builder.Configuration.GetSection("BasicSetting:data_url").Value;
basicSetting.data_url_v4 = builder.Configuration.GetSection("BasicSetting:data_url_v4").Value;
basicSetting.comments_url = builder.Configuration.GetSection("BasicSetting:comments_url").Value;
basicSetting.notification_url = builder.Configuration.GetSection("BasicSetting:notification_url").Value;
basicSetting.reffer_message = builder.Configuration.GetSection("BasicSetting:reffer_message").Value;
basicSetting.paid_podcast_wav = builder.Configuration.GetSection("BasicSetting:paid_podcast_wav").Value;
basicSetting.paid_podcast_type = builder.Configuration.GetSection("BasicSetting:paid_podcast_type").Value.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);

builder.Services.AddSingleton<BasicSetting>(_ = basicSetting);
// Add caching services
builder.Services.AddMemoryCache(); // Add memory caching


builder.Services.AddDbContext<DatabaseContext>(configureDbContext);
builder.Services.AddSingleton<DatabaseContextFactory>(new DatabaseContextFactory(configureDbContext));

// create database and tables
var dataContext = builder.Services.BuildServiceProvider().GetRequiredService<DatabaseContext>();
//dataContext.Database.EnsureCreated();

builder.Services.AddScoped<ISearchRepository, SearchRepository>();
builder.Services.AddScoped<IQueryHandler, QueryHandler>();
builder.Services.AddScoped<IQueryHandlerContent, QueryHandlerContent>();
builder.Services.AddScoped<IQueryHandlerPlayList, QueryHandlerPlayList>();
builder.Services.AddScoped<IQueryHandlerSuggestion, QueryHandlerSuggestion>();
builder.Services.AddScoped<IQueryHandlerSearchHistory, QueryHandlerSearchHistory>();

builder.Services.AddScoped<IEventHandler, Search.Query.Infrastructure.Handlers.EventHandler>();
builder.Services.Configure<ConsumerConfig>(builder.Configuration.GetSection(nameof(ConsumerConfig)));
builder.Services.Configure<BasicSetting>(builder.Configuration.GetSection(nameof(BasicSetting)));

builder.Services.AddScoped<IEventConsumer, EventConsumer>();

// register query handler methods
var queryHandler = builder.Services.BuildServiceProvider().GetRequiredService<IQueryHandler>();
var queryHandlerContent = builder.Services.BuildServiceProvider().GetRequiredService<IQueryHandlerContent>();
var queryHandlerSuggestion = builder.Services.BuildServiceProvider().GetRequiredService<IQueryHandlerSuggestion>();
var queryHandlerPlayList = builder.Services.BuildServiceProvider().GetRequiredService<IQueryHandlerPlayList>();
var queryHandlerSearchHistory = builder.Services.BuildServiceProvider().GetRequiredService<IQueryHandlerSearchHistory>();

var dispatcher = new QueryDispatcher();
var dispatcherContent = new QueryDispatcherContent();
var dispatcherSuggestion = new QueryDispatcherSuggestion();
var dispatcherPlayList = new QueryDispatcherPlayList();

var dispatcherSearchHistory = new QueryDispatcherSearchHistory();


dispatcher.RegisterHandler<FindAllSearchesQuery>(queryHandler.HandleAsync);
dispatcher.RegisterHandler<FindSearchByIdQuery>(queryHandler.HandleAsync);
dispatcher.RegisterHandler<FindSearchesByUserNameQuery>(queryHandler.HandleAsync);

dispatcherContent.RegisterHandler<FindContentsBySearchTextQuery>(queryHandlerContent.HandleAsync);
dispatcherContent.RegisterHandler<FindContentsByCategoryTypeQuery>(queryHandlerContent.HandleAsync);

dispatcherPlayList.RegisterHandler<FindTopPlayListQuery>(queryHandlerPlayList.HandleAsync);
dispatcherSearchHistory.RegisterHandler<FindSearchHistoryListQuery>(queryHandlerSearchHistory.HandleAsync);

dispatcherSuggestion.RegisterHandler<FindSuggestionsBySearchTextFromHistoryQuery>(queryHandlerSuggestion.HandleAsync);
dispatcherSuggestion.RegisterHandler<FindSuggestionsBySearchTextQuery>(queryHandlerSuggestion.HandleAsync);
dispatcherSuggestion.RegisterHandler<FindSuggestionsBySearchKeyQuery>(queryHandlerSuggestion.HandleAsync);

//register a singleton service for the query dispatcher
builder.Services.AddSingleton<IQueryDispatcher<SearchEntity>>(_ => dispatcher);
builder.Services.AddSingleton<IQueryDispatcher<SearchContent>>(_ = dispatcherContent);
builder.Services.AddSingleton<IQueryDispatcher<SearchSuggestion>>(_ = dispatcherSuggestion);
builder.Services.AddSingleton<IQueryDispatcher<PlayListItem>>(_ = dispatcherPlayList);
builder.Services.AddSingleton<IQueryDispatcher<SearchHistory>>(_ = dispatcherSearchHistory);

builder.Services.AddControllers();
builder.Services.AddHostedService<ConsumerHostedService>();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

//Using CORS
app.UseCors(builder => builder
                .AllowAnyHeader()
                .AllowAnyMethod()
                .SetIsOriginAllowed((host) => true)
                .AllowCredentials()
            );

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

// Get the cache service from the service provider


app.Run();
