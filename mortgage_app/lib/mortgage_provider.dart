import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mortgage.dart';


class MortgageProvider extends ChangeNotifier {
  static const _yearsKey = 'mortgage_years';
  static const _amountKey = 'mortgage_amount';
  static const _rateKey = 'mortgage_rate';

  final Mortgage _mortgage = Mortgage();
  bool _isLoaded = false;

  Mortgage get mortgage => _mortgage;
  bool get isLoaded => _isLoaded;

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final savedYears = prefs.getInt(_yearsKey);
    final savedAmount = prefs.getDouble(_amountKey);
    final savedRate = prefs.getDouble(_rateKey);

    if (savedYears != null) _mortgage.setYears(savedYears);
    if (savedAmount != null) _mortgage.setAmount(savedAmount);
    if (savedRate != null) _mortgage.setRate(savedRate);

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> updateMortgage({
    required int years,
    required double amount,
    required double rate,
  }) async {
    _mortgage.setYears(years);
    _mortgage.setAmount(amount);
    _mortgage.setRate(rate);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_yearsKey, years);
    await prefs.setDouble(_amountKey, amount);
    await prefs.setDouble(_rateKey, rate);
  }
}