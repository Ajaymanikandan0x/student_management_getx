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
  final Model student;
  final Function(Model) onUpdate;

  final StudentController studentController = Get.find<StudentController>();
  StudentInfo({
    super.key,
    required this.student,
    required this.onUpdate,
  }) {
    studentController.initStudent(student);
  }

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
            Obx(
              () => TextField(
                controller:
                    TextEditingController(text: studentController.name.value),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                onChanged: (value) => studentController.updateName(value),
              ),
            ),
            sizeBox,
            Obx(
              () => TextField(
                controller: TextEditingController(
                    text: studentController.studentId.value.toString()),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                onChanged: (value) =>
                    studentController.updateStudentId(int.parse(value)),
              ),
            ),

            sizeBox,
            Obx(
              () => TextField(
                controller: TextEditingController(
                    text: studentController.age.value.toString()),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                onChanged: (value) =>
                    studentController.updateAge(int.parse(value)),
              ),
            ),

            sizeBox,
            Obx(
              () => TextField(
                controller:
                    TextEditingController(text: studentController.batch.value),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                onChanged: (value) => studentController.updateBatch(value),
              ),
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
                    final updatedModel = Model(
                      id: studentController.id.value,
                      name: studentController.name.value,
                      age: studentController.age.value,
                      student_id: studentController.studentId.value,
                      batch: studentController.batch.value,
                      picture:
                          base64Image ?? studentController.profImgPath.value,
                    );

                    await updateStudent(updatedModel);
                    onUpdate(updatedModel);
                    studentController.saveStudent(); // to show success message
                    Navigator.pop(context);
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
