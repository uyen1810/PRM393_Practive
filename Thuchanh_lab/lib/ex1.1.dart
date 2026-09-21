// TODO 1: Định nghĩa class Vehicle (lớp cha) với các thuộc tính brand và year.
class Vehicle {

  String brand;
  int year;

  Vehicle(this.brand, this.year);


  void startEngine() {
    print("Khởi động phương tiện...");
  }
}

// TODO 2: Định nghĩa class Car kế thừa (extends) từ class Vehicle.
class Car extends Vehicle {
  bool isElectric;

  // TODO 3: Constructor mặc định cho Car.

  Car(String brand, int year, this.isElectric) : super(brand, year);
  Car.tesla(int year)
      : isElectric = true,
        super("Tesla", year);

  // TODO 4: Ghi đè (@override) phương thức startEngine() của lớp cha.
  @override
  void startEngine() {
    if (isElectric) {
      print("$brand ($year) khởi động: Em ru, không có tiếng động cơ!");
    } else {
      print("$brand ($year) khởi động: Vroom vroom!");
    }
  }
}

void main() {
  // TODO 5: Khởi tạo một đối tượng Car bình thường bằng Constructor mặc định.
  Car car1 = Car("Toyota", 2020, false);
  car1.startEngine();

  // TODO 6: Khởi tạo một đối tượng Car bằng Named Constructor (Car.tesla)..
  Car car2 = Car.tesla(2024);
  car2.startEngine();
}