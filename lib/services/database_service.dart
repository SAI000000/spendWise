import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/transaction_model.dart';

class DatabaseService {
  final CollectionReference _transactionCollection = FirebaseFirestore.instance
      .collection('transactions');

  // Helper utility to safely grab the current user's ID
  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  // 1. CREATE: Tag transaction with the user's secret ID
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      final data = transaction.toMap();
      data['userId'] = _currentUserId; // Force association with this account
      await _transactionCollection.add(data);
    } catch (e) {
      print("Error adding transaction: $e");
    }
  }

  // 2. READ: Only look for documents matching our current user ID
  Stream<List<TransactionModel>> get transactions {
    return _transactionCollection
        .where('userId', isEqualTo: _currentUserId) // DATA ISOLATION FILTER
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TransactionModel.fromFirestore(doc);
          }).toList();
        });
  }

  // 3. DELETE
  Future<void> deleteTransaction(String id) async {
    await _transactionCollection.doc(id).delete();
  }
}
