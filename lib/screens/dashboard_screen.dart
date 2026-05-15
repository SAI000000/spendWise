import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';
import '../services/database_service.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  // Instantiate our new service
  final DatabaseService _db = DatabaseService();

  void _showAddTransactionModal() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "New Expense",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // LOGIC: Create model and send to Firebase via our Service
                final tx = TransactionModel(
                  title: titleController.text,
                  amount: double.parse(amountController.text),
                  category: "Food",
                  timestamp: DateTime.now(),
                );
                await _db.addTransaction(tx);
                Navigator.pop(context);
              },
              child: const Text("Save to Cloud"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SpendWise")),
      body: StreamBuilder<List<TransactionModel>>(
        stream: _db.transactions, // Listening to our live stream
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          final txs = snapshot.data!;
          return ListView.builder(
            itemCount: txs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(txs[index].title),
                subtitle: Text(txs[index].category),
                trailing: Text("-\$${txs[index].amount}"),
                // BONUS LOGIC: Swipe to delete!
                onLongPress: () => _db.deleteTransaction(txs[index].id!),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTransactionModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
