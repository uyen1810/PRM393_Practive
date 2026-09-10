void main() {
  int score = 8;
  if (score >= 5) {
    print("Pass");
  } else {
    print("Fail");
  }

  int day = 2;
  switch (day) {
    case 1:
      print("Monday");
      break;
    case 2:
      print("Tuesday");
      break;
    default:
      print("Other day");
  }

  List<String> names = ["Uyen", "Lan", "Nam"];

  for (int i = 0; i < names.length; i++) {
    print(names[i]);
  }

  for (String name in names) {
    print(name);
  }

  names.forEach((name) => print(name));

  int add(int a, int b) {
    return a + b;
  }

  print(add(2, 3));

  int multiply(int a, int b) => a * b;

  print(multiply(2, 3));
}