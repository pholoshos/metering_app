import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/app_scaffold.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchPhone(String phone) async {
    final url = 'tel:$phone';
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> _launchEmail(String email) async {
    final url = 'mailto:$email';
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _buildContactItem(String title, String content, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              content,
              style: TextStyle(
                color: onTap != null ? Colors.blue : Colors.black87,
                decoration: onTap != null ? TextDecoration.underline : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Get in Touch',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Our team is eager to provide the service you want and deserve. If you have any questions or comments, do get in touch on:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            
            _buildSectionTitle('Head Office Pretoria'),
            _buildContactItem(
              'Phone',
              '(012) 804 1039',
              onTap: () => _launchPhone('0128041039'),
            ),
            _buildContactItem(
              'Address',
              '80 Rauch Avenue\nGeorgeville\nPretoria',
            ),
            
            _buildSectionTitle('Midrand Office'),
            _buildContactItem(
              'Phone',
              '(011) 238 2900',
              onTap: () => _launchPhone('0112382900'),
            ),
            _buildContactItem(
              'Address',
              'Tuscan Gardens Suite 5\n14th Avenue\nNoordwyk',
            ),
            
            _buildSectionTitle('After Hours Support'),
            const Text(
              'IMPORTANT: After hours support is for technical emergencies only.',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildContactItem('Operating Hours', 'Calls: 16:30-20:00\nSMS queries: 16:30-21:00'),
            _buildContactItem(
              'Conventional Accounts',
              '066 301 4849',
              onTap: () => _launchPhone('0663014849'),
            ),
            _buildContactItem(
              'Prepaid Accounts',
              '066 301 4851',
              onTap: () => _launchPhone('0663014851'),
            ),
            
            _buildSectionTitle('Email Addresses'),
            _buildContactItem(
              'General and Account Queries',
              'info@proteametering.co.za',
              onTap: () => _launchEmail('info@proteametering.co.za'),
            ),
            _buildContactItem(
              'Prepaid and Smart Metering Queries',
              'prepaid@proteametering.co.za',
              onTap: () => _launchEmail('prepaid@proteametering.co.za'),
            ),
            _buildContactItem(
              'Meter Readings',
              'readings@proteametering.co.za',
              onTap: () => _launchEmail('readings@proteametering.co.za'),
            ),
            
            _buildSectionTitle('Information Officer'),
            _buildContactItem(
              'Cornette Joynt',
              'cornette@proteametering.co.za',
              onTap: () => _launchEmail('cornette@proteametering.co.za'),
            ),
            const Text(
              '*Information Officer in terms of the PROMOTION OF ACCESS TO INFORMATION ACT 2 OF 2000 and the PROTECTION OF PERSONAL INFORMATION ACT 4 of 2013',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
            
            _buildSectionTitle('Office Hours'),
            _buildContactItem('Monday - Friday', '8:00 → 16:30'),
            _buildContactItem(
              'Saturday, Sunday and Public Holidays',
              'Closed (After Hours Numbers open)',
            ),
          ],
        ),
      ),
    );
  }
}