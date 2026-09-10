
Future<void> loadData() async {
  print("Loading...");

  await Future.delayed(Duration(seconds: 2));

  print("Data loaded!");
}

void main() async {
  await loadData();

  String? name;
  print(name ?? "No name");

  String city = "Hanoi";
  print(city!);

  String? country = "Vietnam";
  print(country?.length);

  Stream<int> numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

  numbers.listen((number) {
    print("Number: $number");
  });
}