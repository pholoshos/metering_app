import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:protea_metering/models/smart_login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import 'dart:convert';

class CustomerQueryScreen extends StatefulWidget {
  final String token;

  const CustomerQueryScreen({
    super.key,
    required this.token,
  });

  @override
  State<CustomerQueryScreen> createState() => _CustomerQueryScreenState();
}

class _CustomerQueryScreenState extends State<CustomerQueryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _meterNumberController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedType = 'Technical';
  bool _isLoading = false;

  @override
  void dispose() {
    _customerNameController.dispose();
    _meterNumberController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitQuery() async {

    setState(() => _isLoading = true);

    try {
      //get stored user details
      var storedUserPrefs = await SharedPreferences.getInstance();
      var userDetails = storedUserPrefs.getString('userDetails');
      SmartLoginResponse smartLoginResponse = SmartLoginResponse.fromJson(
        jsonDecode(
          userDetails ?? '',
        ),
      );

      print(smartLoginResponse.data.user.name);

      final response = await http.post(
        Uri.parse('${ApiConfig.getBaseUrl()}/proteaMetering/customerQuery'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'customerName': smartLoginResponse.data.user.name,
          'meterNumber': _meterNumberController.text,
          'description': _descriptionController.text,
          'cellNo': smartLoginResponse.data.user.cellNo,
          'complexName': smartLoginResponse.data.user.name,
          'unit' : smartLoginResponse.data.user.unit,
          'type': _selectedType,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Query submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit query. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submit Query'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Query Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        'Technical',
                        'Billing',
                        'Connection',
                        'Complaint',
                        'Cancellation',
                        'Feedback',
                        'Other',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedType = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please describe your query';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitQuery,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Submit Query'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}