class Symptom {
  final int id;
  final String name;
  final String note;
  final int severity;
  final DateTime date;
  final int hours;
  final int minutes;

  Symptom({
    required this.id,
    required this.name,
    required this.note,
    required this.severity,
    required this.date,
    required this.hours,
    required this.minutes,
  });

  factory Symptom.fromJson(Map<String, dynamic> json) {
    return Symptom(
      id: json['id'],
      name: json['name'],
      note: json['note'],
      severity: json['severity'],
      date: DateTime.parse(json['date']),
      hours: json['hours'],
      minutes: json['minutes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'note': note,
      'severity': severity,
      'date': date.toIso8601String(),
      'hours': hours,
      'minutes': minutes,
    };
  }
}