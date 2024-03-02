using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace ECSharp.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class HelloController : ControllerBase
    {
        private readonly IHttpClientFactory _clientFactory;

        public HelloController(IHttpClientFactory clientFactory)
        {
            _clientFactory = clientFactory;
        }

        [HttpGet("/hello")]
        public IActionResult SayHello()
        {
            Console.WriteLine("Received GET request on /hello");
            return Ok("Hello from C# microservice!");
        }

        [HttpPost("/handshake")]
        public async Task<IActionResult> Handshake()
        {
            using var reader = new StreamReader(Request.Body, Encoding.UTF8);
            var text = await reader.ReadToEndAsync();
            Console.WriteLine("Received POST request on /handshake with body: {0}", text);
            var requestContent = $"{text} Hello from C# microservice!";
            var url = "http://host.docker.internal:8085/handshake";
            
            var client = _clientFactory.CreateClient();
            try
            {
                var response = await client.PostAsync(url, new StringContent(requestContent, Encoding.UTF8, "text/plain"));
                
                if (response.IsSuccessStatusCode)
                {
                    var responseContent = await response.Content.ReadAsStringAsync();
                    return Ok(responseContent);
                }
                else
                {
                    var errorContent = await response.Content.ReadAsStringAsync();
                    return StatusCode((int)response.StatusCode, $"Error from remote service: {errorContent}");
                }
            }
            catch (HttpRequestException e)
            {
                return StatusCode(500, $"Network error: {e.Message}");
            }
        }
    }
}
