import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool _orderUpdatesEnabled = true;
  bool _promotionsEnabled = false;
  bool _newsletterEnabled = true;
  bool _smsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orderUpdatesEnabled = prefs.getBool('orderUpdates') ?? true;
      _promotionsEnabled = prefs.getBool('promotions') ?? false;
      _newsletterEnabled = prefs.getBool('newsletter') ?? true;
      _smsEnabled = prefs.getBool('sms') ?? false;
    });
  }

  Future<void> _savePref(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Widget toggleTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title),
      subtitle: Text(subtitle),
      activeColor: Colors.teal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 0,
      color: const Color.fromARGB(255, 255, 255, 255),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          toggleTile(
            "Order Updates",
            "Get notified about order status changes",
            _orderUpdatesEnabled,
            (value) {
              setState(() => _orderUpdatesEnabled = value);
              _savePref('orderUpdates', value);
            },
          ),
          toggleTile(
            "Promotions",
            "Receive promotional offers and discounts",
            _promotionsEnabled,
            (value) {
              setState(() => _promotionsEnabled = value);
              _savePref('promotions', value);
            },
          ),
          toggleTile(
            "Newsletter",
            "Weekly newsletter with updates",
            _newsletterEnabled,
            (value) {
              setState(() => _newsletterEnabled = value);
              _savePref('newsletter', value);
            },
          ),
          toggleTile(
            "SMS Notifications",
            "Receive text message updates",
            _smsEnabled,
            (value) {
              setState(() => _smsEnabled = value);
              _savePref('sms', value);
            },
          ),
        ],
      ),
    );
  }
}
