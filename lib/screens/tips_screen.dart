import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Electricity Saving Tips',
      showBackButton: false,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          // Loadshedding Tips
          TipCard(
            title: 'Prepare for Loadshedding',
            description: 'Keep power banks charged and have emergency lights ready before scheduled loadshedding.',
            icon: Icons.power_settings_new,
          ),
          TipCard(
            title: 'Schedule Around Loadshedding',
            description: 'Plan energy-intensive activities (cooking, laundry) outside loadshedding hours.',
            icon: Icons.schedule,
          ),
          TipCard(
            title: 'Backup Power Solutions',
            description: 'Consider investing in UPS or inverter systems for essential devices during loadshedding.',
            icon: Icons.battery_charging_full,
          ),
          // Energy Saving Tips
          TipCard(
            title: 'Switch to LED Bulbs',
            description: 'LED bulbs use up to 90% less energy than traditional bulbs and last much longer.',
            icon: Icons.lightbulb_outline,
          ),
          TipCard(
            title: 'Unplug Idle Electronics',
            description: 'Even when turned off, plugged-in electronics consume power. Unplug them when not in use.',
            icon: Icons.power_off,
          ),
          TipCard(
            title: 'Use Natural Light',
            description: 'Open curtains during the day to use natural light instead of electric lighting.',
            icon: Icons.wb_sunny,
          ),
          TipCard(
            title: 'Maintain Your Appliances',
            description: 'Regular maintenance ensures appliances run efficiently and use less electricity.',
            icon: Icons.build,
          ),
          TipCard(
            title: 'Use Cold Water',
            description: 'Use cold water for laundry when possible. It saves energy and is often just as effective.',
            icon: Icons.opacity,
          ),
          TipCard(
            title: 'Smart Power Strips',
            description: 'Use smart power strips to automatically cut power to devices when not in use.',
            icon: Icons.electrical_services,
          ),
          TipCard(
            title: 'Energy-Efficient Appliances',
            description: 'When replacing appliances, choose ones with high energy efficiency ratings.',
            icon: Icons.eco,
          ),
        ],
      ),
    );
  }
}

class TipCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const TipCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}