using System.Text.Json;
using System.Text.Json.Serialization;
using CQRS.Core.Events;
using Search.Common.Events;

namespace Search.Query.Infrastructure.Converters
{
    /// <summary>
    /// Implement the event JSON converter, 
    /// which is a polymorphic JSON converter that determines which concrete event type the JSON should be serialized to.
    /// This will enable us to consume all event types that extend base event on the same topic regardless of the schema differences.
    /// This is because the default JSON converter is not able to do polymorphics data binding or de-serialization
    /// </summary>
    public class EventJsonConverter : JsonConverter<BaseEvent>
    {
        /// <summary>
        /// It will only convert if the type is assignable from the base event
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        public override bool CanConvert(Type type)
        {
            return type.IsAssignableFrom(typeof(BaseEvent));
        }

        public override BaseEvent Read(ref Utf8JsonReader reader, Type typeToConvert, JsonSerializerOptions options)
        {
            //Check if the JSON document is valid
            //Value cannot be parsed to adjacent document 
            if (!JsonDocument.TryParseValue(ref reader, out var doc))
            {
                throw new JsonException($"Failed to parse {nameof(JsonDocument)}");
            }

            //Check if we have a type property which is a discriminator property
            if (!doc.RootElement.TryGetProperty("Type", out var type))
            {
                throw new JsonException("Could not detect the Type discriminator property!");
            }

            var typeDiscriminator = type.GetString();
            var json = doc.RootElement.GetRawText();
            
            //Serialize concrete event type & throw a JSON exception if there's a type that's not in the switch cases.
            return typeDiscriminator switch
            {
                nameof(SearchCreatedEvent) => JsonSerializer.Deserialize<SearchCreatedEvent>(json, options),
                nameof(SearchRemovedEvent) => JsonSerializer.Deserialize<SearchRemovedEvent>(json, options),
                nameof(SearchHistoryCreatedEvent) => JsonSerializer.Deserialize<SearchHistoryCreatedEvent>(json, options),
                nameof(SearchHistoryRemovedEvent) => JsonSerializer.Deserialize<SearchHistoryRemovedEvent>(json, options),
                nameof(AllSearchHistoryRemovedEvent) => JsonSerializer.Deserialize<AllSearchHistoryRemovedEvent>(json, options),
                // _ => null
                _ => throw new JsonException($"{typeDiscriminator} is not supported yet!")
            };
        }

        public override void Write(Utf8JsonWriter writer, BaseEvent value, JsonSerializerOptions options)
        {
            throw new NotImplementedException();
        }
    }
}