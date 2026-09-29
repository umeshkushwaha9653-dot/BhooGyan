import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  void _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(child: Text(content)),
          actions: [
            TextButton(
              child: const Text('ठीक है'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
            color: const Color(0xFF2A2A32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAlignment.start,
                  children: const [
                    Text(
                      'भू-ज्ञान सहायता केंद्र',
                      style: TextStyle(color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'हेल्पलाइन एवं लीगल सेंटर',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.share, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  title: 'संपर्क करें',
                  subtitle: 'हेल्पलाइन नंबर और कस्टमर सपोर्ट',
                  dialogTitle: 'संपर्क करें',
                  dialogContent: 'ईमेल: support@bhoogyan.app\nहेल्पलाइन: +91 1800-XXX-XXXX\nसमय: सुबह 9 से शाम 6 बजे तक',
                ),
                _buildDrawerItem(
                  context,
                  title: 'हमारे बारे में',
                  subtitle: 'भू-ज्ञान ऐप और सेवाओं की जानकारी',
                  dialogTitle: 'हमारे बारे में',
                  dialogContent: 'भू-ज्ञान ऐप आपको भूमि मापन, निर्माण कैलकुलेटर और वित्तीय गणनाओं के लिए आसान उपकरण प्रदान करता है।',
                ),
                _buildDrawerItem(
                  context,
                  title: 'नियम एवं शर्तें',
                  subtitle: 'उपयोग की शर्तें और लीगल नीतियां',
                  dialogTitle: 'नियम एवं शर्तें',
                  dialogContent: 'इस ऐप का उपयोग केवल सामान्य जानकारी और मापन उद्देश्यों के लिए किया जाता है।',
                ),
                _buildDrawerItem(
                  context,
                  title: 'गोपनीयता नीति',
                  subtitle: 'डेटा सुरक्षा और गोपनीयता नियम',
                  dialogTitle: 'गोपनीयता नीति',
                  dialogContent: 'हम आपकी गोपनीयता का सम्मान करते हैं। आपका कोई भी व्यक्तिगत डेटा बिना आपकी अनुमति के साझा नहीं किया जाता है।',
                ),
                _buildDrawerItem(
                  context,
                  title: 'शिकायत दर्ज करें',
                  subtitle: 'समस्या या बग की तुरंत रिपोर्ट करें',
                  dialogTitle: 'शिकायत दर्ज करें',
                  dialogContent: 'यदि आपको ऐप में कोई समस्या आती है, तो कृपया support@bhoogyan.app पर समस्या का विवरण भेजें।',
                ),
                _buildDrawerItem(
                  context,
                  title: 'सुझाव एवं प्रतिक्रिया',
                  subtitle: 'ऐप सुधार हेतु अपना सुझाव भेजें',
                  dialogTitle: 'सुझाव एवं प्रतिक्रिया',
                  dialogContent: 'आपके सुझाव हमारे लिए मूल्यवान हैं! अपना फीडबैक हमें ईमेल द्वारा भेजें।',
                ),
                _buildDrawerItem(
                  context,
                  title: 'ऐप शेयर करें',
                  subtitle: 'दोस्तों और परिवार के साथ साझा करें',
                  dialogTitle: 'ऐप शेयर करें',
                  dialogContent: 'अपने दोस्तों और परिवार के साथ भू-ज्ञान ऐप शेयर करें ताकि वे भी इसका लाभ उठा सकें!',
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text('सेटिंग्स', style: TextStyle(color: Colors.grey)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String dialogTitle,
    required String dialogContent,
  }) {
    return ListTile(
      leading: const Icon(Icons.circle, color: Colors.amber, size: 10),
      title: Text(
        title,
        style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      onTap: () {
        Navigator.pop(context);
        _showDialog(context, dialogTitle, dialogContent);
      },
    );
  }
}
