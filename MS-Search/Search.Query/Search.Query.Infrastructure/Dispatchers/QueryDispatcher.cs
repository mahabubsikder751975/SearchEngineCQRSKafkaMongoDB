using CQRS.Core.Infrastructure;
using CQRS.Core.Queries;
using Search.Query.Domain.Entities;

namespace Search.Query.Infrastructure.Dispatchers
{
    /// <summary>
    /// Implement the register handler and send async methods
    /// </summary>
    ///     

    public class QueryDispatcher : IQueryDispatcher<SearchEntity>
    {
        //Handler dictionary: using type as dictionary key and the value will specify a function delegate.
        //So, the input parameter would be base query and the output would be Task list of entity
        private readonly Dictionary<Type, Func<BaseQuery, Task<List<SearchEntity>>>> _handlers = new();
        /// <summary>
        /// Register Handlers
        /// </summary>
        /// <typeparam name="TQuery"></typeparam>
        /// <param name="handler"></param>
        /// <exception cref="IndexOutOfRangeException"></exception>
        public void RegisterHandler<TQuery>(Func<TQuery, Task<List<SearchEntity>>> handler) where TQuery : BaseQuery
        {
            //Checking if a handler already contains the specified query and type
            if (_handlers.ContainsKey(typeof(TQuery)))
            {
                throw new IndexOutOfRangeException("You cannot register the same query handler twice!");
            }
            //Add the handler into handlers dictionary by casting the BaseQuery to TQuery((TQuery)x), which will be a concrete query type
            _handlers.Add(typeof(TQuery), x => handler((TQuery)x));
        }
        /// <summary>
        /// Dispatched the concrete query object to the query handlers
        /// </summary>
        /// <param name="query"></param>
        /// <returns></returns>
        /// <exception cref="ArgumentNullException"></exception>
        public async Task<List<SearchEntity>> SendAsync(BaseQuery query)
        {
            //Checking if it has query handler
            if (_handlers.TryGetValue(query.GetType(), out Func<BaseQuery, Task<List<SearchEntity>>> handler))
            {
                //invoke the registered query handler method
                return await handler(query);
            }

            throw new ArgumentNullException(nameof(handler), "No query handler was registered!");
        }
    }
}