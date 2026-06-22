class LoanFormFields {
  const LoanFormFields({
    this.fullName = '',
    this.mobileNumber = '',
    this.monthlyIncome = '',
    this.existingEmi = '',
    this.requiredLoanAmount = '',
  });

  final String fullName;
  final String mobileNumber;
  final String monthlyIncome;
  final String existingEmi;
  final String requiredLoanAmount;

  LoanFormFields copyWith({
    String? fullName,
    String? mobileNumber,
    String? monthlyIncome,
    String? existingEmi,
    String? requiredLoanAmount,
  }) {
    return LoanFormFields(
      fullName: fullName ?? this.fullName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      existingEmi: existingEmi ?? this.existingEmi,
      requiredLoanAmount: requiredLoanAmount ?? this.requiredLoanAmount,
    );
  }

  LoanApplicationData toApplicationData() {
    return LoanApplicationData(
      fullName: fullName.trim(),
      mobileNumber: mobileNumber.trim(),
      monthlyIncome: double.parse(monthlyIncome.trim()),
      existingEmi: double.parse(existingEmi.trim()),
      requiredLoanAmount: double.parse(requiredLoanAmount.trim()),
    );
  }
}

class LoanApplicationData {
  const LoanApplicationData({
    required this.fullName,
    required this.mobileNumber,
    required this.monthlyIncome,
    required this.existingEmi,
    required this.requiredLoanAmount,
  });

  final String fullName;
  final String mobileNumber;
  final double monthlyIncome;
  final double existingEmi;
  final double requiredLoanAmount;

  double get disposableIncome => monthlyIncome - existingEmi;
}

class EligibilityResult {
  const EligibilityResult({
    required this.isEligible,
    required this.disposableIncome,
    required this.maxEligibleLoan,
    required this.message,
  });

  final bool isEligible;
  final double disposableIncome;
  final double maxEligibleLoan;
  final String message;
}
