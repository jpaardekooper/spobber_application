using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SpobberApi.Models
{
    public class MapRequest
    {
        public double NLat { get; set; }
        public double BLat { get; set; }
        public double NLon { get; set; }
        public double BLon { get; set; }
    }
}