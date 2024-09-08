import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/db/fuctions/functions.dart';
import 'package:student_app/screens/sub/listveiw.dart';

import '../controllers/student_controller.dart';
import '../db/model.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final StudentController studentController = Get.find<StudentController>();

  TextEditingController searchName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        title: const Text(
          'Home',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/grid');
              },
              icon: const Icon(
                Icons.grid_on,
                color: Colors.white,
              ))
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: searchbar(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/adduser');
        },
        backgroundColor: Colors.teal[800],
        child: const Icon(Icons.add),
      ),
      body: Userlist(searchQuery: searchName.text),
    );
  }

  Widget searchbar() => Card(
        elevation: 10,
        borderOnForeground: true,
        child: TextField(
          controller: searchName,
          keyboardType: TextInputType.text,
          style: const TextStyle(
            letterSpacing: 2,
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14.0,
          ),
          onChanged: (value) {
            searchStud(value);
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(5),
            hintText: 'Username',
            prefix: const Icon(Icons.search, color: Colors.black, size: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );

  void searchStud(String searchName) async {
    final List<Model> dbStudents = await getAllStudents(searchName: searchName);
    studentController.students.value = dbStudents;

    // Optionally, you can show a message if no students are found
    if (dbStudents.isEmpty) {
      Get.snackbar('No Results', 'No students match your search criteria.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
