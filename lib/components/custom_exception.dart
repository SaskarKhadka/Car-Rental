class CustomException implements Exception {
  late String message;

  CustomException(this.message);

  @override
  String toString() {
    return message;
  }
}
