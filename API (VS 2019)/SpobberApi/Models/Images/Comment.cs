using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SpobberApi.Models
{
    public class Comment
    {
        public string ID { get; set; }
        public string Type { get; set; }

        public string ParentId { get; set; }
        public string CommentDetail { get; set; }

        public string UserId { get; set; }

        public DateTime Date { get; set; }
        public double Rating { get; set; }
    }
}