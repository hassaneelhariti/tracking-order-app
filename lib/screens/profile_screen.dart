import 'package:flutter/material.dart';
import 'package:order_tracking/widgets/header.dart';
import 'package:order_tracking/widgets/profile/personal_info_tab.dart';
import 'package:order_tracking/widgets/profile/profiel_header.dart';
import 'package:order_tracking/widgets/profile/profile_tabs.dart';
import 'package:order_tracking/widgets/profile/security_tab.dart';
import 'package:order_tracking/widgets/profile/settings_tab.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedTab = 0;

  void _onTabChange(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabContents = [
      const PersonalInfoTab(),
      const SettingsTab(),
      const SecurityTab(),
    ];
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(title: "Profile"),
              const SizedBox(height: 20),
              ProfileHeader(),
              SizedBox(height: 16),
              Expanded(
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ProfileTabs(
                          selectedIndex: _selectedTab,
                          onTabChanged: _onTabChange,
                        ),
                        tabContents[_selectedTab],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
