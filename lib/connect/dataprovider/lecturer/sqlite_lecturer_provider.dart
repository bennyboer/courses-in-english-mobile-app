import 'dart:async';

import 'package:courses_in_english/connect/dataprovider/databasehelper/databasehelper.dart';
import 'package:courses_in_english/connect/dataprovider/lecturer/lecturer_provider.dart';
import 'package:courses_in_english/model/lecturer/lecturer.dart';

/// Mock lecturer provider providing lecturers from the mock courses.
class SqliteLecturerProvider implements LecturerProvider {
  @override
  Future<Lecturer> getLecturerById(int lecturerId) async {
    DatabaseHelper dbh = new DatabaseHelper();
    Map<String, dynamic> lecturerData =
        await dbh.selectOneWhere("Lecturer", "id", lecturerId.toString());
    Lecturer tempLecturer = new Lecturer(
        lecturerData["id"], lecturerData["name"], lecturerData["email"]);
    return new Future(() => tempLecturer);
  }

  @override
  Future<List<Lecturer>> getLecturers() async {
    DatabaseHelper dbh = new DatabaseHelper();
    List<Map<String, dynamic>> lecturerData = await dbh.selectTable("Lecturer");
    List<Lecturer> lecturers = [];

    void addLecturer(Map<String, dynamic> data) {
      Lecturer tempLecturer =
          new Lecturer(data["id"], data["name"], data["email"]);

      lecturers.add(tempLecturer);
    }

    lecturerData.forEach(addLecturer);

    return new Future(() => lecturers);
  }

  Future<int> putLecturer(List<Lecturer> lecturers) async {
    DatabaseHelper dbh = new DatabaseHelper();
    List<Map<String, dynamic>> lecturerList = [];

    void iterate(Lecturer data) {
      lecturerList.add(data.toMap(-1));
    }

    lecturers.forEach(iterate);

    return dbh.insertTable("Lecturer", lecturerList);
  }
}
