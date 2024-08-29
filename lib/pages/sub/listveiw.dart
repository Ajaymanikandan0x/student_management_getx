import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:student_app/pages/studentinfo.dart';

import '../../db/fuctions/functions.dart';
import '../../db/model.dart';

class Userlist extends StatelessWidget {
  final String? searchQuery;
  const Userlist({Key? key, this.searchQuery}) : super(key: key);

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
          // Data is ready
          print(snapshot.data);
          return ValueListenableBuilder<List<Model>>(
            valueListenable: studentNotifier,
            builder:
                (BuildContext context, List<Model> studentList, Widget? child) {
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
                            id: data.id,
                            selectimg: data.picture!,
                            name: data.name!,
                            age: data.age!,
                            student_id: data.student_id!,
                            batch: data.batch!,
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
                itemCount: studentList.length ?? 10,
              );
            },
          );
        }
      },
    );
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
                studentNotifier.value = await getAllStudents();
                studentNotifier.notifyListeners();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
}
