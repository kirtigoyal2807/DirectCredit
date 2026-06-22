class LoanFormValidators {
  LoanFormValidators._();

  static const fullNameEmpty = 'Full name cannot be empty';
  static const mobileRequired = 'Mobile number is required';
  static const mobileInvalid = 'Mobile number must contain 10 digits';
  static const monthlyIncomeRequired = 'Monthly income is required';
  static const monthlyIncomeInvalid = 'Monthly income must be greater than 0';
  static const existingEmiRequired = 'Existing EMI is required';
  static const existingEmiNegative = 'Existing EMI cannot be negative';
  static const existingEmiExceedsIncome =
      'Existing EMI cannot exceed monthly income';
  static const loanAmountRequired = 'Required loan amount is required';
  static const loanAmountInvalid =
      'Required loan amount must be greater than 0';
  static const invalidNumber = 'Enter a valid amount';

  static String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return fullNameEmpty;
    }
    return null;
  }

  static String? mobileNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return mobileRequired;
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
      return mobileInvalid;
    }
    return null;
  }

  static String? monthlyIncome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return monthlyIncomeRequired;
    }
    final amount = _parseAmount(value);
    if (amount == null) {
      return invalidNumber;
    }
    if (amount <= 0) {
      return monthlyIncomeInvalid;
    }
    return null;
  }

  static String? existingEmi(String? value, {String? monthlyIncomeValue}) {
    if (value == null || value.trim().isEmpty) {
      return existingEmiRequired;
    }
    final amount = _parseAmount(value);
    if (amount == null) {
      return invalidNumber;
    }
    if (amount < 0) {
      return existingEmiNegative;
    }

    final income = _parseAmount(monthlyIncomeValue);
    if (income != null && income > 0 && amount > income) {
      return existingEmiExceedsIncome;
    }

    return null;
  }

  static String? requiredLoanAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return loanAmountRequired;
    }
    final amount = _parseAmount(value);
    if (amount == null) {
      return invalidNumber;
    }
    if (amount <= 0) {
      return loanAmountInvalid;
    }
    return null;
  }

  static double? _parseAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return double.tryParse(value.trim());
  }
}
