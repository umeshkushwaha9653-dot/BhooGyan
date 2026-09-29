import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class ConstructionCalculator extends StatefulWidget {
  const ConstructionCalculator({Key? key}) : super(key: key);

  @override
  State<ConstructionCalculator> createState() => _ConstructionCalculatorState();
}

class _ConstructionCalculatorState extends State<ConstructionCalculator> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // 1. Brickwork Controllers
  final _wallLengthController = TextEditingController();
  final _wallHeightController = TextEditingController();
  
  // Custom Door & Window Dimensions
  final _doorCountController = TextEditingController(text: '0');
  final _doorHeightController = TextEditingController(text: '7');
  final _doorWidthController = TextEditingController(text: '3');

  final _windowCountController = TextEditingController(text: '0');
  final _windowHeightController = TextEditingController(text: '4');
  final _windowWidthController = TextEditingController(text: '4');

  final _brickRateController = TextEditingController(text: '8');
  final _cementRateController = TextEditingController(text: '380');
  final _sandRateController = TextEditingController(text: '50');

  String _wallThickness = '9';
  String _mortarRatio = '1:4';

  // 2. Concrete Controllers
  final _slabLengthController = TextEditingController();
  final _slabWidthController = TextEditingController();
  final _slabThicknessController = TextEditingController(text: '5');

  final _aggregateRateController = TextEditingController(text: '60');
  final _steelRateController = TextEditingController(text: '65');
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
      backgroundColor: const Color(0xFF181818),
      appBar: AppBar(
        title: const Text('निर्माण कैलकुलेटर', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF242424),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          tabs: const [
            Tab(icon: Icon(Icons.foundation), text: 'दीवार (Brickwork)'),
            Tab(icon: Icon(Icons.dashboard_customize), text: 'कंक्रीट / छत'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildFullTabWrapper(_buildBrickworkForm(), Colors.green[700]!, 'दीवार सामग्री गणना करें', _calculateBrickwork),
            _buildFullTabWrapper(_buildConcreteForm(), Colors.blue[700]!, 'कंक्रीट सामग्री गणना करें', _calculateConcrete),
          ],
        ),
      ),
    );
  }

  Widget _buildFullTabWrapper(Widget content, Color btnColor, String btnText, VoidCallback onPressed) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: content,
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Color(0xFF242424),
            boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 8)],
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: onPressed,
            child: Text(btnText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Card(
      color: const Color(0xFF242424),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.amber)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildBrickworkForm() {
    return Column(
      children: [
        _buildCard(
          title: '1. दीवार एवं मसाले का विवरण',
          children: [
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('9" दीवार', style: TextStyle(color: Colors.white, fontSize: 14)),
                    value: '9',
                    groupValue: _wallThickness,
                    onChanged: (val) => setState(() => _wallThickness = val!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('4.5" दीवार', style: TextStyle(color: Colors.white, fontSize: 14)),
                    value: '4',
                    groupValue: _wallThickness,
                    onChanged: (val) => setState(() => _wallThickness = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _mortarRatio,
              dropdownColor: const Color(0xFF333333),
              style: const TextStyle(color: Colors.white),
              items: ['1:3', '1:4', '1:5', '1:6'].map((e) => DropdownMenuItem(value: e, child: Text('मसाला अनुपात: $e'))).toList(),
              onChanged: (val) => setState(() => _mortarRatio = val!),
              decoration: _inputDecoration('अनुपात'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField(_wallLengthController, 'दीवार लंबाई (फुट)')),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField(_wallHeightController, 'दीवार ऊंचाई (फुट)')),
              ],
            ),
          ],
        ),
        _buildCard(
          title: '2. दरवाजे का साइज़ एवं संख्या',
          children: [
            Row(
              children: [
                Expanded(child: _buildTextField(_doorCountController, 'संख्या')),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField(_doorHeightController, 'ऊंचाई (ft)')),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField(_doorWidthController, 'चौड़ाई (ft)')),
              ],
            ),
          ],
        ),
        _buildCard(
          title: '3. खिड़की का साइज़ एवं संख्या',
          children: [
            Row(
              children: [
                Expanded(child: _buildTextField(_windowCountController, 'संख्या')),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField(_windowHeightController, 'ऊंचाई (ft)')),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField(_windowWidthController, 'चौड़ाई (ft)')),
              ],
            ),
          ],
        ),
        _buildCard(
          title: '4. सामग्री दरें (Cost Estimator)',
          children: [
            Row(
              children: [
                Expanded(child: _buildTextField(_brickRateController, 'ईंट (₹/नग)')),
                const SizedBox(width: 6),
                Expanded(child: _buildTextField(_cementRateController, 'सीमेंट (₹/बोरी)')),
                const SizedBox(width: 6),
                Expanded(child: _buildTextField(_sandRateController, 'बालू (₹/CFT)')),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConcreteForm() {
    return Column(
      children: [
        _buildCard(
          title: '1. कंक्रीट ग्रेड एवं माप',
          children: [
            DropdownButtonFormField<String>(
              value: _concreteGrade,
              dropdownColor: const Color(0xFF333333),
              style: const TextStyle(color: Colors.white),
              items: ['M15 (1:2:4)', 'M20 (1:1.5:3)', 'M25 (1:1:2)']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => _concreteGrade = val!),
              decoration: _inputDecoration('कंक्रीट ग्रेड'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField(_slabLengthController, 'लंबाई (फुट)')),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField(_slabWidthController, 'चौड़ाई (फुट)')),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(_slabThicknessController, 'ढलाई/मोटाई (इंच में)'),
          ],
        ),
        _buildCard(
          title: '2. सामग्री दरें (Cost Estimator)',
          children: [
            Row(
              children: [
                Expanded(child: _buildTextField(_cementRateController, 'सीमेंट (₹/बोरी)')),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField(_sandRateController, 'रेत (₹/CFT)')),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildTextField(_aggregateRateController, 'गिट्टी (₹/CFT)')),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField(_steelRateController, 'सरिया (₹/Kg)')),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _calculateBrickwork() {
    double l = double.tryParse(_wallLengthController.text) ?? 0;
    double h = double.tryParse(_wallHeightController.text) ?? 0;

    if (l <= 0 || h <= 0) {
      _showAlert('कृपया सही दीवार का माप दर्ज करें।');
      return;
    }

    int dCount = int.tryParse(_doorCountController.text) ?? 0;
    double dH = double.tryParse(_doorHeightController.text) ?? 0;
    double dW = double.tryParse(_doorWidthController.text) ?? 0;

    int wCount = int.tryParse(_windowCountController.text) ?? 0;
    double wH = double.tryParse(_windowHeightController.text) ?? 0;
    double wW = double.tryParse(_windowWidthController.text) ?? 0;

    double netArea = (l * h) - ((dCount * dH * dW) + (wCount * wH * wW));
    if (netArea <= 0) {
      _showAlert('दरवाजे/खिड़की का क्षेत्र दीवार से अधिक है!');
      return;
    }

    double volumeCft = netArea * (_wallThickness == '9' ? 0.75 : 0.375);
    int bricks = (volumeCft * 13.5 * 1.05).ceil();
    double cement = volumeCft * (_wallThickness == '9' ? 0.025 : 0.03);
    double sand = volumeCft * (_wallThickness == '9' ? 0.25 : 0.28);

    double bp = double.tryParse(_brickRateController.text) ?? 0;
    double cp = double.tryParse(_cementRateController.text) ?? 0;
    double sp = double.tryParse(_sandRateController.text) ?? 0;

    double cost = (bricks * bp) + (cement * cp) + (sand * sp);

    String summary = '''🧱 ईंट चिनाई रिपोर्ट (Brickwork)
• शुद्ध क्षेत्रफल: ${netArea.toStringAsFixed(1)} sq ft
• कुल ईंटें: $bricks नग
• सीमेंट: ${cement.toStringAsFixed(1)} बोरी
• बालू/रेत: ${sand.toStringAsFixed(1)} CFT
💰 कुल अनुमानित लागत: ₹${cost.toStringAsFixed(0)}''';

    _showResultModal('ईंट चिनाई परिणाम', summary);
  }

  void _calculateConcrete() {
    double l = double.tryParse(_slabLengthController.text) ?? 0;
    double w = double.tryParse(_slabWidthController.text) ?? 0;
    double t = double.tryParse(_slabThicknessController.text) ?? 0;

    if (l <= 0 || w <= 0 || t <= 0) {
      _showAlert('कृपया सही कंक्रीट माप दर्ज करें।');
      return;
    }

    double volCft = l * w * (t / 12.0);
    double volCum = volCft / 35.3147;

    double cement = volCum * 8.0;
    double sand = volCft * 0.45;
    double agg = volCft * 0.9;
    double steel = volCft * 2.5;

    double cp = double.tryParse(_cementRateController.text) ?? 0;
    double sp = double.tryParse(_sandRateController.text) ?? 0;
    double ap = double.tryParse(_aggregateRateController.text) ?? 0;
    double stp = double.tryParse(_steelRateController.text) ?? 0;

    double cost = (cement * cp) + (sand * sp) + (agg * ap) + (steel * stp);

    String summary = '''🏗️ कंक्रीट/छत ढलाई रिपोर्ट
• आयतन (Volume): ${volCft.toStringAsFixed(1)} CFT
• सीमेंट: ${cement.toStringAsFixed(1)} बोरी
• बालू/रेत: ${sand.toStringAsFixed(1)} CFT
• गिट्टी: ${agg.toStringAsFixed(1)} CFT
• सरिया (Steel): ${steel.toStringAsFixed(0)} Kg
💰 कुल अनुमानित लागत: ₹${cost.toStringAsFixed(0)}''';

    _showResultModal('कंक्रीट ढलाई परिणाम', summary);
  }

  void _showResultModal(String title, String summaryText) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF242424),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 15),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF181818), borderRadius: BorderRadius.circular(10)),
              child: Text(summaryText, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5)),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700], padding: const EdgeInsets.symmetric(vertical: 12)),
                    icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                    label: const Text('PDF डाउनलोड', style: TextStyle(color: Colors.white)),
                    onPressed: () => _generateAndDownloadPdf(title, summaryText),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), padding: const EdgeInsets.symmetric(vertical: 12)),
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text('व्हाट्सएप शेयर', style: TextStyle(color: Colors.white)),
                    onPressed: () => Share.share(summaryText),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> _generateAndDownloadPdf(String title, String text) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Container(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('BhooGyan - $title', style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text(text, style: const pw.TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
      filled: true,
      fillColor: const Color(0xFF181818),
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.amber), borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    );
  }

  void _showAlert(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));
  }
}
