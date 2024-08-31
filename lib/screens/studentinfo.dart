import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/student_controller.dart';
import '../db/fuctions/functions.dart';
import '../db/model.dart';

class StudentInfo extends StatelessWidget {
  late final String selectImg;
  final String name;
  final int studentId;
  final int age;
  final String batch;
  final int? id;

  // Separate controllers for each text field
  final TextEditingController nameController = TextEditingController();

  final TextEditingController ageController = TextEditingController();

  final TextEditingController idController = TextEditingController();

  final TextEditingController batchController = TextEditingController();

  final StudentController studentController = Get.find<StudentController>();
  StudentInfo({
    super.key,
    required this.selectImg,
    required this.name,
    required this.studentId,
    required this.age,
    required this.batch,
    required this.id,
  });

  File? newImg;

  String? base64Image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[800],
        centerTitle: true,
        title: const Text('StudentInfo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 65),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Use CircleAvatar properly
            GestureDetector(
              onTap: () {
                _getImage();
              },
              child: Obx(
                () => CircleAvatar(
                  maxRadius: 80,
                  foregroundColor: Colors.blueGrey,
                  backgroundImage:
                      studentController.profImgPath.value.isNotEmpty
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

            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            sizeBox,
            TextField(
              controller: idController,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            sizeBox,
            TextField(
              controller: ageController,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            sizeBox,
            TextField(
              controller: batchController,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 50),
                    backgroundColor: Colors.teal[800],
                  ),
                  icon: const Icon(Icons.exit_to_app_rounded,
                      color: Colors.black),
                  label: const Text(
                    'Back',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    String updatedImage = base64Image ?? selectImg;
                    final model = Model(
                      id: id,
                      name: nameController.text,
                      age: int.parse(ageController.text),
                      student_id: int.parse(idController.text),
                      batch: batchController.text,
                      picture: updatedImage,
                    );
                    await updateStudent(model);
                    final navigator = Navigator.of(context);
                    navigator.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(100, 50),
                    backgroundColor: Colors.teal[800],
                  ),
                  icon: const Icon(Icons.update, color: Colors.black),
                  label: const Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImage() async {
    try {
      final picker = ImagePicker();
      final XFile? imageselect =
          await picker.pickImage(source: ImageSource.gallery);

      if (imageselect == null) {
        // No image selected
        return;
      }
      Uint8List imageBytes =
          await imageselect.readAsBytes(); // Use Uint8List for image bytes
      String base64Image = base64Encode(imageBytes);

      // Update the profImgPath in the controller
      studentController.updateProfImgPath(base64Image);
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  static Widget sizeBox = const SizedBox(height: 10);
}
