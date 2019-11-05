namespace SpobberApi.Models
{
    public class ShortRailObject
    {
        public int ID { get; set; }
        public string Secret_Id { get; set; }
        public string Type { get; set; }

        public string Placement { get; set; }

        public double Latitude { get; set; }
        public double Longitude { get; set; }

        public string Source { get; set; }

        public string Object_uri { get; set; }

        public ShortRailObject(int id, string secret_id, string type, string placement, double lat, double longi, string source)
        {
            ID = id;
            Type = type;

            Secret_Id = secret_id;

            Placement = placement;

            Latitude = lat;
            Longitude = longi;

            Source = source;
            Object_uri = "https://spobber.azurewebsites.net/api/objects/" + Secret_Id;
        }

        public ShortRailObject() { }
    }
}