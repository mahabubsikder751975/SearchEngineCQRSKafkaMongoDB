using Microsoft.EntityFrameworkCore;

namespace Search.Query.Infrastructure.DataAccess
{
    public class DatabaseContextFactory
    {
        private readonly Action<DbContextOptionsBuilder> _configureDbContext;

        public DatabaseContextFactory(Action<DbContextOptionsBuilder> configureDbContext)
        {
            _configureDbContext = configureDbContext;
        }

        public DatabaseContext CreateDbContext()
        {
            DbContextOptionsBuilder<DatabaseContext> optionsBuilder = new();
            
            //An action always only takes in a single parameter and it has no return value
            _configureDbContext(optionsBuilder);

            return new DatabaseContext(optionsBuilder.Options);
        }
    }
}