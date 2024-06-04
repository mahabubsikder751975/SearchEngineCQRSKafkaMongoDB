using Confluent.Kafka;
using CQRS.Core.Domain;
using CQRS.Core.Handlers;
using CQRS.Core.Infrastructure;
using CQRS.Core.Producers;
using Search.Cmd.Infrastructure.Producers;
using Search.Cmd.Api.Commands;
using Search.Cmd.Domain.Aggregates;
using Search.Cmd.Infrastructure.Config;
using Search.Cmd.Infrastructure.Dispatchers;
using Search.Cmd.Infrastructure.Handlers;
using Search.Cmd.Infrastructure.Repositories;
using Search.Cmd.Infrastructure.Stores;

var builder = WebApplication.CreateBuilder(args);

//Enable CORS
 builder.Services.AddCors();

// Add services to the container.
builder.Services.Configure<MongoDBConfig>(builder.Configuration.GetSection(nameof(MongoDBConfig)));
builder.Services.Configure<ProducerConfig>(builder.Configuration.GetSection(nameof(ProducerConfig)));
builder.Services.AddScoped<IEventStoreRepository, EventStoreRepository>();
builder.Services.AddScoped<IEventProducer, EventProducer>();
builder.Services.AddScoped<IEventStore,EventStore>();
builder.Services.AddScoped<IEventSourcingHandler <SearchAggregate> ,EventSourcingHandler>();        
builder.Services.AddScoped<IEventSourcingHandler <SearchHistoryAggregate> ,EventSourcingHandlerSearchHistory>();

builder.Services.AddScoped<ICommandHandler,CommandHandler>();

var commandHandler = builder.Services.BuildServiceProvider().GetRequiredService<ICommandHandler>();
var dispatcher = new CommandDispatcher();
dispatcher.RegisterHandle<NewSearchCommand>(commandHandler.HandleAsync);
dispatcher.RegisterHandle<DeleteSearchCommand>(commandHandler.HandleAsync);
dispatcher.RegisterHandle<RestoreReadDbCommand>(commandHandler.HandleAsync);

dispatcher.RegisterHandle<NewSearchHistoryCommand>(commandHandler.HandleAsync);
dispatcher.RegisterHandle<DeleteSearchHistoryCommand>(commandHandler.HandleAsync);
dispatcher.RegisterHandle<DeleteAllSearchHistoryCommand>(commandHandler.HandleAsync);

builder.Services.AddSingleton<ICommandDispatcher>(_ => dispatcher);
 
builder.Services.AddControllers();
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

app.Run();

