import 'dart:convert';

import 'package:duary/data/gemini_res.dart';
import 'package:duary/model/event.dart';
import 'package:duary/repository/llm_repository.dart';
import 'package:duary/support/secret_key.dart';
import 'package:http/http.dart';

class GeminiRepository implements LLMRepository {

  final Client client;

  GeminiRepository(this.client);


  @override
  Future<String> getTalk(Event event) async {
    Uri uri = Uri(
      scheme: "https",
      host: "generativelanguage.googleapis.com",
      path: "/v1beta/models/gemini-2.5-flash-lite:generateContent",
    );
    Map<String, String> header = {
      "x-goog-api-key": SecretKey.geminiAPIKey,
      "Content-Type": "application/json"
    };


    Map<String, dynamic> body = {
      "system_instruction": {
        "parts": [
          {
            "text": "너는 이벤트 데이터를 json 형식으로 전달받을거야. \n"
                "이 데이터에는 제목(title), 내용(content) 정보가 있는데,\n"
                "이 데이터를 title 과 content 을 적절히 섞어서 요약하고, 이를 진행하고 있다는 말을 써줘.\n"
                "*****10글자를 넘어가지 않도록 해야해.*****"
                "연인에게 말하는 듯이 써줘."
                "대답하는 말, 연인을 부르는 말은 빼야해."
                "이 이벤트를 함께하자는 등의 권유하는 말도 빼줘."
                "제목을 보고 유추한 상황에 따라 어투를 조정해줘."
                "title 은 not null 이고, 내용 nullable 이라서 null 인 내용은 문장에서 제외하면 돼.\n"
          }
        ]
      },

      "generationConfig": {
        "thinkingConfig": {
          "thinkingBudget": 0
        },
      },

      "contents": [
        {
          "parts": [
            {
              "text": jsonEncode(event)
            }
          ]
        }
      ]
    };

    Response response = await client.post(
        uri, headers: header, body: jsonEncode(body));

    GeminiRes res = GeminiRes.fromJson(jsonDecode(response.body));
    return res.candidates![0].content!.parts![0].text!;
  }
}