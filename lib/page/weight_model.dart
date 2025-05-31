import 'package:intl/intl.dart';

class WeightRecord {
  final DateTime date;
  final double weight;
  final String? note;

  WeightRecord({
    required this.date,
    required this.weight,
    this.note,
  });

  String get formattedDate => DateFormat('d.M').format(date);

  // Untuk Firestore/Firebase
  factory WeightRecord.fromMap(Map<String, dynamic> map) {
    return WeightRecord(
      date: map['date']?.toDate() ?? DateTime.now(),
      weight: (map['weight'] as num).toDouble(),
      note: map['note'],
    );
  }

  // Untuk SQLite/API
  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'weight': weight,
      'note': note,
    };
  }
}