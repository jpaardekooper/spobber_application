using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SpobberApi.Models.Authentication
{
    public class UserLogin
    {
        public string Username { get; set; }
        public string Password { get; set; }
    }
}