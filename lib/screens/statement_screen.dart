import 'package:flutter/material.dart';
import '../models/login_response.dart';

class StatementScreen extends StatelessWidget {
  final List<Transaction> transactions;
  final String accountNumber;

  const StatementScreen({
    super.key,
    required this.transactions,
    required this.accountNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statement - $accountNumber'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(transaction.description),
              subtitle: Text(transaction.date),
              trailing: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (transaction.debit != 'R 0.00')
                    Text(
                      'Debit: ${transaction.debit}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  if (transaction.credit != 'R 0.00')
                    Text(
                      'Credit: ${transaction.credit}',
                      style: const TextStyle(color: Colors.green),
                    ),
                  Text(
                    'Balance: ${transaction.balance}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}