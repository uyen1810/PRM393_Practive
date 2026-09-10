void main() {
  List<int> numbers = [10, 20, 30];
  print("List: $numbers");

  print("First number: ${numbers[0]}");

  int sum = numbers[0] + numbers[1];
  int difference = numbers[2] - numbers[0];

  print("10 + 20 = $sum");
  print("30 - 10 = $difference");

  print("10 == 20: ${numbers[0] == numbers[1]}");

  bool check = numbers[0] < 20 && numbers[1] < 30;
  print("Both conditions are true: $check");

  String result = numbers[0] > 5 ? "Yes" : "No";
  print("Is 10 greater than 5? $result");

  Set<int> numberSet = {10, 20, 20, 30};

  print("Set: $numberSet");

  numberSet.add(40);
  print("After add: $numberSet");

  numberSet.remove(20);
  print("After remove: $numberSet");

  Map<String, int> students = {
    "Uyen": 8,
    "Lan": 9,
    "Nam": 7
  };
  print("Students: $students");

  print("Uyen's score: ${students["Uyen"]}");
}