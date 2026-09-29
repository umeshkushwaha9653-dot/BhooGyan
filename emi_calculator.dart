import 'dart:math';
import 'package:flutter/material.dart';

class EmiCalculatorScreen extends StatefulWidget {
  const EmiCalculatorScreen({super.key});

  @override
  State<EmiCalculatorScreen> createState() => _EmiCalculatorScreenState();
}

class _EmiCalculatorScreenState extends State<EmiCalculatorScreen> {
  String _loanType = 'Home'; // 'Home', 'Personal', 'Vehicle'
  final TextEditingController _amountController = TextEditingController(text: '500000');
  final TextEditingController _rateController = TextEditingController(text: '8.5');
  final TextEditingController _tenureController = TextEditingController(text: '5');

  bool _isTenureInYears = true;

  double _monthlyEmi = 0.0;
  double _totalInterest = 0.0;
  double _totalPayment = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateEmi();
  }

  void _calculateEmi() {
    double p = double.tryParse(_amountController.text) ?? 0;
    double annualRate = double.tryParse(_rateController.text) ?? 0;
    double tenure = double.tryParse(_tenureController.text) ?? 0;

    if (p <= 0 || annualRate <= 0 || tenure <= 0) {
      setState(() {
        _monthlyEmi = 0;
        _totalInterest = 0;
        _totalPayment = 0;
      });
      return;
    }

    double r = (annualRate / 12) / 100; // Monthly Interest Rate
    double n = _isTenureInYears ? tenure * 12 : tenure; // Total Months

    // Formula: EMI = [P x R x (1+R)^N]/[(1+R)^N-1]
    double emi = (p * r * pow(1 + r, n)) / (pow(1 + r, n) - 1);
    double totalPay = emi * n;
    double totalInt = totalPay - p;

    setState(() {
      _monthlyEmi = emi;
      _totalInterest = totalInt;
      _totalPayment = totalPay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMI कैलकुलेटर', style: TextStyle(color: Color(0xFFFFD700))),
        backgroundColor: const Color(0xFF1E1E24),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Loan Type Selection
            const Text('लोन का प्रकार चुनें:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildLoanChip('Home', 'होम लोन'),
                const SizedBox(width: 8),
                _buildLoanChip('Personal', 'पर्सनल लोन'),
                const SizedBox(width: 8),
                _buildLoanChip('Vehicle', 'गाड़ी लोन'),
              ],
            ),
            const SizedBox(height: 20),

            // Loan Amount Input
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              onChanged: (val) => _calculateEmi(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'ऋण राशि (Loan Amount ₹)',
                labelStyle: const TextStyle(color: Color(0xFFFFE66D)),
                prefixIcon: const Icon(Icons.currency_rupee, color: Color(0xFFFFD700)),
                filled: true,
                fillColor: const Color(0xFF1E1E24),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),

            // Interest Rate Input
            TextField(
              controller: _rateController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (val) => _calculateEmi(),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'ब्याज दर (Interest Rate % प्रति वर्ष)',
                labelStyle: const TextStyle(color: Color(0xFFFFE66D)),
                prefixIcon: const Icon(Icons.percent, color: Color(0xFFFFD700)),
                filled: true,
                fillColor: const Color(0xFF1E1E24),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 15),

            // Tenure Input with Year/Month Toggle
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tenureController,
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _calculateEmi(),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: _isTenureInYears ? 'अवधि (वर्षों में)' : 'अवधि (महीनों में)',
                      labelStyle: const TextStyle(color: Color(0xFFFFE66D)),
                      prefixIcon: const Icon(Icons.access_time, color: Color(0xFFFFD700)),
                      filled: true,
                      fillColor: const Color(0xFF1E1E24),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ToggleButtons(
                  isSelected: [_isTenureInYears, !_isTenureInYears],
                  selectedColor: Colors.black,
                  color: Colors.white,
                  fillColor: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(10),
                  onPressed: (index) {
                    setState(() {
                      _isTenureInYears = index == 0;
                      _calculateEmi();
                    });
                  },
                  children: const [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('वर्ष')),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('माह')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 25),

            // EMI Result Summary Card
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF2D2D38),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFD700)),
              ),
              child: Column(
                children: [
                  const Text('प्रति माह किश्त (Monthly EMI)', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 5),
                  Text(
                    '₹ ${_monthlyEmi.toStringAsFixed(0)}',
                    style: const TextStyle(color: Color(0xFFFFD700), fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const Divider(color: Colors.grey, height: 25),
                  _buildResultRow('मूल ऋण राशि', '₹ ${_amountController.text}'),
                  const SizedBox(height: 8),
                  _buildResultRow('कुल ब्याज (Total Interest)', '₹ ${_totalInterest.toStringAsFixed(0)}'),
                  const SizedBox(height: 8),
                  _buildResultRow('कुल भुगतान (Total Amount)', '₹ ${_totalPayment.toStringAsFixed(0)}'),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // PDF and WhatsApp Share Buttons
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

  Widget _buildLoanChip(String type, String label) {
    bool isSelected = _loanType == type;
    return ChoiceChip(
      label: Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white)),
      selected: isSelected,
      selectedColor: const Color(0xFFFFD700),
      backgroundColor: const Color(0xFF2D2D38),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _loanType = type;
            if (type == 'Home') {
              _rateController.text = '8.5';
              _tenureController.text = '20';
              _isTenureInYears = true;
            } else if (type == 'Personal') {
              _rateController.text = '12.5';
              _tenureController.text = '3';
              _isTenureInYears = true;
            } else {
              _rateController.text = '9.5';
              _tenureController.text = '5';
              _isTenureInYears = true;
            }
            _calculateEmi();
          });
        }
      },
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
