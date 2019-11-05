using System.Web.Http;

using SpobberApi.Attributes;
using SpobberApi.Models;
using SpobberApi.Statics;

namespace SpobberApi.Controllers
{
    public class ObjectsController : ApiController
    {
        [HttpGet]
        public IHttpActionResult GetShortRailObject([FromUri] ObjectRequest objectRequest)
        {
            return Ok(DatabaseManager.GetShortRailObjects(objectRequest, objectRequest.Source.Split(','), false));
        }

        [Route("api/objects/{id}")]
        [HttpGet]
        public IHttpActionResult GetRailObjectWithSecret(string id)
        {
            return Ok(new RailObject[] { DatabaseManager.GetRailObject(id) });
        }

        [HttpGet, Route("api/objects/{id:int}")]
        public IHttpActionResult GetRailObjectsWithId(int id)
        {
            return Ok(new ShortRailObject[] { DatabaseManager.GetShortRailObject(id) });
        }

        /*[Route("api/objects")]
        [HttpPost]
        public void PostRailObject([FromBody] RailObject railObject)
        {
            DatabaseManager.UpdateRailObject(railObject);
        }*/
    }
}
