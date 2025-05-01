import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount (R)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
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
            _buildUserInfo(),
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

  Widget _buildUserInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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
          ],
        ),
      ),
    );
  }

  Widget _buildCreditInfo(BuildContext context) {
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
            const SizedBox(height: 8),
            Text(
              loginData.data.credit.remaining,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              'Last Updated: ${loginData.data.credit.date}',
              style: TextStyle(
                color: Colors.grey[600],
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 800, // Fixed width for the chart
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
                                    loginData.data.graphs.electricityConsumption
                                        .length) {
                              return Text(loginData.data.graphs
                                  .electricityConsumption[value.toInt()].month);
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
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