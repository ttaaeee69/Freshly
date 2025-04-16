import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  final String name;
  final String startDate;
  final String? expDate;
  final String? isExpired;
  final String? type;

  Food(
      {required this.name,
      required this.startDate,
      this.expDate,
      this.isExpired,
      this.type});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "startDate": Timestamp.fromDate(DateTime.parse(startDate)),
      "expDate": expDate != "null"
          ? Timestamp.fromDate(DateTime.parse(expDate!))
          : null,
      "type": type,
    };
  }

  @override
  String toString() => "Ingredient(name: $name, startDate: $startDate)";
}
