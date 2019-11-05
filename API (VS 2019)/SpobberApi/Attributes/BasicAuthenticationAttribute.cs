using System;
using System.Net;
using System.Net.Http;
using System.Security.Principal;
using System.Threading;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

using SpobberApi.Statics;

namespace SpobberApi.Attributes
{
    public class BasicAuthenticationAttribute : AuthorizationFilterAttribute
    {
        public override void OnAuthorization(HttpActionContext actionContext)
        {
            try
            {
                if (actionContext.Request.Headers.Authorization != null)
                {
                    var authToken = actionContext.Request.Headers.Authorization.Parameter;
                    var decoAuthToken = System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(authToken));
                    var UserNameAndPassword = decoAuthToken.Split(':');

                    if (DatabaseManager.IsAuthorizedUser(UserNameAndPassword[0], UserNameAndPassword[1]))
                        Thread.CurrentPrincipal = new GenericPrincipal(new GenericIdentity(UserNameAndPassword[0]), null);
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