import 'package:flutter/material.dart';

import '../camps/camps_screen.dart';
import '../donate/donate_screen.dart';
import '../find_blood/find_blood_screen.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';

/// Hosts the 5 bottom-navigation tabs (Phase 2):
/// Home | Find Blood | Donate | Camps | Profile
///
/// Hospitals and Blood Banks remain reachable from the Home tab's
/// "Nearby" sections (See all / card taps).
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.bloodtype_outlined),
      selectedIcon: Icon(Icons.bloodtype),
      label: 'Find Blood',
    ),
    NavigationDestination(
      icon: Icon(Icons.volunteer_activism_outlined),
      selectedIcon: Icon(Icons.volunteer_activism),
      label: 'Donate',
    ),
    NavigationDestination(
      icon: Icon(Icons.campaign_outlined),
      selectedIcon: Icon(Icons.campaign),
      label: 'Camps',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  static const List<Widget> _screens = [
    HomeScreen(),
    FindBloodScreen(),
    DonateScreen(),
    CampsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: _destinations,
      ),
    );
  }
}
