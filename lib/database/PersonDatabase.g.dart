// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PersonDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $PersonDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $PersonDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $PersonDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<PersonDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorPersonDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $PersonDatabaseBuilderContract databaseBuilder(String name) =>
      _$PersonDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $PersonDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$PersonDatabaseBuilder(null);
}

class _$PersonDatabaseBuilder implements $PersonDatabaseBuilderContract {
  _$PersonDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $PersonDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $PersonDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<PersonDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$PersonDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$PersonDatabase extends PersonDatabase {
  _$PersonDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PersonDAO? _personDAOInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Person` (`id` INTEGER NOT NULL, `quantity` INTEGER NOT NULL, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PersonDAO get personDAO {
    return _personDAOInstance ??= _$PersonDAO(database, changeListener);
  }
}

class _$PersonDAO extends PersonDAO {
  _$PersonDAO(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _personInsertionAdapter = InsertionAdapter(
            database,
            'Person',
            (Person item) => <String, Object?>{
                  'id': item.id,
                  'quantity': item.quantity,
                  'name': item.name
                }),
        _personUpdateAdapter = UpdateAdapter(
            database,
            'Person',
            ['id'],
            (Person item) => <String, Object?>{
                  'id': item.id,
                  'quantity': item.quantity,
                  'name': item.name
                }),
        _personDeletionAdapter = DeletionAdapter(
            database,
            'Person',
            ['id'],
            (Person item) => <String, Object?>{
                  'id': item.id,
                  'quantity': item.quantity,
                  'name': item.name
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Person> _personInsertionAdapter;

  final UpdateAdapter<Person> _personUpdateAdapter;

  final DeletionAdapter<Person> _personDeletionAdapter;

  @override
  Future<List<Person>> getAllPersons() async {
    return _queryAdapter.queryList('SELECT * FROM Person',
        mapper: (Map<String, Object?> row) => Person(
            row['id'] as int, row['quantity'] as int, row['name'] as String));
  }

  @override
  Future<void> insertPerson(Person person) async {
    await _personInsertionAdapter.insert(person, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePerson(Person person) async {
    await _personUpdateAdapter.update(person, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePerson(Person person) async {
    await _personDeletionAdapter.delete(person);
  }
}
