import 'package:flutter/material.dart';

class LandCalculatorScreen extends StatefulWidget {
  const LandCalculatorScreen({super.key});

  @override
  State<LandCalculatorScreen> createState() => _LandCalculatorScreenState();
}

class _LandCalculatorScreenState extends State<LandCalculatorScreen> {
  // Controllers for text fields
  final Map<String, TextEditingController> _controllers = {
    'sqft': TextEditingController(),
    'sqgaj': TextEditingController(),
    'bigha': TextEditingController(),
    'kattha': TextEditingController(),
    'dhur': TextEditingController(),
    'acre': TextEditingController(),
    'hectare': TextEditingController(),
  };

  // Standard Standard Conversion Rates (Base: Sq. Feet)
  // 1 Bigha = 27225 Sq. Ft | 1 Kattha = 1361.25 Sq. Ft | 1 Dhur = 68.06 Sq. Ft
  // 1 Acre = 43560 Sq. Ft | 1 Hectare = 107639 Sq. Ft | 1 Sq. Gaj = 9 Sq. Ft

  void _calculateValues(String sourceKey, String valueStr) {
    if (valueStr.isEmpty) {
      _clearAll(exceptKey: sourceKey);
      return;
    }

    double? val = double.tryParse(valueStr);
    if (val == null) return;

    double sqft = 0;

    // Convert source input to Base Unit (Sq. Feet)
    switch (sourceKey) {
      case 'sqft': sqft = val; break;
      case 'sqgaj': sqft = val * 9; break;
      case 'bigha': sqft = val * 27225; break;
      case 'kattha': sqft = val * 1361.25; break;
      case 'dhur': sqft = val * 68.0625; break;
      case 'acre': sqft = val * 43560; break;
      case 'hectare': sqft = val * 107639; break;
    }

    // Update all other fields automatically
    _updateField('sqft', sqft, sourceKey);
    _updateField('sqgaj', sqft / 9, sourceKey);
    _updateField('bigha', sqft / 27225, sourceKey);
    _updateField('kattha', sqft / 1361.25, sourceKey);
    _updateField('dhur', sqft / 68.0625, sourceKey);
    _updateField('acre', sqft / 43560, sourceKey);
    _updateField('hectare', sqft / 107639, sourceKey);
  }

  void _updateField(String key, double value, String sourceKey) {
    if (key != sourceKey) {
      _controllers[key]!.text = value.toStringAsFixed(2);
    }
  }

  void _clearAll({String? exceptKey}) {
    _controllers.forEach((key, controller) {
      if (key != exceptKey) controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ज़मीन नाप कैलकुलेटर', style: TextStyle(color: Color(0xFFFFD700))),
        backgroundColor: const Color(0xFF1E1E24),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'किसी भी एक बॉक्स में संख्या दर्ज करें:',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 15),

            // Input Fields
            _buildInputField('वर्ग फुट (Sq. Ft)', 'sqft', Icons.square_foot),
            _buildInputField('वर्ग गज (Gaj)', 'sqgaj', Icons.straighten),
            _buildInputField('बीघा (Bigha)', 'bigha', Icons.landscape),
            _buildInputField('कट्ठा (Kattha)', 'kattha', Icons.grid_view),
            _buildInputField('धूर (Dhur)', 'dhur', Icons.grain),
            _buildInputField('एकड़ (Acre)', 'acre', Icons.crop_free),
            _buildInputField('हेक्टेयर (Hectare)', 'hectare', Icons.map),

            const SizedBox(height: 25),

            // Excel Style Summary Sheet Header
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D38),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.table_chart, color: Color(0xFFFFD700)),
                  SizedBox(width: 10),
                  Text(
                    'एक्सेल रिपोर्ट प्रिव्यू (Excel Report Sheet)',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

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

  Widget _buildInputField(String label, String key, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: _controllers[key],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (val) => _calculateValues(key, val),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFFFE66D)),
          prefixIcon: Icon(icon, color: const Color(0xFFFFD700)),
          filled: true,
          fillColor: const Color(0xFF1E1E24),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFFFD700), width: 2),
          ),
        ),
      ),
    );
  }
}
