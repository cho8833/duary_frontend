class InputCoupleCodeReq {
  String coupleCode;

  InputCoupleCodeReq(this.coupleCode);

  Map<String, dynamic> toJson() =>
    {
      "coupleCode": coupleCode
    };
}