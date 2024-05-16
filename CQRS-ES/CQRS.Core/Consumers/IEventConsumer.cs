namespace CQRS.Core.Consumers
{
    /// <summary>
    /// Event consumer Interface
    /// </summary>
    public interface IEventConsumer
    {
        void Consume(string topic);
    }
}