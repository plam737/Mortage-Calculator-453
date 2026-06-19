import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mortgage_provider.dart';

class ModifyScreen extends StatefulWidget {
  const ModifyScreen({super.key});

  @override
  State<ModifyScreen> createState() => _ModifyScreenState();
}

class _ModifyScreenState extends State<ModifyScreen> {
  late int _selectedYears;
  late TextEditingController _amountController;
  late double _selectedRate;


  late final List<double> _rateOptions = List.generate(
    53,
    (index) => (2.0 + index * 0.25) / 100,
  );

  @override
  void initState() {
    super.initState();
    final mortgage = context.read<MortgageProvider>().mortgage;
    _selectedYears = mortgage.getYears();
    _amountController = TextEditingController(
      text: mortgage.getAmount().toStringAsFixed(2),
    );
    _selectedRate = mortgage.getRate();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onDonePressed() {
    final provider = context.read<MortgageProvider>();
    final parsedAmount =
        double.tryParse(_amountController.text) ?? provider.mortgage.getAmount();

    provider.updateMortgage(
      years: _selectedYears,
      amount: parsedAmount,
      rate: _selectedRate,
    );

    Navigator.pop(context);
  }

  Widget _buildYearsRadios() {
    const yearOptions = [10, 15, 30];
    return RadioGroup<int>(
      groupValue: _selectedYears,
      onChanged: (value) => setState(() => _selectedYears = value!),
      child: Row(
        children: yearOptions.map((y) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Radio<int>(value: y),
              Text(y.toString()),
              const SizedBox(width: 8),
            ],
          );
        }).toList(),
      ),
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
            Row(
              children: [
                const SizedBox(
                  width: 90,
                  child: Text('Years', style: TextStyle(fontSize: 16)),
                ),
                Expanded(child: _buildYearsRadios()),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 90,
                  child: Text('Amount', style: TextStyle(fontSize: 16)),
                ),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(isDense: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Interest Rate', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            SizedBox(
              height: 220,
              child: ListView.builder(
                itemCount: _rateOptions.length,
                itemBuilder: (context, index) {
                  final rate = _rateOptions[index];
                  final isSelected = rate == _selectedRate;
                  return ListTile(
                    dense: true,
                    title: Text('${(rate * 100).toStringAsFixed(2)}%'),
                    selected: isSelected,
                    trailing: isSelected ? const Icon(Icons.check) : null,
                    onTap: () => setState(() => _selectedRate = rate),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _onDonePressed,
                child: const Text('DONE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}