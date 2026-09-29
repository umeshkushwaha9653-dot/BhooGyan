import 'package:flutter/material.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  String _category = 'Length'; // 'Length', 'Area', 'Weight'
  final TextEditingController _inputController = TextEditingController();

  String _fromUnit = 'Meter';
  String _toUnit = 'Feet';
  double _result = 0.0;

  final Map<String, List<String>> _units = {
    'Length': ['Meter', 'Feet', 'Inch', 'Yard (Gaj)', 'Kilometer', 'Mile'],
    'Area': ['Sq. Feet', 'Sq. Meter', 'Sq. Gaj', 'Acre', 'Hectare'],
    'Weight': ['Kilogram', 'Gram', 'Quintal', 'Ton'],
  };

  void _convert() {
    if (_inputController.text.isEmpty) {
      setState(() => _result = 0.0);
      return;
    }

    double input = double.tryParse(_inputController.text) ?? 0.0;
    if (input <= 0) return;

    double baseValue = 0.0;

    // Convert input to base unit
    if (_category == 'Length') {
      switch (_fromUnit) {
        case 'Meter': baseValue = input; break;
        case 'Feet': baseValue = input * 0.3048; break;
        case 'Inch': baseValue = input * 0.0254; break;
        case 'Yard (Gaj)': baseValue = input * 0.9144; break;
        case 'Kilometer': baseValue = input * 1000; break;
        case 'Mile': baseValue = input * 1609.34; break;
      }

      // Convert base unit to target unit
      switch (_toUnit) {
        case 'Meter': _result = baseValue; break;
        case 'Feet': _result = baseValue / 0.3048; break;
        case 'Inch': _result = baseValue / 0.0254; break;
        case 'Yard (Gaj)': _result = baseValue / 0.9144; break;
        case 'Kilometer': _result = baseValue / 1000; break;
        case 'Mile': _result = baseValue / 1609.34; break;
      }
    } else if (_category == 'Area') {
      switch (_fromUnit) {
        case 'Sq. Meter': baseValue = input; break;
        case 'Sq. Feet': baseValue = input * 0.092903; break;
        case 'Sq. Gaj': baseValue = input * 0.836127; break;
        case 'Acre': baseValue = input * 4046.86; break;
        case 'Hectare': baseValue = input * 10000; break;
      }

      switch (_toUnit) {
        case 'Sq. Meter': _result = baseValue; break;
        case 'Sq. Feet': _result = baseValue / 0.092903; break;
        case 'Sq. Gaj': _result = baseValue / 0.836127; break;
        case 'Acre': _result = baseValue / 4046.86; break;
        case 'Hectare': _result = baseValue / 10000; break;
      }
    } else if (_category == 'Weight') {
      switch (_fromUnit) {
        case 'Kilogram': baseValue = input; break;
        case 'Gram': baseValue = input / 1000; break;
        case 'Quintal': baseValue = input * 100; break;
        case 'Ton': baseValue = input * 1000; break;
      }

      switch (_toUnit) {
        case 'Kilogram': _result = baseValue; break;
        case 'Gram': _result = baseValue * 1000; break;
        case 'Quintal': _result = baseValue / 100; break;
        case 'Ton': _result = baseValue / 1000; break;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('इकाई कनवर्टर (Unit Converter)', style: TextStyle(color: Color(0xFFFFD700))),
        backgroundColor: const Color(0xFF1E1E24),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Selection
            const Text('कैटगरी चुनें:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildCategoryChip('Length', 'लंबाई'),
                const SizedBox(width: 8),
                _buildCategoryChip('Area', 'क्षेत्रफल'),
                const SizedBox(width: 8),
                _buildCategoryChip('Weight', 'वजन'),
              ],
            ),
            const SizedBox(height: 20),

            // From Unit
            DropdownButtonFormField<String>(
              value: _fromUnit,
              dropdownColor: const Color(0xFF2D2D38),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'इससे बदले (From)', labelStyle: TextStyle(color: Color(0xFFFFE66D))),
              items: _units[_category]!.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
              onChanged: (val) {
                setState(() => _fromUnit = val!);
                _convert();
              },
            ),
            const SizedBox(height: 15),

            // Input Field
            TextField(
              controller: _inputController,
              keyboardType: TextInputType.number,
              onChanged: (val) => _convert(),
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                labelText: 'मात्रा दर्ज करें (Value)',
                labelStyle: const TextStyle(color: Color(0xFFFFE66D)),
                filled: true,
                fillColor: const Color(0xFF1E1E24),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),

            // To Unit
            DropdownButtonFormField<String>(
              value: _toUnit,
              dropdownColor: const Color(0xFF2D2D38),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'इसमें बदले (To)', labelStyle: TextStyle(color: Color(0xFFFFE66D))),
              items: _units[_category]!.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
              onChanged: (val) {
                setState(() => _toUnit = val!);
                _convert();
              },
            ),
            const SizedBox(height: 25),

            // Result Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D38),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFD700)),
              ),
              child: Column(
                children: [
                  const Text('परिवर्तित परिणाम (Result)', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 5),
                  Text(
                    '${_result.toStringAsFixed(3)} $_toUnit',
                    style: const TextStyle(color: Color(0xFFFFD700), fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Share Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF28A745), padding: const EdgeInsets.vertical(14)),
                    onPressed: () {},
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                    label: const Text('डाउनलोड PDF', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF075E54), padding: const EdgeInsets.vertical(14)),
                    onPressed: () {},
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

  Widget _buildCategoryChip(String key, String label) {
    bool isSelected = _category == key;
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white)),
      selected: isSelected,
      selectedColor: const Color(0xFFFFD700),
      backgroundColor: const Color(0xFF2D2D38),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _category = key;
            _fromUnit = _units[key]![0];
            _toUnit = _units[key]![1];
            _convert();
          });
        }
      },
    );
  }
}
