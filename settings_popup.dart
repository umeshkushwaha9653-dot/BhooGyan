import 'package:flutter/material.dart';

class SettingsDrawer extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;
  final bool isDarkMode;
  final String currentLang;

  const SettingsDrawer({
    super.key,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.isDarkMode,
    required this.currentLang,
  });

  @override
  State<SettingsDrawer> createState() => _SettingsDrawerState();
}

class _SettingsDrawerState extends State<SettingsDrawer> {
  late bool _isDark;
  late String _lang;

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDarkMode;
    _lang = widget.currentLang;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: _isDark ? const Color(0xFF1E1E24) : Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings, color: Color(0xFFFFD700), size: 28),
                const SizedBox(width: 10),
                Text(
                  _lang == 'HI' ? 'ऐप सेटिंग्स' : 'App Settings',
                  style: TextStyle(
                    color: _isDark ? Colors.white : Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey, height: 30),

            // Theme Toggle Option
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                _isDark ? Icons.dark_mode : Icons.light_mode,
                color: const Color(0xFFFFD700),
              ),
              title: Text(
                _lang == 'HI' ? 'डार्क/लाइट मोड' : 'Dark/Light Mode',
                style: TextStyle(color: _isDark ? Colors.white : Colors.black, fontWeight: FontWeight.w600),
              ),
              trailing: Switch(
                value: _isDark,
                activeColor: const Color(0xFFFFD700),
                onChanged: (val) {
                  setState(() => _isDark = val);
                  widget.onThemeChanged(val);
                },
              ),
            ),
            const SizedBox(height: 15),

            // Language Selection Option
            Text(
              _lang == 'HI' ? 'भाषा चुनें (Language)' : 'Select Language',
              style: TextStyle(color: _isDark ? Colors.white70 : Colors.black70, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _lang == 'HI' ? const Color(0xFFFFD700) : (_isDark ? const Color(0xFF2D2D38) : Colors.grey[300]),
                    ),
                    onPressed: () {
                      setState(() => _lang = 'HI');
                      widget.onLanguageChanged('HI');
                    },
                    child: Text('हिंदी', style: TextStyle(color: _lang == 'HI' ? Colors.black : (_isDark ? Colors.white : Colors.black))),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _lang == 'EN' ? const Color(0xFFFFD700) : (_isDark ? const Color(0xFF2D2D38) : Colors.grey[300]),
                    ),
                    onPressed: () {
                      setState(() => _lang = 'EN');
                      widget.onLanguageChanged('EN');
                    },
                    child: Text('English', style: TextStyle(color: _lang == 'EN' ? Colors.black : (_isDark ? Colors.white : Colors.black))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
