using CQRS.Core.Commands;
using CQRS.Core.Infrastructure;

namespace Search.Cmd.Infrastructure.Dispatchers
{
    /// <summary>
    /// Implement the register handler and send async methods
    /// </summary>
    public class CommandDispatcher : ICommandDispatcher
    {  
        //Handler dictionary: using type as dictionary key and the value will specify a function delegate.
        //So, the input parameter would be base command and the output would be Task
        private readonly Dictionary<Type,Func<BaseCommand,Task>> _handlers = new();
        /// <summary>
        /// Register Handlers
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="handler"></param>
        /// <exception cref="IndexOutOfRangeException"></exception>
        public void RegisterHandle<T>(Func<T, Task> handler) where T : BaseCommand
        {
             //Checking if a handler already contains the specified command type
            if (_handlers.ContainsKey(typeof(T)))
            {
                throw new IndexOutOfRangeException("You cannot register the same command handler twice !");
            }

            //Add the handler into handlers dictionary by casting the BaseCommand to TQuery((TQuery)x), which will be a concrete command type
            _handlers.Add(typeof(T),x=> handler((T)x));
        } 

        /// <summary>
        /// Dispatched the concrete query object to the command handlers
        /// </summary>
        /// <param name="command"></param>
        /// <returns></returns>
        /// <exception cref="ArgumentNullException"></exception>
        public async Task SendAsync(BaseCommand command)
        {
            //Checking if it has command handler
            if (_handlers.TryGetValue(command.GetType(),out Func<BaseCommand, Task> handler)){
                
                //invoke the registered command handler method
                await handler(command);
            }
            else{
                throw new ArgumentNullException(nameof(handler),"No command handler registered !");
            }
        }
    }
}