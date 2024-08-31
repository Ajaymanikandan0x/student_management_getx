import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/student_controller.dart';
import '../../db/fuctions/functions.dart';
import '../../db/model.dart';
import '../studentinfo.dart';

class Userlist extends StatelessWidget {
  final String? searchQuery;
  Userlist({Key? key, this.searchQuery}) : super(key: key);
  final StudentController studentController = Get.put(StudentController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Model>>(
      future: getAllStudents(searchName: searchQuery),
      builder: (BuildContext context, AsyncSnapshot<List<Model>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Handle the case when data is still loading
          return const CircularProgressIndicator();
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No Student found'),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              studentController.students.value = snapshot.data!;
            });
          }

          return Obx(
            () {
              final studentList = studentController.students;

              if (searchQuery != null && studentList.isEmpty) {
                return const Center(
                  child: Text('There is no student in this list'),
                );
              }
              return ListView.separated(
                itemBuilder: (context, index) {
                  final data = studentList[index];

                  return ListTile(
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
                    leading: CircleAvatar(
                      backgroundImage: MemoryImage(
                        Uint8List.fromList(
                          base64Decode(data.picture!),
                        ),
                      ),
                      maxRadius: 40,
                    ),
                    title: Text(data.name ?? "No name",
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.3,
                        )),
                    subtitle: Text(data.student_id.toString()),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showAlert(context, data.id);
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  height: 2,
                ),
                itemCount: studentList.length,
              );
            },
          );
        }
      },
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
                final navigator = Navigator.of(context);
                await deleteStudent(id);
                // Update UI after deletion
                students.value = await getAllStudents();
                navigator.pop();
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
}
