import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'tasks_screen.dart';
import 'timer_screen.dart';
import 'settings_screen.dart';

//the mainshell of the app serves as the navigation hub
// a ststeful widget is used because we need to track the current tab that is active
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  //sets the current active tab to 0 which is the dashboard screen
  int _currentIndex = 0;

// a list of screens that we can navigate to using the bottom navigation bar
// const is used to mkae the list immutable and improve performance
  final List<Widget> _screens = const [
    DashboardScreen(),
    TasksScreen(),
    TimerScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex, // highlights the current active tab which is the dashboard screen
        //when a user taps a tab, it trigger a ui refresh by calling setstate and updates the current index to the index of the tapped tab
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Timer',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
