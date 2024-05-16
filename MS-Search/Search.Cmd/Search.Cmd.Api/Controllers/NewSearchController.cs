using CQRS.Core.Infrastructure;
using Microsoft.AspNetCore.Mvc;
using Search.Cmd.Api.Commands;
using Search.Cmd.Api.DTOs;
using Search.Common.DTOs;

namespace Search.Cmd.Api.Controllers
{
    [ApiController]
    [Route("api/v1/[controller]")]
    public class NewSearchController: ControllerBase
    {
        private readonly ILogger<NewSearchController> _logger;
        private readonly ICommandDispatcher _commandDispatcher;

        public NewSearchController(ILogger<NewSearchController> logger, ICommandDispatcher commandDispatcher)
        {
            _logger = logger;
            _commandDispatcher = commandDispatcher;
        }

         [HttpPost]
        public async Task<ActionResult> NewPostAsync(NewSearchCommand command)
        {
            //Generate a new Id
            var id = Guid.NewGuid();
            try
            {
                //assign the ID to the command Id which target the aggregate id.
                command.Id = id;
                
                //using the commanddispather, dispach the commnd object to the relevant command handler.
                await _commandDispatcher.SendAsync(command);
                
                //if we have no errors, return status code 201 (Created)
                return StatusCode(StatusCodes.Status201Created, new NewSearchResponse
                {
                    Id = id,
                    Message = "New search creation request completed successfully!"
                });
            }
            catch (InvalidOperationException ex)
            {
                _logger.Log(LogLevel.Warning, ex, "Client made a bad request!");
                return BadRequest(new BaseResponse
                {
                    Message = ex.Message
                });
            }
            catch (Exception ex)
            {
                //We don't want to send the whole stack trace to the client because it's security concern.
                const string SAFE_ERROR_MESSAGE = "Error while processing request to create a new search!";
                _logger.Log(LogLevel.Error, ex, SAFE_ERROR_MESSAGE);
                
                //Instead, returning internal server error    
                return StatusCode(StatusCodes.Status500InternalServerError, new NewSearchResponse
                {
                    Id = id,
                    Message = SAFE_ERROR_MESSAGE
                });
            }
        }

    }
}