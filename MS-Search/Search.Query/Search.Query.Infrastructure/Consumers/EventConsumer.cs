using System.Text.Json;
using Confluent.Kafka;
using CQRS.Core.Consumers;
using CQRS.Core.Events;
using Microsoft.Extensions.Options;
using Search.Query.Infrastructure.Converters;
using Search.Query.Infrastructure.Handlers;

namespace Search.Query.Infrastructure.Consumers
{
    /// <summary>
    /// Create concrete Event consumer to consuming all of the search text events from Kafka
    /// </summary>
    public class EventConsumer : IEventConsumer
    {
        private readonly ConsumerConfig _config;
        private readonly IEventHandler _eventHandler;

        public EventConsumer(
            IOptions<ConsumerConfig> config,
            IEventHandler eventHandler)
        {
            _config = config.Value;
            _eventHandler = eventHandler;
        }

        public void Consume(string topic)
        {
            //getting new instance of kafka consumer with key/value deserializer utf-8
            using var consumer = new ConsumerBuilder<string, string>(_config)
                    .SetKeyDeserializer(Deserializers.Utf8)
                    .SetValueDeserializer(Deserializers.Utf8)
                    .Build();
            
            //subscribe consumer to the topic
            consumer.Subscribe(topic);

            while (true)
            {
                var consumeResult = consumer.Consume();

                if (consumeResult?.Message == null) continue;
                
                //use the event JSON converter to do our polymorphic de-serialization
                var options = new JsonSerializerOptions { Converters = { new EventJsonConverter() } };
                
                //deserialize the JSON into event
                var @event = JsonSerializer.Deserialize<BaseEvent>(consumeResult.Message.Value, options);
                
                //using reflection to get the specific handler method on the event handler based on the event type
                if (@event==null) continue;
                
                var handlerMethod = _eventHandler.GetType().GetMethod("On", new Type[] { @event.GetType() });

                if (handlerMethod == null)
                {
                    throw new ArgumentNullException(nameof(handlerMethod), "Could not find event handler method!");
                }
               
               //if we get a handler method, invoke it
                handlerMethod.Invoke(_eventHandler, new object[] { @event });
                
                //tell the kafka that the event has been successfully consumed
                //it will increament the kafka commit log offset
                consumer.Commit(consumeResult);
            }
        }
    }
}
