import 'dart:math';

class Mortgage {
  double _amount = 0;
  int _years = 0;
  double _rate = 0;

  Mortgage() {
    setAmount(100000.0);
    setYears(30);
    setRate(0.035);
  }

  void setAmount(double newAmount) {
    if (newAmount >= 0) _amount = newAmount;
  }

  void setYears(int newYears) {
    if (newYears >= 0) _years = newYears;
  }

  void setRate(double newRate) {
    if (newRate >= 0) _rate = newRate;
  }

  double getAmount() => _amount;

  String getFormattedAmount() => _formatCurrency(_amount);

  int getYears() => _years;

  double getRate() => _rate;

  double monthlyPayment() {
    final double mRate = _rate / 12; 
    final double temp = pow(1 / (1 + mRate), _years * 12).toDouble();
    return _amount * mRate / (1 - temp);
  }

  String formattedMonthlyPayment() => _formatCurrency(monthlyPayment());

  double totalPayment() => monthlyPayment() * _years * 12;

  String formattedTotalPayment() => _formatCurrency(totalPayment());

  String _formatCurrency(double value) {
    final bool isNegative = value < 0;
    final String fixed = value.abs().toStringAsFixed(2);
    final List<String> parts = fixed.split('.');
    final String wholePart = parts[0];
    final String decimalPart = parts[1];

    final StringBuffer reversedWithCommas = StringBuffer();
    int digitCount = 0;
    for (int i = wholePart.length - 1; i >= 0; i--) {
      reversedWithCommas.write(wholePart[i]);
      digitCount++;
      if (digitCount % 3 == 0 && i != 0) {
        reversedWithCommas.write(',');
      }
    }
    final String formattedWhole =
        reversedWithCommas.toString().split('').reversed.join();

    return '${isNegative ? '-' : ''}\$$formattedWhole.$decimalPart';
  }
}