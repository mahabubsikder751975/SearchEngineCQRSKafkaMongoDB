using Amazon.Auth.AccessControlPolicy;
using CQRS.Core.Domain;
using Search.Common.Events;

namespace Search.Cmd.Domain.Aggregates
{
    public class SearchAggregate : AggregateRoot
    {
        private bool _active;
        private string _username;
        private readonly Dictionary<Guid, Tuple<string,string>> _comments=new();

        public bool Active{
            get => _active; set => _active=value;
        }

        public SearchAggregate()
        {
            
        }

        public SearchAggregate(Guid id,string userName, string searchText)
        {
            RaiseEvent(
                new SearchCreatedEvent{
                    Id=id,
                    UserName=userName,
                    SearchText = searchText,
                    DateSearched = DateTime.Now
                }
            );
        }

        public void Apply(SearchCreatedEvent @event){
            _id=@event.Id;
            _active = true;
            _username= @event.UserName;

        }

        public void DeleteSearch(string userName){
            
            RaiseEvent(new SearchRemovedEvent{
                Id= _id
            });           
        }
        
        public void Apply(SearchRemovedEvent @event){
            _id=@event.Id;
            _active = false;    

        }      

    }
}