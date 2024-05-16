using CQRS.Core.Exceptions;
using CQRS.Core.Infrastructure;
using Microsoft.AspNetCore.Mvc;
using Search.Cmd.Api.Commands;
using Search.Common.DTOs;

namespace Search.Cmd.Api.Controllers
{
    [ApiController]
    [Route("api/v1/[controller]")]
    public class DeleteSearchController : ControllerBase
    {
        private readonly ILogger<DeleteSearchController> _logger;
        private readonly ICommandDispatcher _commandDispatcher;

        public DeleteSearchController(ILogger<DeleteSearchController> logger, ICommandDispatcher commandDispatcher)
        {
            _logger = logger;
            _commandDispatcher = commandDispatcher;
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> DeleteSearchAsync(Guid id, DeleteSearchCommand command)
        {
            try
            {
                command.Id = id;
                await _commandDispatcher.SendAsync(command);
                
                //If it is successful, it returns status 200
                return Ok(new BaseResponse
                {
                    Message = "Delete search request completed successfully!"
                });
            }
            catch (InvalidOperationException ex)//it will return an invalid operation status 400
            {
                _logger.Log(LogLevel.Warning, ex, "Client made a bad request!");
                return BadRequest(new BaseResponse
                {
                    Message = ex.Message
                });
            }
            catch (AggregateNotFoundException ex)
            {
                _logger.Log(LogLevel.Warning, ex, "Could not retrieve aggregate, client passed an incorrect search ID targetting the aggregate!");
                return BadRequest(new BaseResponse
                {
                    Message = ex.Message
                });
            }
            catch (Exception ex)//If an actual exception occurs through a status code 500 to delete: Internal server error
            {
                const string SAFE_ERROR_MESSAGE = "Error while processing request to delete a Search!";
                _logger.Log(LogLevel.Error, ex, SAFE_ERROR_MESSAGE);

                return StatusCode(StatusCodes.Status500InternalServerError, new BaseResponse
                {
                    Message = SAFE_ERROR_MESSAGE
                });
            }
        }            

    
    }
}