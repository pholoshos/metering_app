class StatementResponse {
  final List<StatementItem> statement;

  StatementResponse({
    required this.statement,
  });

  factory StatementResponse.fromJson(Map<String, dynamic> json) {
    return StatementResponse(
      statement: (json['statement'] as List)
          .map((item) => StatementItem.fromJson(item))
          .toList(),
    );
  }
}

class StatementItem {
  final String description;
  final String date;
  final String reference;
  final String debit;
  final String credit;
  final String balance;

  StatementItem({
    required this.description,
    required this.date,
    required this.reference,
    required this.debit,
    required this.credit,
    required this.balance,
  });

  factory StatementItem.fromJson(Map<String, dynamic> json) {
    return StatementItem(
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      reference: json['reference'] ?? '',
      debit: json['debit'] ?? 'R 0.00',
      credit: json['credit'] ?? 'R 0.00',
      balance: json['balance'] ?? 'R 0.00',
    );
  }
}