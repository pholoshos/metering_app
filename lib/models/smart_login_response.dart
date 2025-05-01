class SmartLoginResponse {
  final String token;
  final bool success;
  final String message;
  final SmartLoginData data;

  SmartLoginResponse({
    required this.token,
    required this.success,
    required this.message,
    required this.data,
  });

  factory SmartLoginResponse.fromJson(Map<String, dynamic> json) {
    return SmartLoginResponse(
      token: json['token'],
      success: json['success'],
      message: json['message'],
      data: SmartLoginData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class SmartLoginData {
  final UserData user;
  final CreditData credit;
  final ConsumptionData consumption;
  final GraphsData graphs;
  final SummaryData summary;
  final LinksData links;

  SmartLoginData({
    required this.user,
    required this.credit,
    required this.consumption,
    required this.graphs,
    required this.summary,
    required this.links,
  });

  factory SmartLoginData.fromJson(Map<String, dynamic> json) {
    return SmartLoginData(
      user: UserData.fromJson(json['user']),
      credit: CreditData.fromJson(json['credit']),
      consumption: ConsumptionData.fromJson(json['consumption']),
      graphs: GraphsData.fromJson(json['graphs']),
      summary: SummaryData.fromJson(json['summary']),
      links: LinksData.fromJson(json['links']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'credit': credit.toJson(),
      'consumption': consumption.toJson(),
      'graphs': graphs.toJson(),
      'summary': summary.toJson(),
      'links': links.toJson(),
    };
  }
}

class UserData {
  final String name;
  final String complex;
  final String unit;
  final String cellNo;

  UserData({
    required this.name,
    required this.complex,
    required this.unit,
    required this.cellNo,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      complex: json['complex'],
      unit: json['unit'],
      cellNo: json['cellNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'complex': complex,
      'unit': unit,
      'cellNo': cellNo,
    };
  }
}

class CreditData {
  final String remaining;
  final String date;

  CreditData({
    required this.remaining,
    required this.date,
  });

  factory CreditData.fromJson(Map<String, dynamic> json) {
    return CreditData(
      remaining: json['remaining'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'remaining': remaining,
      'date': date,
    };
  }
}

class ConsumptionData {
  final ConsumptionDetails electricity;
  final ConsumptionDetails water;
  final SharedServices sharedServices;

  ConsumptionData({
    required this.electricity,
    required this.water,
    required this.sharedServices,
  });

  factory ConsumptionData.fromJson(Map<String, dynamic> json) {
    return ConsumptionData(
      electricity: ConsumptionDetails.fromJson(json['electricity']),
      water: ConsumptionDetails.fromJson(json['water']),
      sharedServices: SharedServices.fromJson(json['sharedServices']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'electricity': electricity.toJson(),
      'water': water.toJson(),
      'sharedServices': sharedServices.toJson(),
    };
  }
}

class ConsumptionDetails {
  final String meterNumber;
  final String tariff;
  final String startDate;
  final double startRead;
  final double latestReading;
  final double usage;
  final String units;
  final String amount;

  ConsumptionDetails({
    required this.meterNumber,
    required this.tariff,
    required this.startDate,
    required this.startRead,
    required this.latestReading,
    required this.usage,
    required this.units,
    required this.amount,
  });

  factory ConsumptionDetails.fromJson(Map<String, dynamic> json) {
    return ConsumptionDetails(
      meterNumber: json['meterNumber'],
      tariff: json['tariff'],
      startDate: json['startDate'],
      startRead: json['startRead'].toDouble(),
      latestReading: json['latestReading'].toDouble(),
      usage: json['usage'].toDouble(),
      units: json['units'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meterNumber': meterNumber,
      'tariff': tariff,
      'startDate': startDate,
      'startRead': startRead,
      'latestReading': latestReading,
      'usage': usage,
      'units': units,
      'amount': amount,
    };
  }
}

class SharedServices {
  final String tariff;
  final int days;
  final String amount;

  SharedServices({
    required this.tariff,
    required this.days,
    required this.amount,
  });

  factory SharedServices.fromJson(Map<String, dynamic> json) {
    return SharedServices(
      tariff: json['tariff'],
      days: json['days'],
      amount: json['amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tariff': tariff,
      'days': days,
      'amount': amount,
    };
  }
}

class GraphsData {
  final List<ConsumptionGraphData> waterConsumption;
  final List<ConsumptionGraphData> electricityConsumption;

  GraphsData({
    required this.waterConsumption,
    required this.electricityConsumption,
  });

  factory GraphsData.fromJson(Map<String, dynamic> json) {
    return GraphsData(
      waterConsumption: (json['waterConsumption'] as List)
          .map((e) => ConsumptionGraphData.fromJson(e))
          .toList(),
      electricityConsumption: (json['electricityConsumption'] as List)
          .map((e) => ConsumptionGraphData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'waterConsumption': waterConsumption.map((e) => e.toJson()).toList(),
      'electricityConsumption':
          electricityConsumption.map((e) => e.toJson()).toList(),
    };
  }
}

class ConsumptionGraphData {
  final String month;
  final double heightPx;
  final int value;

  ConsumptionGraphData({
    required this.month,
    required this.heightPx,
    required this.value,
  });

  factory ConsumptionGraphData.fromJson(Map<String, dynamic> json) {
    return ConsumptionGraphData(
      month: json['month'],
      heightPx: json['heightPx'].toDouble(),
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'heightPx': heightPx,
      'value': value,
    };
  }
}

class SummaryData {
  final String totalAmount;
  final String latestInvoiceDate;

  SummaryData({
    required this.totalAmount,
    required this.latestInvoiceDate,
  });

  factory SummaryData.fromJson(Map<String, dynamic> json) {
    return SummaryData(
      totalAmount: json['totalAmount'],
      latestInvoiceDate: json['latestInvoiceDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAmount': totalAmount,
      'latestInvoiceDate': latestInvoiceDate,
    };
  }
}

class LinksData {
  final String accountStatement;
  final String editDetails;
  final String topUp;

  LinksData({
    required this.accountStatement,
    required this.editDetails,
    required this.topUp,
  });

  factory LinksData.fromJson(Map<String, dynamic> json) {
    return LinksData(
      accountStatement: json['accountStatement'],
      editDetails: json['editDetails'],
      topUp: json['topUp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountStatement': accountStatement,
      'editDetails': editDetails,
      'topUp': topUp,
    };
  }
}