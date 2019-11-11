using System;
using System.Net;
using System.Net.Http;
using System.Security.Principal;
using System.Threading;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;
using System.Collections.Generic;
using System.Linq;

using SpobberApi.Statics;

namespace SpobberApi.Attributes
{
    public class BasicAuthenticationAttribute : AuthorizationFilterAttribute
    {
        public override void OnAuthorization(HttpActionContext actionContext)
        {
            try
            {
                if (actionContext.Request.Headers.TryGetValues("username", out IEnumerable<string> username))
                {
                    actionContext.Request.Headers.TryGetValues("token", out IEnumerable<string> tokenC);
                    string token = tokenC.First() ?? string.Empty;

                    if (token != string.Empty && DatabaseManager.IsAuthorizedUser(username.First(), token))
                        Users.RefreshUser(username.First(), token);
                    else
                        actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
                }
                else
                    actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
            }
            catch (Exception ex)
            {
                ex.Message.ToString();
            }
        }
    }
}