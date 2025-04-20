import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  final String uid;
  final String? fid;
  final String name;
  final String startDate;
  final String? expDate;
  final String? isExpired;
  final String? type;
  final String? imageUrl;

  Food({
    required this.uid,
    this.fid,
    required this.name,
    required this.startDate,
    this.expDate,
    this.isExpired,
    this.type,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    bool expResult = expDate == null;
    return {
      "uid": uid,
      "name": name,
      "startDate": Timestamp.fromDate(DateTime.parse(startDate)),
      "expDate":
          expResult ? null : Timestamp.fromDate(DateTime.parse(expDate!)),
      "type": type,
      "imageUrl": imageUrl,
    };
  }

  @override
  String toString() =>
      "Ingredient(name: $name, startDate: $startDate, expDate: $expDate, isExpired: $isExpired, type: $type, imageUrl: $imageUrl)";
}
