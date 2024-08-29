import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../db/fuctions/functions.dart';
import '../db/model.dart';

class StudentInfo extends StatefulWidget {
  late final String selectimg;
  final String name;
  final int student_id;
  final int age;
  final String batch;
  final int? id;

  // Separate controllers for each text field
  final TextEditingController nameController = TextEditingController();

  final TextEditingController ageController = TextEditingController();

  final TextEditingController idController = TextEditingController();

  final TextEditingController batchController = TextEditingController();
  StudentInfo({
    required this.selectimg,
    required this.name,
    required this.student_id,
    required this.age,
    required this.batch,
    required this.id,
  }) {
    // Initialize controllers with provided values
    nameController.text = name;
    ageController.text = age.toString();
    idController.text = student_id.toString();
    batchController.text = batch;
  }

  @override
  State<StudentInfo> createState() => _StudentInfoState();

  static Widget sizeBox = const SizedBox(height: 10);
}

class _StudentInfoState extends State<StudentInfo> {
  File? newimg;
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
              child: CircleAvatar(
                radius: 80,
                foregroundColor: Colors.blueGrey,
                backgroundImage: widget.selectimg != null
                    ? MemoryImage(
                        Uint8List.fromList(
                          base64Decode(widget.selectimg),
                        ),
                      )
                    : newimg != null
                        ? MemoryImage(
                            base64Decode(base64Image!),
                          )
                        : null,
                child: widget.selectimg == null && newimg == null
                    ? Icon(Icons.person)
                    : null,
              ),
            ),

            const SizedBox(height: 20),
            TextField(
              controller: widget.nameController,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            StudentInfo.sizeBox,
            TextField(
              controller: widget.idController,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            StudentInfo.sizeBox,
            TextField(
              controller: widget.ageController,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            StudentInfo.sizeBox,
            TextField(
              controller: widget.batchController,
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
                    String updatedImage = base64Image ?? widget.selectimg;
                    final model = Model(
                      id: widget.id,
                      name: widget.nameController.text,
                      age: int.parse(widget.ageController.text),
                      student_id: int.parse(widget.idController.text),
                      batch: widget.batchController.text,
                      picture: updatedImage,
                    );
                    await updateStudent(model);
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
      setState(() {
        newimg = File(imageselect.path);
        this.base64Image = base64Image;
      });
    } catch (e) {
      print("Error picking image: $e");
    }
  }
}
