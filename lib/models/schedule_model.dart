class ScheduleModel {
  final int id;
  final String movieTitle;
  final String cinema;
  final String showTime;
  final String date;
  final String price;

  ScheduleModel({
    required this.id,
    required this.movieTitle,
    required this.cinema,
    required this.showTime,
    required this.date,
    required this.price,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      movieTitle: json['name'] ?? json['movieTitle'] ?? 'Cinema Showtime',
      cinema: json['cinema'] ?? 'XXI Premiere Studio',
      showTime: json['airtime'] ?? json['showTime'] ?? '19:30 WIB',
      date: json['airdate'] ?? json['date'] ?? 'Hari Ini',
      price: json['price'] ?? 'Rp 45.000',
    );
  }
}

