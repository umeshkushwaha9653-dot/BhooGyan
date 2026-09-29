import 'package:flutter/material.dart';

class ConstructionCalculator extends StatefulWidget {
  const ConstructionCalculator({Key? key}) : super(key: key);

  @override
  State<ConstructionCalculator> createState() => _ConstructionCalculatorState();
}

class _ConstructionCalculatorState extends State<ConstructionCalculator> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ------------ 1. Brickwork Controllers ------------
  final _wallLengthController = TextEditingController();
  final _wallHeightController = TextEditingController();
  final _doorCountController = TextEditingController(text: '0');
  final _windowCountController = TextEditingController(text: '0');

  final _brickRateController = TextEditingController(text: '8'); // Rs/brick
  final _cementRateController = TextEditingController(text: '380'); // Rs/bag
  final _sandRateController = TextEditingController(text: '50'); // Rs/cft

  String _wallThickness = '9'; // '9' or '4'
  String _mortarRatio = '1:4'; // '1:4', '1:6'

  // ------------ 2. Concrete Controllers ------------
  final _slabLengthController = TextEditingController();
  final _slabWidthController = TextEditingController();
  final _slabThicknessController = TextEditingController(text: '5'); // in inches

  final _aggregateRateController = TextEditingController(text: '60'); // Rs/cft
  final _steelRateController = TextEditingController(text: '65'); // Rs/kg
  String _concreteGrade = 'M20 (1:1.5:3)';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('निर्माण कैलकुलेटर (Construction Calc)'),
        backgroundColor: Colors.grey[900],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          tabs: const [
            Tab(icon: Icon(Icons.maps_home_work), text: 'दीवार (Brick)'),
            Tab(icon: Icon(Icons.foundation), text: 'कंक्रीट/छत'),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF121212),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBrickworkCalc(),
          _buildConcreteCalc(),
        ],
      ),
    );
  }

  // ==========================================
  // 1. Brickwork Calculator Widget
  // ==========================================
  Widget _buildBrickworkCalc() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('दीवार का आकार चुनिए:'),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('9 इंच (9")', style: TextStyle(color: Colors.white)),
                  value: '9',
                  groupValue: _wallThickness,
                  onChanged: (val) => setState(() => _wallThickness = val!),
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: const Text('4.5 इंच (4")', style: TextStyle(color: Colors.white)),
                  value: '4',
                  groupValue: _wallThickness,
                  onChanged: (val) => setState(() => _wallThickness = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _sectionTitle('मसाले का अनुपात (Cement : Sand):'),
          DropdownButtonFormField<String>(
            value: _mortarRatio,
            dropdownColor: Colors.grey[850],
            style: const TextStyle(color: Colors.white),
            items: ['1:3', '1:4 (मजबूत)', '1:5', '1:6 (सामान्य)']
                .map((e) => DropdownMenuItem(value: e.split(' ')[0], child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => _mortarRatio = val!),
            decoration: _inputDecoration('अनुपात चुनें'),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildTextField(_wallLengthController, 'लंबाई (फुट में)')),
              const SizedBox(width: 10),
              Expanded(child: _buildTextField(_wallHeightController, 'ऊंचाई (फुट में)')),
            ],
          ),
          const SizedBox(height: 15),
          _sectionTitle('दरवाजे और खिड़कियाँ (Deduction):'),
          Row(
            children: [
              Expanded(child: _buildTextField(_doorCountController, 'दरवाजे (7x3 ft)', isNumber: true)),
              const SizedBox(width: 10),
              Expanded(child: _buildTextField(_windowCountController, 'खिड़कियां (4x4 ft)', isNumber: true)),
            ],
          ),
          const SizedBox(height: 15),
          _sectionTitle('अनुमानित दर (Cost Estimator):'),
          Row(
            children: [
              Expanded(child: _buildTextField(_brickRateController, 'ईंट दर (₹/pcs)', isNumber: true)),
              const SizedBox(width: 5),
              Expanded(child: _buildTextField(_cementRateController, 'सीमेंट (₹/बोरी)', isNumber: true)),
              const SizedBox(width: 5),
              Expanded(child: _buildTextField(_sandRateController, 'बालू (₹/CFT)', isNumber: true)),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: _calculateBrickwork,
            child: const Text('गणना करें (Calculate)', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _calculateBrickwork() {
    double length = double.tryParse(_wallLengthController.text) ?? 0;
    double height = double.tryParse(_wallHeightController.text) ?? 0;
    int doors = int.tryParse(_doorCountController.text) ?? 0;
    int windows = int.tryParse(_windowCountController.text) ?? 0;

    if (length <= 0 || height <= 0) {
      _showResultDialog('कृपया सही लंबाई और ऊंचाई दर्ज करें।');
      return;
    }

    double totalArea = length * height;
    double doorArea = doors * 21.0; // 7x3 ft
    double windowArea = windows * 16.0; // 4x4 ft
    double netArea = totalArea - (doorArea + windowArea);

    if (netArea <= 0) {
      _showResultDialog('दरवाजे/खिड़की का क्षेत्रफल दीवार से अधिक है!');
      return;
    }

    double thicknessFt = _wallThickness == '9' ? 0.75 : 0.375;
    double volumeCft = netArea * thicknessFt;

    int totalBricks = (volumeCft * 13.5 * 1.05).ceil(); // 5% wastage

    double cementBags = 0;
    double sandCft = 0;

    if (_wallThickness == '9') {
      cementBags = volumeCft * 0.025;
      sandCft = volumeCft * 0.25;
    } else {
      cementBags = volumeCft * 0.03;
      sandCft = volumeCft * 0.28;
    }

    double brickPrice = double.tryParse(_brickRateController.text) ?? 0;
    double cementPrice = double.tryParse(_cementRateController.text) ?? 0;
    double sandPrice = double.tryParse(_sandRateController.text) ?? 0;

    double totalCost = (totalBricks * brickPrice) + (cementBags * cementPrice) + (sandCft * sandPrice);

    _showResultDialog('''
📊 **ईंट चिनाई का परिणाम (Brickwork Summary)**

• शुद्ध क्षेत्रफल: ${netArea.toStringAsFixed(1)} वर्ग फुट
• कुल ईंटें (5% वेस्टेज सहित): $totalBricks नग
• सीमेंट: ${cementBags.toStringAsFixed(1)} बोरी
• बालू/रेत: ${sandCft.toStringAsFixed(1)} CFT

💰 **अनुमानित कुल लागत:** ₹${totalCost.toStringAsFixed(0)}
''');
  }

  // ==========================================
  // 2. Concrete (Slab/Beam) Calculator
  // ==========================================
  Widget _buildConcreteCalc() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('कंक्रीट ग्रेड चुनें:'),
          DropdownButtonFormField<String>(
            value: _concreteGrade,
            dropdownColor: Colors.grey[850],
            style: const TextStyle(color: Colors.white),
            items: ['M15 (1:2:4)', 'M20 (1:1.5:3)', 'M25 (1:1:2)']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) => setState(() => _concreteGrade = val!),
            decoration: _inputDecoration('ग्रेड चुनें'),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildTextField(_slabLengthController, 'लंबाई (फुट)')),
              const SizedBox(width: 10),
              Expanded(child: _buildTextField(_slabWidthController, 'चौड़ाई (फुट)')),
            ],
          ),
          const SizedBox(height: 15),
          _buildTextField(_slabThicknessController, 'मोटाई/ढलाई (इंच में)', isNumber: true),
          const SizedBox(height: 15),
          _sectionTitle('सामग्री दरें (Cost Estimator):'),
          Row(
            children: [
              Expanded(child: _buildTextField(_cementRateController, 'सीमेंट (₹/बोरी)', isNumber: true)),
              const SizedBox(width: 5),
              Expanded(child: _buildTextField(_sandRateController, 'रेत (₹/CFT)', isNumber: true)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildTextField(_aggregateRateController, 'गिट्टी (₹/CFT)', isNumber: true)),
              const SizedBox(width: 5),
              Expanded(child: _buildTextField(_steelRateController, 'सरिया (₹/Kg)', isNumber: true)),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: _calculateConcrete,
            child: const Text('गणना करें (Calculate)', style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _calculateConcrete() {
    double length = double.tryParse(_slabLengthController.text) ?? 0;
    double width = double.tryParse(_slabWidthController.text) ?? 0;
    double thicknessInch = double.tryParse(_slabThicknessController.text) ?? 0;

    if (length <= 0 || width <= 0 || thicknessInch <= 0) {
      _showResultDialog('कृपया सही माप भरें।');
      return;
    }

    double volumeCft = length * width * (thicknessInch / 12.0);
    double volumeCum = volumeCft / 35.3147;

    double cementBags = volumeCum * 8.0;
    double sandCft = volumeCft * 0.45;
    double aggregateCft = volumeCft * 0.9;
    double steelKg = volumeCft * 2.5;

    double cementPrice = double.tryParse(_cementRateController.text) ?? 0;
    double sandPrice = double.tryParse(_sandRateController.text) ?? 0;
    double aggPrice = double.tryParse(_aggregateRateController.text) ?? 0;
    double steelPrice = double.tryParse(_steelRateController.text) ?? 0;

    double totalCost = (cementBags * cementPrice) + (sandCft * sandPrice) + (aggregateCft * aggPrice) + (steelKg * steelPrice);

    _showResultDialog('''
🏗️ **कंक्रीट/छत ढलाई का परिणाम**

• आयतन (Volume): ${volumeCft.toStringAsFixed(1)} CFT
• सीमेंट: ${cementBags.toStringAsFixed(1)} बोरी
• बालू/रेत: ${sandCft.toStringAsFixed(1)} CFT
• गिट्टी (Aggregate): ${aggregateCft.toStringAsFixed(1)} CFT
• सरिया (Steel approx): ${steelKg.toStringAsFixed(0)} Kg

💰 **अनुमानित कुल लागत:** ₹${totalCost.toStringAsFixed(0)}
''');
  }

  // ==========================================
  // Common UI Helpers
  // ==========================================
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.amber),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = true}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.amber),
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  void _showResultDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('गणना विवरण', style: TextStyle(color: Colors.amber)),
        content: Text(message, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('ठीक है', style: TextStyle(color: Colors.amber)),
          )
        ],
      ),
    );
  }
}
