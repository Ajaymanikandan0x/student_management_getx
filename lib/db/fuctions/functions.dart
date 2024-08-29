import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_app/db/model.dart';

ValueNotifier<List<Model>> studentNotifier = ValueNotifier([]);
Future<Database> database() async {
  final db = await openDatabase(
    'student_db',
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE student_db (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, student_id INTEGER, batch TEXT, picture TEXT)');
    },
    // onUpgrade: (db, oldVersion, newVersion) async {
    //   if (oldVersion == 1 && newVersion == 2) {
    //     await db.execute('ALTER TABLE student_db ADD COLUMN data TEXT');
    //   }
    // },
  );

  return db;
}

Future<List<Model>> getAllStudents({String? searchName}) async {
  final db = await database();
  final List<Map<String, dynamic>> maps = await db.query(
    'student_db',
    columns: ['id', 'name', 'age', 'student_id', 'batch', 'picture'],
    where: searchName != null ? 'name LIKE ?' : null,
    whereArgs: searchName != null ? ['%$searchName%'] : null,
  );
  final List<Model> templist = [];
  maps.forEach((element) {
    templist.add(Model.fromMap(element));
  });
  studentNotifier.value = templist;
  studentNotifier.notifyListeners();

  return templist;
}

Future<void> addStudent(Model student) async {
  try {
    final db = await database();
    final result = await db.insert('student_db', student.toMap());
    studentNotifier.value.add(student); // Add student to existing list
    studentNotifier.notifyListeners();
  } catch (e) {
    print("Error adding student: ${e.toString()}");
  }
}

Future<void> deleteStudent(int studentId) async {
  try {
    final db = await database();
    await db.rawDelete('DELETE FROM student_db WHERE id = ?', [studentId]);
    studentNotifier.value.removeWhere(
        (student) => student.id == studentId); // Remove from existing list
    studentNotifier.notifyListeners();
  } catch (e) {
    print("Error deleting student: ${e.toString()}");
  }
}

Future<void> updateStudent(Model student) async {
  try {
    final db = await database();
    await db.update('student_db', student.toMap(),
        where: 'id = ?', whereArgs: [student.id]);
    print("Updating student with id: ${student.id}");
    studentNotifier.value.removeWhere((element) => element.id == student.id);
    studentNotifier.value.add(student); // Add the updated student to the list
    studentNotifier.notifyListeners();
  } catch (e) {
    print("Error updating student: ${e.toString()}");
  }
}
