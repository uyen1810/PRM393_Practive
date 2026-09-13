import 'dart:async';

class Product {
  final int id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price)';
  }
}

class ProductRepository {
  final List<Product> _products = [
    Product(id: 1, name: 'Laptop', price: 1500),
    Product(id: 2, name: 'Mouse', price: 25),
    Product(id: 3, name: 'Keyboard', price: 50),
  ];

  final StreamController<Product> _controller =
  StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async {
    await Future.delayed(const Duration(seconds: 1));
    return _products;
  }

  Stream<Product> liveAdded() {
    return _controller.stream;
  }

  void addProduct(Product product) {
    _products.add(product);
    _controller.add(product);
  }

  void dispose() {
    _controller.close();
  }
}