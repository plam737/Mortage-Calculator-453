import 'package:flutter/material.dart';
import '../mortgage.dart';
import 'modify_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Mortgage _mortgage = Mortgage();
  bool _termsAccepted = false;

  // Opens the modify screen and waits for the result.
  Future<void> _openModifyScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ModifyScreen(mortgage: _mortgage),
      ),
    );

    if (result != null && result is Mortgage) {
      setState(() {
        _mortgage = result;
      });
    }
  }

  // Shows the confirmation AlertDialog when the checkbox is tapped.
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
                  // User declines: keep the box unchecked.
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

  // Helper to build a single label/value row, matching the mockup layout.
  Widget _buildRow(String label, String value, {bool divider = true}) {
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
        if (divider) const Divider(height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MortgageV0')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow('Amount', _mortgage.getFormattedAmount()),
            _buildRow('Years', _mortgage.getYears().toString()),
            _buildRow(
              'Interest Rate',
              '${(_mortgage.getRate() * 100).toStringAsFixed(2)}%',
            ),
            const SizedBox(height: 8),
            _buildRow('Monthly Payment', _mortgage.formattedMonthlyPayment()),
            _buildRow(
              'Total Payment',
              _mortgage.formattedTotalPayment(),
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