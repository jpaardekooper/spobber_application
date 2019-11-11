using System.Web.Http;

using SpobberApi.Attributes;
using SpobberApi.Models;
using SpobberApi.Statics;

namespace SpobberApi.Controllers
{
    public class ObjectsController : ApiController
    {
        #region Production
        [HttpGet]
        public IHttpActionResult GetShortRailObject([FromUri] ObjectRequest objectRequest)
        {
            return Ok(DatabaseManager.GetShortRailObjects(objectRequest, objectRequest.Source.Split(','), true));
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
        #endregion

        #region Testing
        [HttpGet, BasicAuthentication, Route("api/test/objects")]
        public IHttpActionResult GetShortRailObjectTest([FromUri] ObjectRequest objectRequest)
        {
            return Ok(DatabaseManager.GetShortRailObjects(objectRequest, objectRequest.Source.Split(','), true));
        }

        [Route("api/test/objects/{id}")]
        [HttpGet, BasicAuthentication]
        public IHttpActionResult GetRailObjectWithSecretTest(string id)
        {
            return Ok(new RailObject[] { DatabaseManager.GetRailObject(id) });
        }

        [HttpGet, Route("api/test/objects/{id:int}"), BasicAuthentication]
        public IHttpActionResult GetRailObjectsWithIdTest(int id)
        {
            return Ok(new ShortRailObject[] { DatabaseManager.GetShortRailObject(id) });
        }
        #endregion
    }
}
