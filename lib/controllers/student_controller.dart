import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../db/model.dart';

class StudentController extends GetxController {
  RxString profImgPath = ''.obs;
  RxString name = ''.obs;
  RxString batch = ''.obs;
  RxInt age = 0.obs;
  RxInt studentId = 0.obs;
  var students = <Model>[].obs;
  void updateProfImgPath(String value) {
    profImgPath.value = value;
  }

  void updateName(String value) {
    name.value = value;
  }

  void updateBatch(String value) {
    batch.value = value;
  }

  void updateAge(int value) {
    age.value = value;
  }

  void updateStudentId(int value) {
    studentId.value = value;
  }

  void saveStudent() {
    Get.snackbar(
      'Success',
      'Student add success fully',
      messageText:
          const Text('Student ', style: TextStyle(color: Colors.black)),
      titleText: const Text(
        'Success',
        style: TextStyle(
            color: Colors.green, fontWeight: FontWeight.bold, fontSize: 17),
      ),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      borderRadius: 8,
    );
  }
}
