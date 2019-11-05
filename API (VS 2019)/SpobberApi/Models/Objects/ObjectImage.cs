using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SpobberApi.Models
{
    public class ObjectImage
    {
        public string Year { get; private set; }

        public string Image_name { get; private set; }
        public string File_type { get; private set; }

        public string Uri { get; set; }

        public ObjectImage(int year, string uri, string name, string type)
        {
            Year = year.ToString();
            Uri = uri;
            Image_name = name;
            File_type = type.Replace(" ", "");
        }
    }
}