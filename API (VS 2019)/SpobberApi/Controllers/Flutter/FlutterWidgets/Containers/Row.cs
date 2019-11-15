namespace SpobberApi.Controllers.Flutter.FlutterWidgets
{
    public class Row : Container
    {
        public CrossAxisAlignments CrossAxisAlignment { get; set; } = CrossAxisAlignments.CENTER;

        public MainAxisAlignments MainAxisAlignment { get; set; } = MainAxisAlignments.START;
        public MainAxisSizes MainAxisSize { get; set; } = MainAxisSizes.MAX;

        public TextBaselines TextBaseline { get; set; } = TextBaselines.IDEOGRAPHIC;
        public TextDirections TextDirection { get; set; } = TextDirections.LTR;

        public VerticalDirections VerticalDirection { get; set; } = VerticalDirections.DOWN;

        public override string ToString()
        {
            string returnString = $"{{" +
                $"\"type\": \"Row\"," +
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