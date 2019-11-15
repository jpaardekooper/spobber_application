using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

using SpobberApi.Statics;
using SpobberApi.Models;
using SpobberApi.Controllers.Flutter;

namespace SpobberApi.Controllers.Flutter
{
    public class FlutterController : ApiController
    {
        [HttpGet, Route("api/objects/flutter/{id}")]
        public HttpResponseMessage GetObjectForm(string id)
        {
            RailObject railObject = DatabaseManager.GetRailObject(id);
            FlutterParser parser = new FlutterParser(railObject.GetType(), railObject);

            HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StringContent(parser.ParseObject(FlutterParser.ContainerTypes.COLUMN))
            };
            return response;
        }
    }
}
