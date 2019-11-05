using System.Web.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Net.Http;
using System.Web.Http.Results;

using SpobberApi.Models;
using SpobberApi.Statics;

namespace SpobberApi.Controllers
{
    public class CommentController : ApiController
    {
        [HttpGet, Route("api/comments/{id:int}")]
        public Comment[] GetComments(int id)
        {
            return new Comment[] { };
        }

        [HttpPost, Route("api/comments/upload/{id:int}")]
        public async void PostComment(int id, [FromBody] Comment comment)
        {
            //DatabaseManager.PostComment(comment);
        }
    }
}
