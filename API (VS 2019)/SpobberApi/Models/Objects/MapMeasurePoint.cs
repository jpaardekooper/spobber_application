using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SpobberApi.Models
{
    public class MapMeasurePoint
    {
        public Guid ID { get { return id; } set { id = value; } }
        private Guid id;
        public double Value { get { return value; } set { this.value = value; } }
        private double value;

        public double Latitude { get { return latitude; } set { latitude = value; } }
        private double latitude;
        public double Longitude { get { return longitude; } set { longitude = value; } }
        private double longitude;

        public Uri PreviewImage { get { return previewimage; } set { previewimage = value; } }
        private Uri previewimage;
        public Uri MeasurePoint { get { return measurepoint; } set { measurepoint = value; } }
        private Uri measurepoint;

        public MapMeasurePoint(Guid id, double value, double latitude, double longitude)
        {
            ID = id;
            Value = value;
            Latitude = latitude;
            Longitude = longitude;
            PreviewImage = new Uri("https://google.com");
            MeasurePoint = new Uri("https://spobberapi20190919041857.azurewebsites.net/api/measure/" + ID);
        }
    }
}