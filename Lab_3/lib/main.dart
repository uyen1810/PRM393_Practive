import 'exercise_1.dart';
import 'exercise_2.dart';
import 'exercise_3.dart';
import 'exercise_4.dart';
import 'exercise_5.dart';

Future<void> main() async {
  print('===== EXERCISE 1 =====');

  final productRepository = ProductRepository();

  productRepository.liveAdded().listen((product) {
    print('New product: $product');
  });

  final products = await productRepository.getAll();

  print('All products:');

  for (final product in products) {
    print(product);
  }

  productRepository.addProduct(
    Product(
      id: 4,
      name: 'Monitor',
      price: 300,
    ),
  );

  productRepository.addProduct(
    Product(
      id: 5,
      name: 'Headphone',
      price: 80,
    ),
  );

  await Future.delayed(const Duration(milliseconds: 500));

  productRepository.dispose();

  print('\n===== EXERCISE 2 =====');
  final userRepository = UserRepository();
  final users = await userRepository.getUsers();
  print('Users:');
  for (final user in users) {
    print(user);
  }

  print('\n===== EXERCISE 3 =====');
  runExercise3();
  await Future.delayed(const Duration(milliseconds: 500));

  print('\n===== EXERCISE 4 =====');
  runExercise4();
  await Future.delayed(const Duration(milliseconds: 500));

  print('\n===== EXERCISE 5 =====');
  runExercise5();
}