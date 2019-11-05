using System;

namespace SpobberApi.Models
{
    public class MeasurePoint
    {
        public Guid ID { get { return id; } set { id = value; } }
        private Guid id;
        public double Value { get { return value; } set { this.value = value; } }
        private double value;
        
        public double Latitude { get { return latitude; } set { latitude = value; } }
        private double latitude;
        public double Longitude { get { return longitude; } set { longitude = value; } }
        private double longitude;

        public Uri[] Comments { get { return comments; } set { comments = value; } }
        private Uri[] comments = new Uri[] { };
        public Uri[] Images { get { return images; } set { images = value; } }
        private Uri[] images = new Uri[] { };

        public MeasurePoint(Guid id, double value, double latitude, double longitude)
        {
            ID = id;
            Value = value;
            Latitude = latitude;
            Longitude = longitude;
        }

        public MeasurePoint()
        {

        }
    }
}