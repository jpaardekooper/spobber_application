namespace SpobberApi.Models
{
    public class ObjectRequest
    {
        public float NLat { get; set; }
        public float NLon { get; set; }

        public float BLat { get; set; }
        public float BLon { get; set; }

        public string ObjectType { get; set; }
        public string Source { get; set; }
    }
}