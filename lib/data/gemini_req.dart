import 'package:json_annotation/json_annotation.dart';

class GeminiReq {
  List<Contents>? contents;
  GenerationConfig? generationConfig;

  GeminiReq({this.contents, this.generationConfig});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contents != null) {
      data['contents'] = this.contents!.map((v) => v.toJson()).toList();
    }
    if (this.generationConfig != null) {
      data['generationConfig'] = this.generationConfig!.toJson();
    }
    return data;
  }
}

class Contents {
  List<Parts>? parts;

  Contents({this.parts});

  Contents.fromJson(Map<String, dynamic> json) {
    if (json['parts'] != null) {
      parts = <Parts>[];
      json['parts'].forEach((v) {
        parts!.add(new Parts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.parts != null) {
      data['parts'] = this.parts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parts {
  String? text;

  Parts({this.text});

  Parts.fromJson(Map<String, dynamic> json) {
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    return data;
  }
}

class GenerationConfig {
  List<String>? stopSequences;
  int? temperature;
  double? topP;
  int? topK;
  int? maxOutputTokens;

  GenerationConfig(
      {this.stopSequences, this.temperature, this.topP, this.topK});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stopSequences'] = this.stopSequences;
    data['temperature'] = this.temperature;
    data['maxOutputTokens'] = this.maxOutputTokens;
    data['topP'] = this.topP;
    data['topK'] = this.topK;
    return data;
  }
}
