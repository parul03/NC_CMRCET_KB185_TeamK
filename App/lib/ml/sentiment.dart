import 'dart:convert';
import 'dart:io';
import 'dart:core';

/*void main(List<String> args) async {
  var v = await Sentiment.getScore("cool drop", SentimentType.Toxic);
  print(v["Prediction"]);
  print(v["Score"]);
}*/

class Sentiment {
  static const Map<SentimentType, String> urlMap = {
    SentimentType.Toxic:
        "https://toxiccommentfunc.azurewebsites.net/api/ToxicServe?code=a3QYM13fo2dzVeWjY0rtvDSpQtE0jXCWO0zloa5D6gRivUS7VTlDDQ==",
    SentimentType.Insult:
        "https://toxiccommentfunc.azurewebsites.net/api/InsultServe?code=G1QY5wKPeLkcPrLSJR1jdEHr5gHobYwkMuHKR0YPBJFHI7w9N9SgKA==",
    SentimentType.Identity_Hate:
        "https://toxiccommentfunc.azurewebsites.net/api/HateIdentityServe?code=2K8VehKjaxH9HlZCjucUOZvl80rKhOw6EewHCzum1wCzygDXM3n8DA==",
    SentimentType.Obscene:
        "https://toxiccommentfunc.azurewebsites.net/api/ObsceneServe?code=W/OcZVo29ZlokVVYMqpwA2rEeRdfEDdmPtg8VN76zKy4eNDVW/785Q==",
    SentimentType.Severe_Toxic:
        "https://toxiccommentfunc.azurewebsites.net/api/SevereToxicServe?code=VHCigVIGZaoGwiWniRVm6lvS9XtB1cvqsTeEmyCYUWXNaK6QmLO0mA==",
    SentimentType.Overall_Toxicity:
        "https://toxiccommentfunc.azurewebsites.net/api/ToxicityServe?code=1Lh8wJ8CE9KFVlKCTRjuj5WnrvsSFcLx0T2UamtKEhLDjVWXOrEJag=="
  };

  static HttpClient client = new HttpClient();
  static const String ToxicURL = '';

  static Future<Map<String, dynamic>> getScore(
      String comment, SentimentType type) async {
    Uri url = Uri.parse(urlMap[type]);
    String json = '{"commentText":"' + comment + '"}';
    var req = await client.postUrl(url);
    req.write(json);
    var res = await req.close();
    var stream = res.transform(utf8.decoder);
    String result = "";
    await for (String s in stream) {
      result += s + " ";
    }
    var dec = jsonDecode(result);
    return dec;
  }
}

enum SentimentType {
  Toxic,
  Insult,
  Identity_Hate,
  Obscene,
  Severe_Toxic,
  Overall_Toxicity
}
