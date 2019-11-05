using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SpobberApi.Models
{
    public class MeasureCollection
    {
        public string ID { get { return id; } set { id = value; } }
        private string id;

        public string RailCode { get { return railcode; } set { railcode = value; } }
        private string railcode;

        public char RailSide
        {
            get
            {
                return railside;
            }
            set
            {
                if (!value.Equals('R') || !value.Equals('L'))
                    railside = 'R';
                else
                    railside = value;
            }
        }
        private char railside = 'R';

        public double Average { get { return average; } set { average = value; } }
        private double average;

        public double Minimum { get { return minimum; } set { minimum = value; } }
        private double minimum;
        public double Maximum { get { return maximum; } set { maximum = value; } }
        private double maximum;

        public MapMeasurePoint[] Content { get { return content; } set { content = value; } }
        private MapMeasurePoint[] content = new MapMeasurePoint[] { };
    }
}