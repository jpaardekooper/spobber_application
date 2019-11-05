using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using SpobberApi.Statics;
using SpobberApi.Models;

namespace SpobberApi.Controllers
{
    public class PingController : ApiController
    {
        [HttpGet, Route("api/ping")]
        public HttpResponseMessage GetPing([FromBody] ReturnToken userToken)
        {
            if (Users.CheckToken(userToken.Username, userToken.Token))
                return new HttpResponseMessage(HttpStatusCode.OK);
            else
                return new HttpResponseMessage(HttpStatusCode.Unauthorized);
        }
    }
}
