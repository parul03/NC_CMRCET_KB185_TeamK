using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Json;
using System.Runtime.InteropServices;
using System.Text.Json;
using System.Threading.Tasks;
using static SIH_Dashboard.SentimentalAnalysis.AzureSentiment;
using Microsoft.JSInterop;

namespace SIH_Dashboard
{
    public class SentimentalAnalysis
    {
        public static Dictionary<SentimentType, string> UrlMap { get; } = new Dictionary<SentimentType, string>
        {
            {
                SentimentType.Toxic,
                "https://toxiccommentfunc.azurewebsites.net/api/ToxicServe?code=a3QYM13fo2dzVeWjY0rtvDSpQtE0jXCWO0zloa5D6gRivUS7VTlDDQ=="
            },
            {
                SentimentType.Insult,
                "https://toxiccommentfunc.azurewebsites.net/api/InsultServe?code=G1QY5wKPeLkcPrLSJR1jdEHr5gHobYwkMuHKR0YPBJFHI7w9N9SgKA=="
            }
            ,{
                SentimentType.Identity_Hate,
                "https://toxiccommentfunc.azurewebsites.net/api/HateIdentityServe?code=2K8VehKjaxH9HlZCjucUOZvl80rKhOw6EewHCzum1wCzygDXM3n8DA=="
            },
            {
                SentimentType.Obscene,
                "https://toxiccommentfunc.azurewebsites.net/api/ObsceneServe?code=W/OcZVo29ZlokVVYMqpwA2rEeRdfEDdmPtg8VN76zKy4eNDVW/785Q=="
            }
            ,{
                SentimentType.Severe_Toxic,
                "https://toxiccommentfunc.azurewebsites.net/api/SevereToxicServe?code=VHCigVIGZaoGwiWniRVm6lvS9XtB1cvqsTeEmyCYUWXNaK6QmLO0mA=="
            }
            ,{
                SentimentType.Overall_Toxicity,
                "https://toxiccommentfunc.azurewebsites.net/api/ToxicityServe?code=1Lh8wJ8CE9KFVlKCTRjuj5WnrvsSFcLx0T2UamtKEhLDjVWXOrEJag=="
            }
        };
        readonly static string azureURL = "https://toxiccommentfunc.azurewebsites.net/api/SentimentAnalysis?code=1x7UkwYmWhAuGcHZFFWUg48wDqd0Rnn3cLUCyytmPqOL/eZS2OVcBw==";

        public static async Task<DocumentSentiment> GetAzureSentiment(string comment)
        {
            SentimentInput input = new SentimentInput() { commentText = comment };
            var res = await Client.PostAsync(azureURL, JsonContent.Create(input));

            var response = await res.Content.ReadAsStringAsync();
            var model = JsonSerializer.Deserialize<DocumentSentiment>(response);
            return model;
        }
        public async static Task<ModelOutput> GetSentiment(string comment, SentimentType type)
        {
            SentimentInput input = new SentimentInput() { commentText = comment };
            var res = await Client.PostAsync(UrlMap[type], JsonContent.Create(input));

            var response = await res.Content.ReadAsStringAsync();
            var model = JsonSerializer.Deserialize<ModelOutput>(response);
            return model;
        }
        public static HttpClient Client { get; set; } = new HttpClient();
        public enum SentimentType
        {
            Toxic,
            Insult,
            Identity_Hate,
            Obscene,
            Severe_Toxic,
            Overall_Toxicity
        }
        public class SentimentInput
        {
            public string commentText { get; set; }
        }
        public class ModelOutput
        {
            // ColumnName attribute is used to change the column name from
            // its default value, which is the name of the field.
            public Single Prediction { get; set; }
            public float[] Score { get; set; }
        }

        public class AzureSentiment
        {
            public class DocumentSentiment
            {
                //
                // Summary:
                //     Gets the predicted sentiment for the analyzed document.
                public TextSentiment Sentiment { get; set; }
                //
                // Summary:
                //     Gets the sentiment confidence score (Softmax score) between 0 and 1, for each
                //     sentiment. Higher values signify higher confidence.
                public SentimentConfidenceScores ConfidenceScores { get; set; }
                //
                // Summary:
                //     Gets the predicted sentiment for each sentence in the corresponding document.
                public List<SentenceSentiment> Sentences { get; set; }
            }
            public class SentimentConfidenceScores
            {
                //
                // Summary:
                //     Gets a score between 0 and 1, indicating the confidence that the sentiment of
                //     the analyzed text is positive.
                public double Positive { get; set; }
                //
                // Summary:
                //     Gets a score between 0 and 1, indicating the confidence that the sentiment of
                //     the analyzed text is neutral.
                public double Neutral { get; set; }
                //
                // Summary:
                //     Gets a score between 0 and 1, indicating the confidence that the sentiment of
                //     the analyzed text is negative.
                public double Negative { get; set; }
            }
            public class SentenceSentiment
            {
                //
                // Summary:
                //     Gets the predicted sentiment for the analyzed sentence.
                public TextSentiment Sentiment { get; set; }
                //
                // Summary:
                //     Gets the sentence text.
                public string Text { get; set; }
                //
                // Summary:
                //     Gets the sentiment confidence score (Softmax score) between 0 and 1, for each
                //     sentiment. Higher values signify higher confidence.
                public SentimentConfidenceScores ConfidenceScores { get; set; }
            }
            public enum TextSentiment
            {
                //
                // Summary:
                //     Indicates that the sentiment is positive.
                Positive = 0,
                //
                // Summary:
                //     Indicates that the sentiment is neutral.
                Neutral = 1,
                //
                // Summary:
                //     Indicates that the sentiment is negative.
                Negative = 2,
                //
                // Summary:
                //     Indicates that the document contains mixed sentiments.
                Mixed = 3
            }
        }

        public async static Task<string> GetFeedbackSentiment(IJSRuntime Runtime ,Feedbacks feed)
        {
            if (feed.SentimentScore == null)
            {
                if (feed.Notes == "")
                    return "0";
                var model = await GetAzureSentiment(feed.Notes);
                string positivesentiment = ((int)(model.ConfidenceScores.Positive * 100)).ToString();
                DatabaseHelper.WriteData<string>(Runtime, "Feedbacks/" + feed.Id + "/sentimentscore", positivesentiment);
                return positivesentiment;
            }
            else
                return feed.SentimentScore;
        }
    }
}
