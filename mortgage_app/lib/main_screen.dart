import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mortgage_provider.dart';
import 'modify_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _termsAccepted = false;

  void _openModifyScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ModifyScreen()),
    );
  }

  void _onTermsCheckboxChanged(bool? value) {
    if (value == true) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Terms and Conditions'),
            content: const Text(
              'By checking this box, you confirm that you have read and '
              'agree to the terms and conditions of this mortgage '
              'calculation. Do you accept?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() => _termsAccepted = false);
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  setState(() => _termsAccepted = true);
                  Navigator.pop(context);
                },
                child: const Text('ACCEPT'),
              ),
            ],
          );
        },
      );
    } else {
      setState(() => _termsAccepted = false);
    }
  }

  Widget _buildRow(
    String label,
    String value, {
    bool divider = true,
    Color dividerColor = const Color(0xFFBDBDBD),
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 16)),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        if (divider)
          Divider(height: 1, thickness: 2, color: dividerColor),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mortgage = context.watch<MortgageProvider>().mortgage;

    return Scaffold(
      appBar: AppBar(title: const Text('MortgageV0')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Amount', mortgage.getFormattedAmount(), divider: false),
            _buildRow('Years', mortgage.getYears().toString(), divider: false),
            _buildRow(
              'Interest Rate',
              '${(mortgage.getRate() * 100).toStringAsFixed(2)}%',
              dividerColor: Colors.red,
            ),
            _buildRow(
              'Monthly Payment',
              mortgage.formattedMonthlyPayment(),
              divider: false,
            ),
            _buildRow(
              'Total Payment',
              mortgage.formattedTotalPayment(),
              divider: false,
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Terms and Conditions'),
              value: _termsAccepted,
              onChanged: _onTermsCheckboxChanged,
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _openModifyScreen,
                child: const Text('MODIFY DATA'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}