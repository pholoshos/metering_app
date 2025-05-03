import 'package:flutter/material.dart';
import '../screens/notifications_screen.dart';
import '../screens/tips_screen.dart';
import '../screens/contact_screen.dart';
import '../screens/home_screen.dart';

class AppScaffold extends StatefulWidget {
  final Widget child;
  final String title;
  final bool showBackButton;
  final FloatingActionButton floatingActionButton;
  final showFloatingActionButton = true;

  const AppScaffold({
    super.key,
    required this.child,
    required this.title,
    this.showBackButton = true,
    showFloatingActionButton = false,
    this.floatingActionButton = const FloatingActionButton(
      onPressed: null,
      tooltip: 'Increment',
      child: Icon(Icons.add),
    ),
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NotificationsScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TipsScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ContactScreen()),
        );
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    // Set initial index based on current screen
    if (widget.title == 'Notifications') {
      _selectedIndex = 1;
    } else if (widget.title == 'Electricity Saving Tips') {
      _selectedIndex = 2;
    } else if (widget.title == 'Contact Us') {
      _selectedIndex = 3;
    } else {
      _selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(4),
              child: Image.asset(
                'assets/images/icon.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Text(widget.title),
          ],
        ),
        automaticallyImplyLeading: widget.showBackButton,
      ),
      body: widget.child,
      floatingActionButton: widget.showFloatingActionButton
          ? widget.floatingActionButton
          : null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Tips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_phone),
            label: 'Contact',
          ),
        ],
      ),
    );
  }
}