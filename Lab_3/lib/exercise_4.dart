import 'dart:async';

void runExercise4() {
  final numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

  numbers
      .map((number) => number * number)
      .where((number) => number.isEven)
      .listen((number) {
    print(number);
  });
}