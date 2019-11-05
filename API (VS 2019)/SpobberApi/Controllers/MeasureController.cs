using System;
using System.Linq;
using System.Collections.Generic;
using System.Web.Http;
using SpobberApi.Models;
using SpobberApi.Statics;

namespace SpobberApi.Controllers
{
    public class MeasureController : ApiController
    {
        [HttpGet]
        public IHttpActionResult Get([FromUri] MapRequest mapRequest)
        {
            #region Testing
            List<MapMeasurePoint> test1Data = new List<MapMeasurePoint>()
                {
                    new MapMeasurePoint(Guid.NewGuid(), 1490, 51.027767, 5.839607),
                    new MapMeasurePoint(Guid.NewGuid(), 1560, 51.026408, 5.838706),
                    new MapMeasurePoint(Guid.NewGuid(), 1790, 51.028354, 5.841622),
                    new MapMeasurePoint(Guid.NewGuid(), 1329, 51.028473, 5.837939),
                    new MapMeasurePoint(Guid.NewGuid(), 1921, 51.027745, 5.839890),
                    new MapMeasurePoint(Guid.NewGuid(), 1512, 51.027767, 5.839607)
                };
            MeasureCollection test1 = new MeasureCollection() 
            { 
                ID = "LDA-231", 
                Average = test1Data.Average(x => x.Value), 
                Minimum = test1Data.Min(x => x.Value), 
                Maximum = test1Data.Max(x => x.Value), 
                RailSide = 'L', 
                RailCode = "yeet", 
                Content = test1Data.ToArray() 
            };
            #endregion
            return Ok(new MeasureCollection[] { DatabaseManager.GetMeasureCollection(mapRequest), test1});
        }

        [HttpGet]
        [Route("api/measure/{id:guid}")]
        public IHttpActionResult Get(Guid id)
        {
            return Ok(DatabaseManager.GetMeasurePoint(id));
        }

        /*[HttpPost]
        [Route("api/objects")]
        public void Post([FromBody] MeasurePoint railObject)
        {
            DatabaseManager.UpdateRailObject(railObject);
        }*/
    }
}
