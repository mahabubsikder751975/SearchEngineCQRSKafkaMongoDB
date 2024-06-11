using System.Reflection;
using CQRS.Core.Events;
using MongoDB.Driver;

namespace CQRS.Core.Domain
{
    /// <summary> Mahabub(03032024): CTO, Shadhin Music Ltd
    /// The design of the aggregate should be allow us to able to use the events to recreate 
    /// or replay the latest state of the aggregate, so that we don't have to query the read database
    /// for the latest state, else the hard separation of commands and queries would be in vain.
    /// Aggregate root is the entity within the aggregate that is responsible for keeping the aggregate in a consistent state
    /// Achive aggregate By assisting the aggregate to raise events, apply changes to the aggregate state, keeping track of uncommited changes
    /// and replaying the latest state of the aggregate
    /// </summary>
    public abstract class AggregateRoot
    {
        protected Guid _id;
        private readonly List<BaseEvent> _changes=new();   
        public Guid Id { get{return _id; } }
        public int Version { get; set; }= -1;

        public IEnumerable<BaseEvent> GetUncommittedChanges(){
            return _changes;
        }
         public void MarkChangesAsCommited()
         {
            _changes.Clear();    
         }
        
        private void ApplyChanges(BaseEvent @event, bool IsNew){
            var method= this.GetType().GetMethod("Apply", new Type[]{@event.GetType()});
            if (method==null){
                throw new ArgumentNullException(nameof(method), $"The Apply method was not found in the aggregate for {@event.GetType().Name} !");
            }

            method.Invoke(this, new object[] {@event} );

            if (IsNew){
                _changes.Add(@event);
            }
        }

        protected void RaiseEvent(BaseEvent @event){
            ApplyChanges(@event,true);
        }

        public void ReplayEvents(IEnumerable<BaseEvent> events){
            foreach (var @event in events)
            {
                ApplyChanges(@event,false);
            }
        }
    }
}