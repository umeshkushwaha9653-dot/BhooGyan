import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {'title': 'संपर्क करें', 'subtitle': 'हेल्पलाइन नंबर और कस्टमर सपोर्ट'},
      {'title': 'हमारे बारे में', 'subtitle': 'भू-ज्ञान ऐप और सेवाओं की जानकारी'},
      {'title': 'नियम एवं शर्तें', 'subtitle': 'उपयोग की शर्तें और लीगल नीतियां'},
      {'title': 'गोपनीयता नीति', 'subtitle': 'डेटा सुरक्षा और गोपनीयता नियम'},
      {'title': 'शिकायत दर्ज करें', 'subtitle': 'समस्या या बग की तुरंत रिपोर्ट करें'},
      {'title': 'सुझाव एवं प्रतिक्रिया', 'subtitle': 'ऐप सुधार हेतु अपना सुझाव भेजें'},
      {'title': 'ऐप शेयर करें', 'subtitle': 'दोस्तों और परिवार के साथ साझा करें'},
    ];

    return Drawer(
      child: Container(
        color: const Color(0xFF18181A),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
              color: const Color(0xFF202026),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'भू-ज्ञान सहायता केंद्र',
                    style: TextStyle(color: Color(0xFFFFD700), fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'हेल्पलाइन एवं लीगल सेंटर',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: menuItems.length,
                separatorBuilder: (context, index) => const Divider(color: Color(0xFF3A3A42), height: 1),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.circle, color: Color(0xFFFFD700), size: 10),
                    title: Text(
                      menuItems[index]['title']!,
                      style: const TextStyle(color: Color(0xFFFFE66D), fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      menuItems[index]['subtitle']!,
                      style: const TextStyle(color: Colors.white54, fontSize: 11),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
