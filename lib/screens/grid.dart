import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_app/screens/studentinfo.dart';

import '../../db/fuctions/functions.dart';
import '../../db/model.dart';
import '../controllers/student_controller.dart';

class UserlistGrid extends StatelessWidget {
  UserlistGrid({Key? key}) : super(key: key);
  final StudentController studentController = Get.put(StudentController());
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
                Navigator.pushReplacementNamed(context, '/home');
              },
              icon: const Icon(
                Icons.list,
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
      body: FutureBuilder<List<Model>>(
        future: getAllStudents(searchName: searchName.text),
        builder: (BuildContext context, AsyncSnapshot<List<Model>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Handle the case when data is still loading
            return const CircularProgressIndicator();
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Student found'),
            );
          } else {
            // Update the observable list with the fetched data
            if (snapshot.connectionState == ConnectionState.done) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                studentController.students.value = snapshot.data!;
              });
            }

            return Obx(
              () {
                final studentList = studentController.students;
                if (studentList.isEmpty) {
                  return const Center(
                    child: Text('There is no student in this list'),
                  );
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // You can adjust the cross axis count as per your requirement
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemBuilder: (context, index) {
                    final data = studentList[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentInfo(
                              student: data,
                              onUpdate: (updatedModel) {
                                // Update the student in the list
                                updateStudentInList(updatedModel);
                              },
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: MemoryImage(
                                Uint8List.fromList(
                                  base64Decode(data.picture!),
                                ),
                              ),
                              maxRadius: 40,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              data.name ?? "No name",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 1.3,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              data.student_id.toString(),
                              textAlign: TextAlign.center,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                showAlert(context, data.id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: studentList.length,
                );
              },
            );
          }
        },
      ),
    );
  }

  void updateStudentInList(Model updatedModel) {
    // Find the index of the updated student
    int index = studentController.students
        .indexWhere((student) => student.id == updatedModel.id);

    if (index != -1) {
      // Replace the old student with the updated student
      studentController.students[index] = updatedModel;
    }
  }

  void showAlert(BuildContext context, var id) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
          content: const Text('Do you want to delete'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await deleteStudent(id);
                // Update UI after deletion
                studentController.students.value = await getAllStudents(); // Updated to use studentController
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );

  Widget searchbar() => Card(
        elevation: 10,
        borderOnForeground: true,
        child: TextField(
          controller: searchName,
          keyboardType: TextInputType.text, // Changed to text for general use
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
  }
}
