using System;
using System.Net;
using SpobberApi.Enums;

namespace SpobberApi.Models
{
    public class RailObject
    {
        public int Id { get; private set; }
        public string Secret_ID { get; private set; }
        public string Type { get; private set; }
        public string Description { get; private set; }

        public string Equipment_status { get; private set; }
        public string User_status_equipment { get; private set; }
        public string Parent_equip_kind { get; private set; }

        public string Datacollection { get; private set; }
        public string Placement { get; private set; }

        public double Latitude { get; private set; }
        public double Longitude { get; private set; }

        public string Pic_file_name { get; private set; }
        public string Run_nr { get; private set; }
        public string Track_version { get; private set; }
        public string Source { get; private set; }

        public int Year { get; private set; }
        private string[] Image { get; set; }

        public RailObject(
            int id,
            string secret_id,
            string type,

            string description,
            string equipment_status,
            string user_status_equipment,
            string parent_equip_kind,
            string datacollection,
            string placement,

            double latitude,
            double longitude,

            string pic_file_name,
            string run_nr,
            string track_version,
            string source,

            int year,
            string[] image)
        {
            Id = id;
            Type = type;
            Secret_ID = secret_id;

            Description = description ?? string.Empty;
            Equipment_status = equipment_status;
            User_status_equipment = user_status_equipment ?? string.Empty;
            Parent_equip_kind = parent_equip_kind ?? string.Empty;
            Datacollection = datacollection ?? string.Empty;
            Placement = placement ?? string.Empty;

            Latitude = latitude;
            Longitude = longitude;

            Pic_file_name = pic_file_name ?? string.Empty;
            Run_nr = run_nr ?? string.Empty;
            Track_version = track_version ?? string.Empty;
            Source = source ?? string.Empty;

            Year = year;
            Image = new string[image.Length];
            for (int i = 0; i < image.Length; i++)
            {
                if (image[i] != string.Empty && image[i] != null)
                    Image[i] = $"https://spobberstorageaccount.blob.core.windows.net/image/{image[i]}" + "?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D";
                else
                    Image[i] = "about:blank";
            }
        }

        public void AssignImages(string[] image)
        {
            Image = new string[image.Length];
            for (int i = 0; i < image.Length; i++)
            {
                if (image[i] != string.Empty && image[i] != null)
                    Image[i] = $"https://spobberstorageaccount.blob.core.windows.net/image/{image[i]}" + "?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D";
                else
                    Image[i] = "about:blank";
            }
        }
        public RailObject()
        {

        }
    }
}