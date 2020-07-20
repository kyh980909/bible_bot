import 'package:bible_bot/util/attendance_info_prettify.dart';
import 'package:test/test.dart';

void main() {
  test('regex test', () {
    List timetables = [
      "(월)13:30~14:45(목)13:30~14:45",
      "(월)13:30~14:45(화)13:30~14:45(수)13:30~14:45(목)13:30~14:45(금)13:30~14:45",
      "(월)13:30~14:45(월)14:55~16:10"
    ];
    for (var timetable in timetables) {
      print(AttendanceInfoPrettify().prettify(timetable));
    }
  });
}
