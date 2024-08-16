enum DrawingMode {
  pencil('pencil'), pen('pen'), eraser('eraser'), square("square"), circle('circle'), polygon('polygon');

  final String name;

  const DrawingMode(this.name);

  @override
  String toString() {
    return name;
  }


  factory DrawingMode.fromJson(String json) {
    return DrawingMode.values.firstWhere((element) => element.toString() == json);
  }

}
