using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SpobberApi.Controllers.Flutter.FlutterWidgets
{
    public class ListViewContainer : Container
    {
        public Axises ScrollDirection { get; set; } = Axises.VERTICAL;

        public bool Reverse { get; set; } = false;
        public bool ShrinkWarp { get; set; } = false;

        public double CacheExent { get; set; } = 0.0;
        public string Padding { get; set; } = "0,0,0,0";

        public double ItemExtent { get; set; }
        public double PageSize { get; set; }

        public string LoadMoreUrl { get; set; }
        public bool IsDemo { get; set; } = false;

        public override string ToString()
        {
            string returnString = $"{{" +
                 $"\"type\": \"ListView\"," +
                 $"\"reverse\": {Reverse.ToString().ToLower()}," +
                 $"\"shrinkWarp\": {ShrinkWarp.ToString().ToLower()}," +
                 $"\"cacheExent\": \"{CacheExent.ToString("0.00")}\"," +
                 $"\"padding\": \"{Padding}\"," +
                 $"\"itemExtent\": \"{ItemExtent.ToString("0.00")}\"," +
                 $"\"pageSize\": \"{PageSize.ToString("0.00")}\"," +
                 $"\"loadMoreUrl\": \"{LoadMoreUrl}\"," +
                 $"\"isDemo\": {IsDemo.ToString().ToLower()}," +
                 $"\"children\": [";
            for (int i = 0; i < Children.Count; i++)
            {
                if (i == Children.Count - 1)
                    returnString += Children[i].ToString();
                else
                    returnString += Children[i].ToString() + ",";
            }
            returnString += "]}";
            return returnString;
        }
    }
}