import 'package:floor/floor.dart';



// ✅ All imports come first
import 'dart:async';
import 'package:sqflite/sqflite.dart'as sqflite;
import 'package:path/path.dart';

// ✅ Then your part directives
import '../dao/PersonDAO.dart';
import '../entity/Person.dart';


part 'PersonDatabase.g.dart';


@Database(version: 1, entities: [Person])
abstract class PersonDatabase extends FloorDatabase {

  PersonDAO get personDAO;
}