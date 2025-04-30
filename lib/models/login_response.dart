class Transaction {
  final String date;
  final String description;
  final String debit;
  final String credit;
  final String balance;

  Transaction({
    required this.date,
    required this.description,
    required this.debit,
    required this.credit,
    required this.balance,

  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      debit: json['debit'] ?? '',
      credit: json['credit'] ?? '',
      balance: json['balance'] ?? '',
    );
  }
}

class LoginResponse {
  final bool success;
  final String message;
  final String accountNumber;
  final String token;
  final List<Transaction> transactions;

  LoginResponse({
    required this.success,
    required this.message,
    required this.token,
    required this.accountNumber,
    required this.transactions,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token : json['token'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}