import 'package:flutter/material.dart';
import 'land_calculator.dart';
import 'construction_calculator.dart';
import 'unit_converter.dart';
import 'emi_calculator.dart';
import 'custom_drawer.dart';
import 'settings_popup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isDarkMode = true;
  String _currentLang = 'HI';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _toggleTheme(bool isDark) {
    setState(() {
      _isDarkMode = isDark;
    });
  }

  void _changeLanguage(String lang) {
    setState(() {
      _currentLang = lang;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: _isDarkMode ? const Color(0xFF1E1E24) : Colors.white,
        elevation: 2,
        title: Text(
          _currentLang == 'HI' ? 'भू-ज्ञान (BhooGyan)' : 'BhooGyan',
          style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: _isDarkMode ? Colors.white : Colors.black),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ऐप शेयर लिंक कॉपी हो गया है!')),
              );
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      endDrawer: SettingsDrawer(
        isDarkMode: _isDarkMode,
        currentLang: _currentLang,
        onThemeChanged: _toggleTheme,
        onLanguageChanged: _changeLanguage,
      ),
      body: _buildSelectedTab(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.grey,
        backgroundColor: _isDarkMode ? const Color(0xFF1E1E24) : Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 3) {
            _scaffoldKey.currentState?.openEndDrawer();
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: _currentLang == 'HI' ? 'होम' : 'Home',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: _currentLang == 'HI' ? 'हिस्ट्री' : 'History',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.folder),
            label: _currentLang == 'HI' ? 'फ़ाइल' : 'Files',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: _currentLang == 'HI' ? 'सेटिंग्स' : 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTab() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeGrid();
      case 1:
        return Center(
          child: Text(
            _currentLang == 'HI' ? 'आपकी पिछली कैलकुलेशन यहाँ दिखेंगी' : 'Recent Calculations History',
            style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
          ),
        );
      case 2:
        return Center(
          child: Text(
            _currentLang == 'HI' ? 'डाउनलोड की गई PDF/Excel फाइलें यहाँ होंगी' : 'Downloaded Reports & Files',
            style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
          ),
        );
      default:
        return _buildHomeGrid();
    }
  }

  Widget _buildHomeGrid() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _currentLang == 'HI' ? 'मुख्य कैलकुलेटर्स' : 'Main Calculators',
            style: TextStyle(
              color: _isDarkMode ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildCalcCard(
                title: _currentLang == 'HI' ? 'ज़मीन नाप' : 'Land Measure',
                subtitle: _currentLang == 'HI' ? 'बीघा, एकड़, गज, फुट' : 'Bigha, Acre, Gaj, Sqft',
                icon: Icons.landscape,
                color: Colors.amber,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LandCalculatorScreen())),
              ),
              _buildCalcCard(
                title: _currentLang == 'HI' ? 'निर्माण' : 'Construction',
                subtitle: _currentLang == 'HI' ? 'ईंट, सीमेंट, रेत, दीवार' : 'Bricks, Cement, Sand, Wall',
                icon: Icons.home_repair_service,
                color: Colors.orange,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConstructionCalculatorScreen())),
              ),
              _buildCalcCard(
                title: _currentLang == 'HI' ? 'इकाई कनवर्टर' : 'Unit Converter',
                subtitle: _currentLang == 'HI' ? 'लंबाई, क्षेत्रफल, वजन' : 'Length, Area, Weight',
                icon: Icons.swap_horiz,
                color: Colors.green,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UnitConverterScreen())),
              ),
              _buildCalcCard(
                title: _currentLang == 'HI' ? 'EMI कैलकुलेटर' : 'EMI Calculator',
                subtitle: _currentLang == 'HI' ? 'ऋण किश्त और ब्याज' : 'Home, Loan & Interest',
                icon: Icons.calculate,
                color: Colors.purpleAccent,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmiCalculatorScreen())),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalcCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _isDarkMode ? const Color(0xFF1E1E24) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _isDarkMode ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _isDarkMode ? Colors.white54 : Colors.black54,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
