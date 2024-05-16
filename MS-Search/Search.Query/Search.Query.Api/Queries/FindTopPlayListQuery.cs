using CQRS.Core.Queries;

namespace Search.Query.Api.Queries
{
    public class FindTopPlayListQuery : BaseQuery
    {
        // Default page size is set to 10
        // public int PageSize { get; set; } = 10;

        private int _pageSize;

        public int PageSize
        {
            get { return _pageSize; }
            set { _pageSize = value == 0 ? 10 : value; }
        }
    }
}