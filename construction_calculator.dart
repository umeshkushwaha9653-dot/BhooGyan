import 'package:flutter/material.dart';

class ConstructionCalculatorScreen extends StatefulWidget {
  const ConstructionCalculatorScreen({super.key});

  @override
  State<ConstructionCalculatorScreen> createState() => _ConstructionCalculatorScreenState();
}

class _ConstructionCalculatorScreenState extends State<ConstructionCalculatorScreen> {
  // Controllers
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  // Variables for calculation
  String _wallType = '9_inch'; // '9_inch' or '4_inch'
  String _ratio = '1:4'; // '1:4' or '1:6'
  
  // Results
  int _totalBricks = 0;
  double _cementBags = 0.0;
  double _sandTons = 0.0;

  void _calculateConstruction() {
    if (_lengthController.text.isEmpty || _heightController.text.isEmpty) return;

    double length = double.tryParse(_lengthController.text) ?? 0;
    double height = double.tryParse(_heightController.text) ?? 0;

    double areaSqFt = length * height;

    if (areaSqFt <= 0) return;

    setState(() {
      // Basic Standard Estimations for Indian Construction
      if (_wallType == '9_inch') {
        _totalBricks = (areaSqFt * 9).round(); // approx 9 bricks per sqft for 9" wall
        
        if (_ratio == '1:4') {
          _cementBags = areaSqFt * 0.15; 
          _sandTons = areaSqFt * 0.025;
        } else { // 1:6
          _cementBags = areaSqFt * 0.10;
          _sandTons = areaSqFt * 0.030;
        }
      } else { // 4_inch wall
        _totalBricks = (areaSqFt * 4.5).round(); // approx 4.5 bricks per sqft for 4" wall
        
        if (_ratio == '1:4') {
          _cementBags = areaSqFt * 0.08;
          _sandTons = areaSqFt * 0.012;
        } else { // 1:6
          _cementBags = areaSqFt * 0.06;
          _sandTons = areaSqFt * 0.015;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('निर्माण कैलकुलेटर', style: TextStyle(color: Color(0xFFFFD700))),
        backgroundColor: const Color(0xFF1E1E24),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'दीवार का आकार (Wall Size) चुनें:',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('9 इंच (9")', style: TextStyle(color: Colors.white)),
                    value: '9_inch',
                    groupValue: _wallType,
                    activeColor: const Color(0xFFFFD700),
                    onChanged: (value) {
                      setState(() {
                        _wallType = value!;
                        _calculateConstruction();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('4 इंच (4")', style: TextStyle(color: Colors.white)),
                    value: '4_inch',
                    groupValue: _wallType,
                    activeColor: const Color(0xFFFFD700),
                    onChanged: (value) {
                      setState(() {
                        _wallType = value!;
                        _calculateConstruction();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            const Text(
              'मसाला का अनुपात (Cement : Sand):',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _ratio,
              dropdownColor: const Color(0xFF2D2D38),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E1E24),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              items: const [
                DropdownMenuItem(value: '1:4', child: Text('1:4 (मजबूत/Strong)')),
                DropdownMenuItem(value: '1:6', child: Text('1:6 (सामान्य/Normal)')),
              ],
              onChanged: (value) {
                setState(() {
                  _ratio = value!;
                  _calculateConstruction();
                });
              },
            ),
            const SizedBox(height: 25),

            // Input Fields
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _lengthController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _calculateConstruction(),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'लंबाई (फ़ुट में)',
                      labelStyle: const TextStyle(color: Color(0xFFFFE66D)),
                      filled: true,
                      fillColor: const Color(0xFF1E1E24),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _calculateConstruction(),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'ऊंचाई (फ़ुट में)',
                      labelStyle: const TextStyle(color: Color(0xFFFFE66D)),
                      filled: true,
                      fillColor: const Color(0xFF1E1E24),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Result Card
            if (_totalBricks > 0)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D38),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFFD700), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'अनुमानित सामग्री (Estimated Material):',
                      style: TextStyle(color: Color(0xFFFFD700), fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 10),
                    _buildResultRow(Icons.dashboard_customize, 'कुल ईंटें (Bricks)', '$_totalBricks नग'),
                    const SizedBox(height: 10),
                    _buildResultRow(Icons.inventory_2, 'सीमेंट (Cement)', '${_cementBags.toStringAsFixed(1)} बोरी'),
                    const SizedBox(height: 10),
                    _buildResultRow(Icons.layers, 'रेत/बजरी (Sand)', '${_sandTons.toStringAsFixed(2)} टन'),
                  ],
                ),
              ),

            const SizedBox(height: 25),

            // Download PDF & Share Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF28A745),
                      padding: const EdgeInsets.vertical(14),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Excel PDF रिपोर्ट डाउनलोड हो रही है...')),
                      );
                    },
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                    label: const Text('डाउनलोड PDF', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF075E54),
                      padding: const EdgeInsets.vertical(14),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('WhatsApp पर Excel रिपोर्ट शेयर हो रही है...')),
                      );
                    },
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text('व्हाट्सएप शेयर', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 16)),
          ],
        ),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
