using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SpobberApi.Controllers.Flutter.FlutterWidgets
{
    public class IconWidget : Widget
    {
        public string Icon { get; set; } = "content_paste";
        public string Color { get; set; } = "#A9A9A9";

        public string SemanticLabel { get; set; } = string.Empty;
        public double Size { get; set; } = 50.0;

        public TextDirections TextDirection { get; set; } = TextDirections.LTR;

        public override string ToString()
        {
            return $"{{" +
                $"\"type\": \"Icon\"," +
                $"\"icon\": \"{Icon.ToLower()}\"," +
                $"\"color\": \"{Color.ToLower()}\"," +
                $"\"semanticLabel\": \"{SemanticLabel}\"," +
                $"\"size\": \"{Size.ToString("0.0")}\"," +
                $"\"textDirection\": \"{TextDirection.ToString().ToLower()}\"" +
                $"}}";
        }
    }
}