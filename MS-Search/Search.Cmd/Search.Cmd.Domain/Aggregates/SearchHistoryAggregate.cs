using Amazon.Auth.AccessControlPolicy;
using CQRS.Core.Domain;
using Search.Common.Events;

namespace Search.Cmd.Domain.Aggregates
{
    public class SearchHistoryAggregate : AggregateRoot
    {
        private bool _active;
        private string _usercode;
        //private readonly Dictionary<Guid, Tuple<string,string>> _comments=new();

        public bool Active{
            get => _active; set => _active=value;
        }

        public SearchHistoryAggregate()
        {
            
        }

        public SearchHistoryAggregate(Guid id,string userCode, string contentId, string type, string trackType)
        {
            RaiseEvent(
                new SearchHistoryCreatedEvent{
                    Id=id,
                    UserCode=userCode,
                    ContentId = contentId,
                    ContentType = type,
                    CreatedDate = DateTime.Now,
                    TrackType = trackType
                }
            );
        }


        public void Apply(SearchHistoryCreatedEvent @event){
            _id=@event.Id;
            _active = true;
            _usercode= @event.UserCode;

        }        

        public void DeleteSearchHistory(string userCode){
            
            RaiseEvent(new SearchHistoryRemovedEvent{
                Id= _id
            });           
        }
        
        public void Apply(SearchHistoryRemovedEvent @event){
            _id=@event.Id;
            _active = false;    

        }

    }
}