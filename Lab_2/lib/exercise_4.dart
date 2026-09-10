
class Car {
  String name;
  Car({required this.name});

  void drive() {
    print("$name is driving");
  }
}

class ElectricCar extends Car {
  ElectricCar({required String name}) : super(name: name);

  @override
  void drive() {
    print("$name is driving with electricity");
  }
}

void main() {

  Car car = Car(name: "Toyota");
  ElectricCar electricCar = ElectricCar(name: "Tesla");

  car.drive();
  electricCar.drive();
}