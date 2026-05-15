import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

class DatabaseService {
  // 1. Get a reference to our collection
  final CollectionReference _transactionCollection = FirebaseFirestore.instance
      .collection('transactions');

  // 2. CREATE: Add a new transaction to Firestore
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _transactionCollection.add(transaction.toMap());
    } catch (e) {
      print("Error adding transaction: $e");
    }
  }

  // 3. READ: Get a live stream of transactions
  Stream<List<TransactionModel>> get transactions {
    return _transactionCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TransactionModel.fromFirestore(doc);
          }).toList();
        });
  }

  // 4. DELETE: Remove a transaction
  Future<void> deleteTransaction(String id) async {
    return await _transactionCollection.doc(id).delete();
  }
}
