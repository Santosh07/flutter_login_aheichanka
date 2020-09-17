class MyFormValidator {
  static String validateIfEmpty(String text, String returnTextInfo) {
    return text.isEmpty ? '$returnTextInfo cannot be empty' : null;
  }
}
