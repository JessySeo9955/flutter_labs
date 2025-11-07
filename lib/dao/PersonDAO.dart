import 'package:floor/floor.dart';

import '../entity/Person.dart';

@dao
abstract class PersonDAO {

  @Query('SELECT * FROM Person')
  Future<List<Person>> getAllPersons();

  @insert
  Future<void> insertPerson(Person person);

  @delete
  Future<void> deletePerson(Person person);

  @update
  Future<void> updatePerson(Person person);

}