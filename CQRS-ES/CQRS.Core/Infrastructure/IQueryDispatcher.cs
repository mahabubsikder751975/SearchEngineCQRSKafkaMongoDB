using CQRS.Core.Queries;

namespace CQRS.Core.Infrastructure
{
    public interface IQueryDispatcher<Object>
    {
        //Registering query handler: it will take in a function delegate with the input parameter TQuery
        //And then we'll always return a list of entities which could be a search entity
        //TQuery must extends BaseQuery
        void RegisterHandler<TQuery>(Func<TQuery, Task<List<Object>>> handler) where TQuery : BaseQuery;
        //void RegisterHandler<TQuery, TResult>(Func<TQuery, Task<List<TResult>>> handler) where TQuery : BaseQuery;
        //Base should be substitutable for a concrete or specialized type
        //So, pass in any of the concrete query type as opposed to the base query
        Task<List<Object>> SendAsync(BaseQuery query);
    }
}