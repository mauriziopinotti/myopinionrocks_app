extension StringUtils on String {
  bool containsIgnoreCase(dynamic other) => other != null
      ? toLowerCase().contains(other.toString().toLowerCase())
      : false;

  String get capitalize =>
      length > 0 ? "${this[0].toUpperCase()}${substring(1)}" : "";

  String get uncapitalize =>
      length > 0 ? "${this[0].toLowerCase()}${substring(1)}" : "";

  String get camelCase => toLowerCase()
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.capitalize)
      .join(" ");

  // FIXME
  String get unescape => replaceAll("\\", "");
}
