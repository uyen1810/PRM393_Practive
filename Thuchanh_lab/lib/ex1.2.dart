abstract class Employee {
  String name;
  Employee(this.name);

  void work();
}
mixin CheckInAbility on Employee {
  void checkIn() {
    print("$name đã điểm danh.");
  }
}
// TODO 2: Lớp Developer kế thừa Employee ('extends') và nhúng thêm tính năng CheckInAbility ('with').
class Developer extends Employee with CheckInAbility {
  Developer(String name) : super(name);
  @override
  void work() => print("$name đang viết code.");
}
void main() {
  List<Developer> teamA = [Developer("An"), Developer("Bình")];
  List<Developer> teamB = [Developer("Cường")];
  // TODO 3: Dùng Spread Operator (...) để gộp các phần tử của teamA và teamB vào allStaff.
  List<Developer> allStaff = [...teamA, ...teamB];
  // TODO 4: Dùng vòng lặp for-in duyệt qua từng nhân sự trong danh sách allStaff.
  for (var dev in allStaff) {
    dev.checkIn();
  }
}
