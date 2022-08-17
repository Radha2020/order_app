class History {
  final String id;
  final String date;
  final String time;
  final String gtotal;
  final String status;
  History({this.id, this.date, this.time, this.gtotal, this.status});

  factory History.fromJson(Map<String, dynamic> json) {
    return new History(
        id: json['id'] as String,
        date: json['date'] as String,
        time: json['time'] as String,
        gtotal: json['gtotal'] as String,
        status: json['status'] as String);
  }
}
