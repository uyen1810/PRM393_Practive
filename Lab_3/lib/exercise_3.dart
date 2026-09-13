import 'dart:async';

void runExercise3() {
  print('Start');

  scheduleMicrotask(() {
    print('Microtask 1');
  });

  Future(() {
    print('Future event');
  });

  scheduleMicrotask(() {
    print('Microtask 2');
  });

  print('End');
}