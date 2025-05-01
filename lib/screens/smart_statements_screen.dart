import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/app_scaffold.dart';
import '../models/statement_response.dart';
import '../config/api_config.dart';

class SmartStatementsScreen extends StatefulWidget {
  final String token;

  const SmartStatementsScreen({
    super.key,
    required this.token,
  });

  @override
  State<SmartStatementsScreen> createState() => _SmartStatementsScreenState();
}

class _SmartStatementsScreenState extends State<SmartStatementsScreen> {
  bool _isLoading = true;
  StatementResponse? _statementData;
  String? _error;
  double _averageSpending = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchStatements();
  }

  double _cleanNumberString(String amount) {
    try {
      // First, handle the specific format "R X XXX.XX"
      String cleaned = amount
          .replaceAll('R ', '') // Remove currency symbol
          .trim(); // Remove any leading/trailing whitespace

      // Split by spaces to handle thousand separators
      List<String> parts = cleaned.split(' ');
      cleaned = parts.join(''); // Join without spaces

      // Now handle any remaining formatting
      if (cleaned.contains(',')) {
        // If there's a comma, check if it's a decimal separator or thousand separator
        var commaParts = cleaned.split(',');
        if (commaParts.length == 2 && commaParts[1].length <= 2) {
          // Comma is a decimal separator (e.g., "1,50")
          cleaned = cleaned.replaceAll(',', '.');
        } else {
          // Comma is a thousand separator (e.g., "1,000")
          cleaned = cleaned.replaceAll(',', '');
        }
      }

      // Parse the cleaned string to double
      return double.parse(cleaned);
    } catch (e) {

      return 0.0; // Return 0 for invalid numbers
    }
  }

  double _calculateAverageSpending() {
    if (_statementData == null || _statementData!.statement.isEmpty) {
      return 0.0;
    }

    double totalDebit = 0.0;
    int debitCount = 0;

    for (var item in _statementData!.statement) {
      if (item.debit != 'R 0.00') {
        double amount = _cleanNumberString(item.debit);
        totalDebit += amount;
        debitCount++;
      }
    }

    return debitCount > 0 ? totalDebit / debitCount : 0.0;
  }

  Future<void> _fetchStatements() async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.statementV2()),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _statementData = StatementResponse.fromJson(jsonDecode(response.body));
          _averageSpending = _calculateAverageSpending();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load statements';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Statements',
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.green.shade50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.analytics, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            'Average Spending: R ${_averageSpending.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _statementData?.statement.length ?? 0,
                        itemBuilder: (context, index) {
                          final item = _statementData!.statement[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(item.description),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Date: ${item.date}'),
                                  Text('Reference: ${item.reference}'),
                                ],
                              ),
                              trailing: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (item.debit != 'R 0.00')
                                    Text(
                                      item.debit,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  if (item.credit != 'R 0.00')
                                    Text(
                                      item.credit,
                                      style: const TextStyle(color: Colors.green),
                                    ),
                                  Text(
                                    item.balance,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}