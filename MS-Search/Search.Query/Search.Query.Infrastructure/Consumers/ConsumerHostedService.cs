using CQRS.Core.Consumers;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace Search.Query.Infrastructure.Consumers
{
    /// <summary>
    /// Implement a consumer hosted service that represent a Background task
    /// it will start listening new event messages from the message bus as soon as the microservice starta up
    /// </summary>
    public class ConsumerHostedService : IHostedService
    {
        //adding logger to logging some information to the container log
        private readonly ILogger<ConsumerHostedService> _logger;

        //we need to retived event consumer service from the scope services and IServiceProvide is just allow to do that 
        private readonly IServiceProvider _serviceProvider;


        //resolving the dependencies 
        public ConsumerHostedService(ILogger<ConsumerHostedService> logger, IServiceProvider serviceProvider)
        {
            _logger = logger;
            _serviceProvider = serviceProvider;
        }

        public Task StartAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("Event Consumer Service running.");
            
            //getting event consumer service from the scope service
            using (IServiceScope scope = _serviceProvider.CreateScope())
            {
                var eventConsumer = scope.ServiceProvider.GetRequiredService<IEventConsumer>();

                //getting topic from the appsettings
                var topic = Environment.GetEnvironmentVariable("KAFKA_TOPIC");
                
                //invoking event consumer event method
                Task.Run(() => eventConsumer.Consume(topic), cancellationToken);
            }

            return Task.CompletedTask;
        }

        public Task StopAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation("Event Consumer Service Stopped");

            return Task.CompletedTask;
        }
    }
}