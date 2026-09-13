class Settings {
  static final Settings _instance = Settings._internal();

  Settings._internal();

  factory Settings() {
    return _instance;
  }
}

void runExercise5() {
  final a = Settings();
  final b = Settings();

  print(identical(a, b));
}