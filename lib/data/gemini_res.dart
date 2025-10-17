class GeminiRes {
  List<Candidates>? candidates;
  UsageMetadata? usageMetadata;
  String? modelVersion;
  String? responseId;

  GeminiRes(
      {this.candidates,
        this.usageMetadata,
        this.modelVersion,
        this.responseId});

  GeminiRes.fromJson(Map<String, dynamic> json) {
    if (json['candidates'] != null) {
      candidates = <Candidates>[];
      json['candidates'].forEach((v) {
        candidates!.add(new Candidates.fromJson(v));
      });
    }
    usageMetadata = json['usageMetadata'] != null
        ? new UsageMetadata.fromJson(json['usageMetadata'])
        : null;
    modelVersion = json['modelVersion'];
    responseId = json['responseId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.candidates != null) {
      data['candidates'] = this.candidates!.map((v) => v.toJson()).toList();
    }
    if (this.usageMetadata != null) {
      data['usageMetadata'] = this.usageMetadata!.toJson();
    }
    data['modelVersion'] = this.modelVersion;
    data['responseId'] = this.responseId;
    return data;
  }
}

class Candidates {
  Content? content;
  String? finishReason;
  int? index;

  Candidates({this.content, this.finishReason, this.index});

  Candidates.fromJson(Map<String, dynamic> json) {
    content =
    json['content'] != null ? new Content.fromJson(json['content']) : null;
    finishReason = json['finishReason'];
    index = json['index'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.content != null) {
      data['content'] = this.content!.toJson();
    }
    data['finishReason'] = this.finishReason;
    data['index'] = this.index;
    return data;
  }
}

class Content {
  List<Parts>? parts;
  String? role;

  Content({this.parts, this.role});

  Content.fromJson(Map<String, dynamic> json) {
    if (json['parts'] != null) {
      parts = <Parts>[];
      json['parts'].forEach((v) {
        parts!.add(new Parts.fromJson(v));
      });
    }
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.parts != null) {
      data['parts'] = this.parts!.map((v) => v.toJson()).toList();
    }
    data['role'] = this.role;
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

class UsageMetadata {
  int? promptTokenCount;
  int? candidatesTokenCount;
  int? totalTokenCount;
  List<PromptTokensDetails>? promptTokensDetails;

  UsageMetadata(
      {this.promptTokenCount,
        this.candidatesTokenCount,
        this.totalTokenCount,
        this.promptTokensDetails});

  UsageMetadata.fromJson(Map<String, dynamic> json) {
    promptTokenCount = json['promptTokenCount'];
    candidatesTokenCount = json['candidatesTokenCount'];
    totalTokenCount = json['totalTokenCount'];
    if (json['promptTokensDetails'] != null) {
      promptTokensDetails = <PromptTokensDetails>[];
      json['promptTokensDetails'].forEach((v) {
        promptTokensDetails!.add(new PromptTokensDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['promptTokenCount'] = this.promptTokenCount;
    data['candidatesTokenCount'] = this.candidatesTokenCount;
    data['totalTokenCount'] = this.totalTokenCount;
    if (this.promptTokensDetails != null) {
      data['promptTokensDetails'] =
          this.promptTokensDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PromptTokensDetails {
  String? modality;
  int? tokenCount;

  PromptTokensDetails({this.modality, this.tokenCount});

  PromptTokensDetails.fromJson(Map<String, dynamic> json) {
    modality = json['modality'];
    tokenCount = json['tokenCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['modality'] = this.modality;
    data['tokenCount'] = this.tokenCount;
    return data;
  }
}
