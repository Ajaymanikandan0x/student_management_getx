import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:student_app/db/model.dart';

var students = <Model>[].obs;
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
    where: searchName != null && searchName.isNotEmpty ? 'name LIKE ?' : null,
    whereArgs: searchName != null && searchName.isNotEmpty ? ['%$searchName%'] : null,
  );
  final List<Model> studentList = maps.map((e) => Model.fromMap(e)).toList();
  return studentList;
}

Future<void> addStudent(Model student) async {
  try {
    final db = await database();
    await db.insert('student_db', student.toMap());
    students.add(student);
  } catch (e) {
    print("Error adding student: ${e.toString()}");
  }
}

Future<void> deleteStudent(int studentId) async {
  try {
    final db = await database();
    await db.rawDelete('DELETE FROM student_db WHERE id = ?', [studentId]);
    students.removeWhere((student) => student.id == studentId);
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
    final index = students.indexWhere((element) => element.id == student.id);
    if (index != -1) {
      students[index] = student;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error updating student: ${e.toString()}");
    }
  }
}
