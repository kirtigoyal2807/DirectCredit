import '../models/loan_application_data.dart';

class EligibilityService {
  EligibilityService._();

  static const _foirMultiplier = 60;

  static EligibilityResult check(LoanApplicationData data) {

    final disposableIncome = data.disposableIncome;
    final maxEligibleLoan = disposableIncome * _foirMultiplier;

    if (disposableIncome <= 0) {
      return EligibilityResult(
        isEligible: false,
        disposableIncome: disposableIncome,
        maxEligibleLoan: maxEligibleLoan,
        message:
            'Your existing EMIs exceed or equal your monthly income. You are not eligible at this time.',
      );
    }

    if (data.requiredLoanAmount > maxEligibleLoan) {
      return EligibilityResult(
        isEligible: false,
        disposableIncome: disposableIncome,
        maxEligibleLoan: maxEligibleLoan,
        message:
            'Requested loan amount exceeds your eligible limit. Try a lower amount.',

      );
    }

    return EligibilityResult(
      isEligible: true,
      disposableIncome: disposableIncome,
      maxEligibleLoan: maxEligibleLoan,
      message:
          'Congratulations! You are eligible for the requested loan amount.',
    );
  }
}
