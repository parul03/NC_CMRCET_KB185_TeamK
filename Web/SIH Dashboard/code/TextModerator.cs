using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Mime;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Threading.Tasks;

namespace SIH_Dashboard
{
    public static class TextModerator
    {
        public static HttpClient Http = new HttpClient();
        public static async Task<ModerationResult> GetModerationResult(string comment)
        {
            HttpRequestMessage req = new HttpRequestMessage(HttpMethod.Post, "https://centralindia.api.cognitive.microsoft.com/contentmoderator/moderate/v1.0/ProcessText/Screen?classify=True");
            req.Headers.Add("Ocp-Apim-Subscription-Key", "63273601d1934e0bb5250bf4646d1331");
            req.Content =new StringContent(comment);
            req.Content.Headers.ContentType = MediaTypeHeaderValue.Parse("text/plain");
            var res = await Http.SendAsync(req);
            return JsonSerializer.Deserialize<ModerationResult>(await res.Content.ReadAsStringAsync());
        }
    }
    // Root myDeserializedClass = JsonConvert.DeserializeObject<Root>(myJsonResponse); 
    public class Email
    {
        public string Detected { get; set; }
        public string SubType { get; set; }
        public string Text { get; set; }
        public int Index { get; set; }
    }

    public class IPA
    {
        public string SubType { get; set; }
        public string Text { get; set; }
        public int Index { get; set; }
    }

    public class Phone
    {
        public string CountryCode { get; set; }
        public string Text { get; set; }
        public int Index { get; set; }
    }

    public class Address
    {
        public string Text { get; set; }
        public int Index { get; set; }
    }

    public class PII
    {
        public List<Email> Email { get; set; }
        public List<IPA> IPA { get; set; }
        public List<Phone> Phone { get; set; }
        public List<Address> Address { get; set; }
        public List<object> SSN { get; set; }
    }

    public class Category1
    {
        public double Score { get; set; }
    }

    public class Category2
    {
        public double Score { get; set; }
    }

    public class Category3
    {
        public double Score { get; set; }
    }

    public class Classification
    {
        public bool ReviewRecommended { get; set; }
        public Category1 Category1 { get; set; }
        public Category2 Category2 { get; set; }
        public Category3 Category3 { get; set; }
    }

    public class Term
    {
        public int Index { get; set; }
        public int OriginalIndex { get; set; }
        public int ListId { get; set; }
        [JsonPropertyName("Term")]
        public string Termz { get; set; }
    }

    public class Status
    {
        public int Code { get; set; }
        public string Description { get; set; }
        public object Exception { get; set; }
    }

    public class ModerationResult
    {
        public string OriginalText { get; set; }
        public string NormalizedText { get; set; }
        public object Misrepresentation { get; set; }
        public PII PII { get; set; }
        public Classification Classification { get; set; }
        public string Language { get; set; }
        public List<Term> Terms { get; set; }
        public Status Status { get; set; }
        public string TrackingId { get; set; }
    }


}
