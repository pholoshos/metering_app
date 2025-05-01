import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:protea_metering/screens/smart_statements_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../models/smart_login_response.dart';
import '../widgets/app_scaffold.dart';
import '../config/api_config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';

class SmartComplexScreen extends StatelessWidget {
  final SmartLoginResponse loginData;
  

  const SmartComplexScreen({
    super.key,
    required this.loginData,
  });

  Future<void> _handleTopUp(BuildContext context) async {
    final amount = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Top Up Amount'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount (R)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'You can also top up via bank transfer:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Bank: FNB'),
              const Text('Branch code: 252 445'),
              const Text('Account Number: 6238 9132 946'),
              const Text('Reference: Your-ref'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Top Up'),
            ),
          ],
        );
      },
    );

    if (amount != null && amount.isNotEmpty) {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        final response = await http.post(
          Uri.parse(ApiConfig.topUp()),
          headers: {
            'Authorization': 'Bearer ${loginData.token}',
            'Content-Type': 'application/json',
          },
          body: '{"amount": "$amount"}',
        );

        if (!context.mounted) return;
        
        // Hide loading dialog
        Navigator.pop(context);

        if (response.statusCode == 200) {
       
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TopUpWebView(htmlContent: response.body),
              ),
            );
          
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to process top up. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (!context.mounted) return;
        
        // Hide loading dialog in case of error
        Navigator.pop(context);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Smart Complex',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(context),
            const SizedBox(height: 16),
            _buildCreditInfo(context),
            const SizedBox(height: 16),
            _buildConsumptionInfo(),
            const SizedBox(height: 16),
            _buildGraphs(),
            const SizedBox(height: 16),
            _buildSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(context) {
    return Card(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
              'Welcome, ${loginData.data.user.name}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Complex: ${loginData.data.user.complex}'),
            Text('Unit: ${loginData.data.user.unit}'),
            Text('Cell: ${loginData.data.user.cellNo}'),
              ]),
            
            
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SmartStatementsScreen(
                      token: loginData.token,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.receipt_long),
              label: const Text('View Statements'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditInfo(BuildContext context) {
    // Extract numeric value from balance string (assuming format "R X.XX")
    final balanceStr = loginData.data.credit.remaining;
    final balance = double.tryParse(balanceStr.replaceAll('R ', '')) ?? 0.0;
    final isZero = balance <= 0;
    
    // Extract maximum from total amount in summary
    final maxAmountStr = loginData.data.summary.totalAmount;
    final maxAmount = double.tryParse(maxAmountStr.replaceAll('R ', '')) ?? 2000.0;
    
    // Calculate progress value (0 to 1) based on balance
    final progress = (balance / maxAmount).clamp(0.0, 1.0);

    // Determine color based on percentage
    Color getProgressColor() {
      if (isZero) return Colors.grey[400]!;
      
      final percentage = progress * 100;
      if (percentage >= 75) return Colors.green;
      if (percentage >= 50) return Colors.yellow;
      if (percentage >= 25) return Colors.orange;
      return Colors.red;
    }

    // Get tip message based on percentage
    String getTipMessage() {
      final percentage = progress * 100;
      if (isZero) {
        return 'Critical: Your balance is depleted! Top up immediately to restore services. Contact support if you need assistance.';
      } else if (percentage >= 75) {
        return '✅ Excellent! Your balance is healthy. Consider enabling auto-payments to maintain this level and avoid any interruptions.';
      } else if (percentage >= 50) {
        return '👍 Good standing! Keep monitoring your usage patterns in the graphs below to optimize your consumption.';
      } else if (percentage >= 25) {
        return '⚠️ Notice: Your balance is getting low. Plan to top up within the next few days to maintain service.';
      } else {
        return '🚨 Warning: Critical low balance! Top up now to avoid service interruption. Consider setting up balance alerts.';
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Credit Balance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _handleTopUp(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Top Up'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),           
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[100],
                      ),
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: CircularProgressIndicator(
                          value: isZero ? 1.0 : progress,
                          backgroundColor: Colors.grey[300],
                          color: getProgressColor(),
                          strokeWidth: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            balanceStr,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: isZero ? Colors.grey[600] : getProgressColor(),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'of $maxAmountStr',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Last Updated:',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            loginData.data.credit.date,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              getTipMessage(),
              style: TextStyle(
                fontSize: 14,
                color: getProgressColor(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsumptionInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Consumption Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildConsumptionSection(
              'Electricity',
              loginData.data.consumption.electricity,
              Icons.electric_bolt,
            ),
            const Divider(),
            _buildConsumptionSection(
              'Water',
              loginData.data.consumption.water,
              Icons.water_drop,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.payments),
              title: const Text('Shared Services'),
              subtitle: Text(loginData.data.consumption.sharedServices.tariff),
              trailing: Text(
                loginData.data.consumption.sharedServices.amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsumptionSection(String title, dynamic data, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text('Meter: ${data.meterNumber}'),
          trailing: Text(
            data.amount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tariff: ${data.tariff}'),
              Text('Start Date: ${data.startDate}'),
              Text('Usage: ${data.usage} ${data.units}'),
              Text('Latest Reading: ${data.latestReading} ${data.units}'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGraphs() {
    // Calculate averages
    double electricityAvg = loginData.data.graphs.electricityConsumption
        .map((e) => e.value.toDouble())
        .reduce((a, b) => a + b) / loginData.data.graphs.electricityConsumption.length;
    
    double waterAvg = loginData.data.graphs.waterConsumption
        .map((e) => e.value.toDouble())
        .reduce((a, b) => a + b) / loginData.data.graphs.waterConsumption.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Consumption History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Electricity Graph
            const Text(
              'Electricity Usage',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Average: ${electricityAvg.toStringAsFixed(2)} kWh',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 800,
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 200,
                    barGroups: loginData.data.graphs.electricityConsumption
                        .asMap()
                        .entries
                        .map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.value.toDouble(),
                            color: Colors.blue,
                            width: 16,
                          ),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 &&
                                value.toInt() <
                                    loginData.data.graphs.electricityConsumption.length) {
                              return Text(loginData.data.graphs
                                  .electricityConsumption[value.toInt()].month);
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Water Graph
            const Text(
              'Water Usage',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Average: ${waterAvg.toStringAsFixed(2)} kL',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 800,
                height: 200,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 200,
                    barGroups: loginData.data.graphs.waterConsumption
                        .asMap()
                        .entries
                        .map((entry) {
                      return BarChartGroupData(
                        x: entry.key,
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.value.toDouble(),
                            color: Colors.lightBlue,
                            width: 16,
                          ),
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() >= 0 &&
                                value.toInt() <
                                    loginData.data.graphs.waterConsumption.length) {
                              return Text(loginData.data.graphs
                                  .waterConsumption[value.toInt()].month);
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: true),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount:'),
                Text(
                  loginData.data.summary.totalAmount,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Latest Invoice Date: ${loginData.data.summary.latestInvoiceDate}',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopUpWebView extends StatelessWidget {
  final String htmlContent;

  const TopUpWebView({
    super.key,
    required this.htmlContent,
  });

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(htmlContent);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up Details'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}