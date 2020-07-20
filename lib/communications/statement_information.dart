class Statement{
  bool status;
  List<dynamic> entire;
  List<dynamic> expense;
  List<dynamic> profit;


  Statement({this.status,this.entire,this.expense,this.profit});

  factory Statement.fromJson(Map<String, dynamic> json){
    return Statement(
      status: json['status'],
      entire: json['entire'],
      expense: json['expense'],
      profit: json['profit'],
    );
  }
}