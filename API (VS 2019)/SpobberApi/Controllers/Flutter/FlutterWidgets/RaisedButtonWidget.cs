using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Drawing;

namespace SpobberApi.Controllers.Flutter.FlutterWidgets
{
    public class RaisedButtonWidget : Widget
    {
        public string Color { get; set; } = "#0000FF";
        public string DisabledColor { get; set; } = "#6699FF";

        public TextWidget ButtonText { get; set; } = new TextWidget("default");

        public string TextColor { get; set; } = "#FFFFFF";
        public string DisabledTextColor { get; set; } = "#3A3A3A";

        public double Elevation { get; set; }
        public double DisabledElevation { get; set; }

        public string Padding { get; set; } = "8,8,8,8";

        public string SplashColor { get; set; } = "#3A3ACA";
        public string ClickEvent { get; set; } = "default";

        public override string ToString()
        {
            return $"{{" +
                $"\"type\": \"RaisedButton\"," +
                $"\"color\": \"{Color}\"," +
                $"\"padding\": \"{Padding}\"," +
                $"\"textColor\": \"{TextColor}\"," +
                $"\"elevation\": {Elevation}," +
                $"\"splashColor\": \"{SplashColor}\"," +
                $"\"click_event\": \"{ClickEvent}\"," +
                $"\"child\": {ButtonText.ToString()}" +
                $"}}";
        }
    }
}