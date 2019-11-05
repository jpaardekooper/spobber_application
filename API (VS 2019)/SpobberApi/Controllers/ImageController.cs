using System.Web.Http;
using SpobberApi.Models;
using SpobberApi.Statics;
using System;
using System.Net;
using System.Net.Http;
using System.IO;
using Microsoft.Azure.Storage;
using Microsoft.Azure.Storage.Blob;
using System.Threading.Tasks;
using System.Linq;

namespace SpobberApi.Controllers
{
    public class ImageController : ApiController
    {
        [HttpGet, Route("api/image/{id}")]
        public ObjectImage[] Get(string id)
        {
            ObjectImage[] tempArray = DatabaseManager.GetObjectImages(id);
            for (int i = 0; i < tempArray.Length; i++)
                tempArray[i].Uri = $"https://spobberstorageaccount.blob.core.windows.net/image/{tempArray[i].Uri.Replace(" ", "")}?sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-07-13T22:18:33Z&st=2019-10-24T14:18:33Z&spr=https&sig=W%2BMVqLEyoZmIRE3aj9147RJ%2FYrsbl0uEcjuPVNsNYU4%3D";
            return tempArray;
        }

        [HttpPost, Route("api/image/upload/{id}")]
        public async Task<HttpResponseMessage> Post(string id, [FromBody] UploadImage uploadImage)
        {
            try
            {
                CloudStorageAccount storageAccount = CloudStorageAccount.Parse("BlobEndpoint=https://spobberstorageaccount.blob.core.windows.net/;QueueEndpoint=https://spobberstorageaccount.queue.core.windows.net/;FileEndpoint=https://spobberstorageaccount.file.core.windows.net/;TableEndpoint=https://spobberstorageaccount.table.core.windows.net/;SharedAccessSignature=sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-12-08T00:07:56Z&st=2019-10-25T15:07:56Z&spr=https&sig=5uDhevLHFX9y2MFvUI%2FODHazK1jqXKMRkB%2B%2BvGP3B8Y%3D");
                CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();
                CloudBlobContainer container = blobClient.GetContainerReference("image");

                string fileName = DatabaseManager.BindPictureToObject(id, uploadImage.filename.Split('.').Last());
                if (fileName == "")
                    return new HttpResponseMessage(HttpStatusCode.Conflict);

                string test = fileName + "." + uploadImage.filename.Split('.').Last();
                CloudBlockBlob blockBlob = container.GetBlockBlobReference(fileName + "." + uploadImage.filename.Split('.').Last());
                MemoryStream base64Image;

                try
                {
                    base64Image = new MemoryStream(Convert.FromBase64String(uploadImage.image));
                    switch (Path.GetExtension(uploadImage.filename).ToUpper())
                    {
                        case ".JPEG":
                            blockBlob.Properties.ContentType = "image/jpg";
                            break;
                        case ".JPG":
                            blockBlob.Properties.ContentType = "image/jpg";
                            break;
                        case ".PNG":
                            blockBlob.Properties.ContentType = "image/png";
                            break;
                        case ".GIF":
                            blockBlob.Properties.ContentType = "image/gif";
                            break;
                    }
                    await blockBlob.UploadFromStreamAsync(base64Image);
                }
                catch (FormatException)
                {
                    return new HttpResponseMessage(HttpStatusCode.Conflict);
                }
                return new HttpResponseMessage(HttpStatusCode.OK);
            }
            catch (Exception e)
            {
                HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.Conflict);
                response.Content = new StringContent(e.ToString());
                return response;
            }
        }

        [HttpPost, Route("api/image/delete/{fileName}")]
        public async Task<HttpResponseMessage> Delete(string fileName)
        {
            try
            {
                CloudStorageAccount storageAccount = CloudStorageAccount.Parse("BlobEndpoint=https://spobberstorageaccount.blob.core.windows.net/;QueueEndpoint=https://spobberstorageaccount.queue.core.windows.net/;FileEndpoint=https://spobberstorageaccount.file.core.windows.net/;TableEndpoint=https://spobberstorageaccount.table.core.windows.net/;SharedAccessSignature=sv=2019-02-02&ss=bfqt&srt=sco&sp=rwdlacup&se=2021-12-08T00:07:56Z&st=2019-10-25T15:07:56Z&spr=https&sig=5uDhevLHFX9y2MFvUI%2FODHazK1jqXKMRkB%2B%2BvGP3B8Y%3D");
                CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();
                CloudBlobContainer container = blobClient.GetContainerReference("image");

                CloudBlockBlob blob = container.GetBlockBlobReference(fileName);
                await blob.DeleteIfExistsAsync();

                DatabaseManager.UnbindPictureToObject(fileName.Split('.')[0]);

                return new HttpResponseMessage(HttpStatusCode.OK);
            }
            catch (Exception e)
            {
                HttpResponseMessage response = new HttpResponseMessage(HttpStatusCode.Conflict);
                response.Content = new StringContent(e.ToString());
                return response;
            }
        }
    }
}
