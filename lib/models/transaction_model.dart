import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String? id;
  final String title;
  final double amount;
  final String category; // Storing category name instead of Icon
  final bool isExpense;
  final DateTime timestamp;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    this.isExpense = true,
    required this.timestamp,
  });

  // Convert Firebase Data to Dart Object
  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      title: data['title'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      category: data['category'] ?? 'Other',
      isExpense: data['isExpense'] ?? true,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // Convert Dart Object to Firebase Data
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'isExpense': isExpense,
      'timestamp': timestamp,
    };
  }
}