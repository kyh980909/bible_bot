class TodayCafeteriaMenu {
  bool status;
  Map<String, dynamic> lunch;
  Map<String, dynamic> dinner;
  Map<String, dynamic> daily;
  Map<String, dynamic> fix;
  String lunchPrice;
  String dinnerPrice;

  TodayCafeteriaMenu(
      {this.status,
      this.lunch,
      this.dinner,
      this.daily,
      this.fix,
      this.lunchPrice,
      this.dinnerPrice});

  factory TodayCafeteriaMenu.fromJson(Map<String, dynamic> json) {
    return new TodayCafeteriaMenu(
        status: json['status'] == null ? true : json['status'],
        lunch: json['lunch'],
        dinner: json['dinner'],
        daily: json['daily'],
        fix: json['fix'],
        lunchPrice: json['lunchPrice'],
        dinnerPrice: json['dinnerPrice']);
  }
}
