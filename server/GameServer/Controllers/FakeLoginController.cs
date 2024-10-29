using Microsoft.AspNetCore.Mvc;
using GameServer.Services.Interfaces;
using GameServer.DTO;
using ServerShared;
using System.Text.Json;
using Prometheus;

namespace GameServer.Controllers;

[ApiController]
[Route("[controller]")]
public class FakeLoginController : BaseController<FakeLoginController> // ControllerBase
{
    private readonly ILogger<FakeLoginController> _logger;
    private readonly ILoginService _loginService;

    private static readonly Gauge FakeLoginGauge = Metrics.CreateGauge("game_server_fake_login", "Fake login Metric");

    public FakeLoginController(ILogger<FakeLoginController> logger, ILoginService loginService) : base(logger)
    {
        _logger = logger;
        _loginService = loginService;
    }

    [HttpPost]
    public async Task<GameLoginResponse> FakeLogin([FromBody] GameLoginRequest request)
    {
        FakeLoginGauge.Inc();

        try
        {
            
            var verifyTokenRequest = new VerifyTokenRequest
            {
                HiveUserId = request.PlayerId,
                HiveToken = request.Token
            };


            // ���� �α׸� JSON �������� ���
            ActionLog(new
            {
                action = "fake_login_success",
                playerId = request.PlayerId,
                //timestamp = DateTime.UtcNow
            });
    
            return new GameLoginResponse { Result = ErrorCode.None };
        }
        catch (HttpRequestException e)
        {
            // ���� ó�� �� �α� ���
            ActionLog(new
            {
                action = "login_error_http",
                exception = e.Message,
                //timestamp = DateTime.UtcNow
            });
            return new GameLoginResponse { Result = ErrorCode.ServerError };
        }
        catch (JsonException e)
        {
            // JSON �Ľ� ���� ó�� �� �α� ���
            ActionLog(new
            {
                action = "login_error_json",
                exception = e.Message,
                //timestamp = DateTime.UtcNow
            });
            return new GameLoginResponse { Result = ErrorCode.JsonParsingError };
        }
        catch (Exception e)
        {
            // �Ϲ� ���� ó�� �� �α� ���
            ActionLog(new
            {
                action = "login_error_unexpected",
                exception = e.Message,
                //timestamp = DateTime.UtcNow
            });
            return new GameLoginResponse { Result = ErrorCode.InternalError };
        }
    }

}
