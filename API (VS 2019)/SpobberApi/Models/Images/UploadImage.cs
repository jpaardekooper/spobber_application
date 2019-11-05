using System;
using System.Linq;

namespace SpobberApi.Models
{
    public class UploadImage
    {
        public string filename { get; set; }
        public string image
        {
            get
            {
                return decodedImage;
            }
            set
            {
                if (value.Contains(','))
                    decodedImage = value.Split(',')[1];
                else
                    decodedImage = value;
            }
        }
        private string decodedImage;
    }
}