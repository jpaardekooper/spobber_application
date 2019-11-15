using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SpobberApi.Controllers.Flutter.FlutterWidgets
{
    public class ListTileWidget : Widget
    {
        public Widget Leading { get; set; } = new IconWidget();
        public Widget Title { get; set; } = new TextWidget(string.Empty);
        public Widget Subtitle { get; set; } = new TextWidget(string.Empty);

        public bool IsThreeLine { get; set; } = false;
        public bool Dense { get; set; } = false;

        //public EdgeInsetsGeometry ContentPadding { get; set; }

        public bool Enabled { get; set; } = true;
        public bool Selected { get; set; } = false;

        public ListTileWidget(string icon, string title, string subtitle)
        {
            Leading = new IconWidget();
            ((IconWidget)Leading).Icon = icon;

            Title = new TextWidget(title);
            Subtitle = new TextWidget(subtitle);
        }

        public override string ToString()
        {
            return $"{{" +
                $"\"type\": \"ListTile\"," +
                $"\"leading\": {Leading.ToString()}," +
                $"\"title\": {Title.ToString()}," +
                $"\"subtitle\": {Subtitle.ToString()}," +
                $"\"isThreeLine\": \"{IsThreeLine.ToString().ToLower()}\"," +
                $"\"dense\": \"{Dense.ToString().ToLower()}\"," +
                $"\"selected\": {Selected.ToString().ToLower()}" +
                $"}}";
        }
    }
}