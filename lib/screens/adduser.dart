import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_app/db/model.dart';

import '../controllers/student_controller.dart';
import '../db/fuctions/functions.dart';

class Adduser extends StatelessWidget {
  Adduser({super.key});

  final _name = TextEditingController();

  final _age = TextEditingController();

  final _studentId = TextEditingController();

  final _batch = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? base64Image;

  bool isImageSelected = false;

  final StudentController studentController = Get.find<StudentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student'),
        centerTitle: true,
        backgroundColor: Colors.teal[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
            child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _getImage(context);
                },
                child: Obx(
                  () => CircleAvatar(
                    maxRadius: 80,
                    foregroundColor: Colors.blueGrey,
                    backgroundImage: studentController
                            .profImgPath.value.isNotEmpty
                        ? MemoryImage(
                            base64Decode(studentController.profImgPath.value))
                        : null,
                    child: studentController.profImgPath.value.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: Icon(Icons.person),
                          )
                        : null, // Placeholder icon if no image is available
                  ),
                ),
              ),
              boxHeight,
              TextFormField(
                style: const TextStyle(
                  letterSpacing: 2,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
                decoration: InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: _name,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                    return "Please enter a correct name";
                  } else {
                    return null;
                  }
                },
              ),
              boxHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 120,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          letterSpacing: 2,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),
                        decoration: InputDecoration(
                          hintText: 'age',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        controller: _age,
                        validator: (value) {
                          if (value == null) {
                            return "Please enter your age.";
                          }

                          if (!RegExp(r'^\d{1,2}$').hasMatch(value)) {
                            return "Please enter a valid age (up to 2 digits).";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: 240,
                      child: TextFormField(
                        style: const TextStyle(
                          letterSpacing: 2,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Batch',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        controller: _batch,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !RegExp(r'^[a-zA-Z 0-9]+$').hasMatch(value)) {
                            return "Please enter valid batch number";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              boxHeight,
              TextFormField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    letterSpacing: 2,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18.0,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Id_number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: _studentId,
                  validator: (value) {
                    if (value == null) {
                      return "Please enter an ID";
                    }
                    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                      return "Please enter a valid 6-digit ID";
                    }

                    return null; // Valid ID
                  }),
              boxHeight,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _addStudent(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 50),
                      backgroundColor: Colors.teal[800],
                    ),
                    icon: const Icon(Icons.save, color: Colors.black),
                    label: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(150, 50),
                      backgroundColor: Colors.teal[800],
                    ),
                    icon: const Icon(Icons.exit_to_app_rounded,
                        color: Colors.black),
                    label: const Text(
                      'Back',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget boxHeight = const SizedBox(
    height: 15,
  );

  Future<void> _getImage(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final XFile? imageSelect =
          await picker.pickImage(source: ImageSource.gallery);

      if (imageSelect == null) {
        // No image selected

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image'),
          ),
        );
        return;
      }
      Uint8List imageBytes =
          await imageSelect.readAsBytes(); // Use Uint8List for image bytes
      String base64Image = base64Encode(imageBytes);

      studentController.updateProfImgPath(base64Image);
      this.base64Image = base64Image;
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _addStudent(BuildContext context) async {
    final names = _name.text.trim();
    final age = int.parse(_age.text);
    final id = int.parse(_studentId.text);
    final batch = _batch.text;
    if (base64Image == null || base64Image!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.grey,
          content: Text('Error picking image. Please try again',
              style: TextStyle(color: Colors.red)),
        ),
      );
      return;
    } else {
      final model = Model(
        name: names,
        age: age,
        student_id: id,
        batch: batch,
        picture: base64Image,
      );
      await addStudent(model);
      studentController.students.add(model);
      
      final navigator = Navigator.of(context);
      navigator.pushReplacementNamed('/home');
    }
  }
}
