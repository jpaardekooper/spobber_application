using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using SpobberApi.Models.Authentication;
using SpobberApi.Statics;

namespace SpobberApi.Controllers
{
    public class AuthenticationController : ApiController
    {
        [HttpGet, Route("api/authentication")]
        public object GetLoginToken()
        {
            if (!ActionContext.Request.Headers.TryGetValues("username", out IEnumerable<string> username) ||
                !ActionContext.Request.Headers.TryGetValues("password", out IEnumerable<string> password))
                return new HttpResponseMessage(HttpStatusCode.Unauthorized);

            UserLogin login = new UserLogin { Username = username.First(), Password = password.First() };
            if(DatabaseManager.IsAuthorizedUser(login.Username, login.Password))
                return new ReturnToken(login.Username, Users.AddUser(login.Username));
            else
                return new HttpResponseMessage(HttpStatusCode.Unauthorized);
        }

        [HttpPost, Route("api/authentication/register")]
        public HttpResponseMessage PostRegister([FromBody] UserRegistration register)
        {
            if (DatabaseManager.RegisterUser(register.Email, register.Username, register.Password))
                return new HttpResponseMessage(HttpStatusCode.OK);
            else
                return new HttpResponseMessage(HttpStatusCode.Unauthorized);
        }
    }
}
