class StudyLog{
  final bool status;
  final int dataLength;
  final List<dynamic> studyLog;

  StudyLog({this.status, this.studyLog, this.dataLength});

  factory StudyLog.fromJson(Map<String, dynamic> json){

    return new StudyLog(
      status : json['status'],
      studyLog: json['studyLog'],
      dataLength: json['dataLength']
    );
  }

}


class Aggregate{
  final bool status;
  final int totalSecond;
  final List<dynamic> studyLog;

  Aggregate({this.status, this.studyLog, this.totalSecond});

  factory Aggregate.fromJson(Map<String, dynamic> json){
    return new Aggregate(
        status : json['status'],
        totalSecond: json['total_secondes'],
        studyLog: json['detail']
    );
  }



}