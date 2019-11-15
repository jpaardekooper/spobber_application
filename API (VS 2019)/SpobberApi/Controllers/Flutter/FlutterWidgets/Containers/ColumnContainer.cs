using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SpobberApi.Controllers.Flutter.FlutterWidgets
{
    public class ColumnContainer : Container
    {
        public CrossAxisAlignments CrossAxisAlignment { get; set; } = CrossAxisAlignments.STRETCH;

        public MainAxisAlignments MainAxisAlignment { get; set; } = MainAxisAlignments.START;
        public MainAxisSizes MainAxisSize { get; set; } = MainAxisSizes.MAX;

        public TextBaselines TextBaseline { get; set; } = TextBaselines.IDEOGRAPHIC;
        public TextDirections TextDirection { get; set; } = TextDirections.LTR;
        public VerticalDirections VerticalDirection { get; set; } = VerticalDirections.DOWN;

        public override string ToString()
        {
            string returnString = $"{{" +
                $"\"type\": \"Column\"," +
                $"\"crossAxisAlignment\": \"{CrossAxisAlignment.ToString().ToLower()}\"," +
                $"\"mainAxisAlignment\": \"{MainAxisAlignment.ToString().ToLower()}\"," +
                $"\"mainAxisSize\": \"{MainAxisSize.ToString().ToLower()}\"," +
                $"\"textBaseline\": \"{TextBaseline.ToString().ToLower()}\"," +
                $"\"textDirection\": \"{TextDirection.ToString().ToLower()}\"," +
                $"\"verticalDirection\": \"{VerticalDirection.ToString().ToLower()}\"," +
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