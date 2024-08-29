class Model {
  int? id;
  final String? name;
  final int? age;
  final int? student_id;
  final String? batch;
  final String? picture;

  Model(
      {this.id,
      required this.name,
      required this.age,
      required this.student_id,
      required this.batch,
      this.picture});

  factory Model.fromMap(Map<String, dynamic> Map) => Model(
      id: Map['id'] ?? 0,
      name: Map['name'],
      age: Map['age'],
      student_id: Map['student_id'],
      batch: Map['batch'],
      picture: Map['picture']);

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'age': age,
        'student_id': student_id,
        'batch': batch,
        'picture': picture,
      };
}
