import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Notifications',
      showBackButton: false,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                Icon(
                  Icons.notifications_none,
                  size: 80,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Keep an eye here for updates and alerts',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // NotificationCard(
          //   title: 'Loadshedding Alert',
          //   message: 'Stage 2 loadshedding scheduled from 18:00 to 22:00',
          //   time: '2 hours ago',
          //   type: NotificationType.warning,
          // ),
          // NotificationCard(
          //   title: 'Low Balance Warning',
          //   message: 'Your electricity balance is below R50. Consider purchasing more units.',
          //   time: '5 hours ago',
          //   type: NotificationType.alert,
          // ),
          // NotificationCard(
          //   title: 'Payment Successful',
          //   message: 'Your electricity purchase of R200 was successful.',
          //   time: '1 day ago',
          //   type: NotificationType.success,
          // ),
        ],
      ),
    );
  }
}

enum NotificationType { warning, alert, success }

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final NotificationType type;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(
          _getIcon(),
          color: _getColor(context),
          size: 24,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(message),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  IconData _getIcon() {
    switch (type) {
      case NotificationType.warning:
        return Icons.warning_amber_rounded;
      case NotificationType.alert:
        return Icons.notification_important;
      case NotificationType.success:
        return Icons.check_circle_outline;
    }
  }

  Color _getColor(BuildContext context) {
    switch (type) {
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.alert:
        return Colors.red;
      case NotificationType.success:
        return Colors.green;
    }
  }
}