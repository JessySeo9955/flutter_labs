import 'package:floor/floor.dart';

@entity
class Person {
  static int ID = 1;

  @primaryKey
  final int id;

  int quantity;
  String name;


  Person(this.id, this.quantity, this.name) {
    if (this.id >= ID) {
      ID = this.id + 1;

    }
  }

}