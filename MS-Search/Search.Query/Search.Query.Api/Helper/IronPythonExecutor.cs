namespace Search.Query.Api.Helper
{
    using IronPython.Hosting;
    using Microsoft.Extensions.Configuration;
    using Microsoft.Extensions.Hosting;
    using System;
    using System.IO;
    using System.Linq;

    public class IronPythonExecutor : IDisposable
    {
        private readonly dynamic _engine;
        private readonly dynamic _scope;
        private readonly string _scriptPath;
        private bool _disposed;

        public IronPythonExecutor()
        {
            // Initialize Python engine and scope
            _engine = Python.CreateEngine();
            _scope = _engine.CreateScope();

            // Get and set Python search paths
            var searchPaths = _engine.GetSearchPaths();
            var pythonPackagePath = Path.Combine(AppContext.BaseDirectory, "IronPythonPackages");
            searchPaths.Add(pythonPackagePath); // Add the Python package path
            _engine.SetSearchPaths(searchPaths);

            // Load .NET assemblies
            _engine.Runtime.LoadAssembly(typeof(Enumerable).Assembly); // Load .NET assemblies

            // Store the script path
            _scriptPath = Path.Combine(AppContext.BaseDirectory, "Helper", "MatchingScore.py");
        }

        public dynamic ExecutePythonScript(string[] searchingIndex, string searchText, int limit)
        {
            if (_disposed)
                throw new ObjectDisposedException(nameof(IronPythonExecutor));

            // Set variables in the scope
            _scope.SetVariable("searchingIndex", searchingIndex);
            _scope.SetVariable("searchText", searchText);

            // Pass the limit parameter when calling the findmatch function        
            _scope.SetVariable("topLimit", limit);

            // Execute the script file
            _engine.ExecuteFile(_scriptPath, _scope);

            // Get and call the custom function from the script
            dynamic customFunction = _scope.GetVariable("findmatch");
            dynamic result = customFunction(searchText, searchingIndex, limit);

            return result;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (_disposed)
                return;

            if (disposing)
            {
                // Dispose managed resources
                (_scope as IDisposable)?.Dispose();
                (_engine as IDisposable)?.Dispose();
            }

            // Free unmanaged resources

            _disposed = true;
        }
    }
}


