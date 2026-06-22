import 'package:flutter_test/flutter_test.dart';
import 'package:loan_application_form/models/loan_application_data.dart';
import 'package:loan_application_form/services/eligibility_service.dart';

void main() {
  group('EligibilityService', () {
    test('returns not eligible when EMIs exceed income', () {
      const data = LoanApplicationData(
        fullName: 'John Doe',
        mobileNumber: '9876543210',
        monthlyIncome: 50000,
        existingEmi: 55000,
        requiredLoanAmount: 100000,
      );

      final result = EligibilityService.check(data);

      expect(result.isEligible, isFalse);
    });

    test('returns eligible when loan is within limit', () {
      const data = LoanApplicationData(
        fullName: 'John Doe',
        mobileNumber: '9876543210',
        monthlyIncome: 80000,
        existingEmi: 10000,
        requiredLoanAmount: 500000,
      );

      final result = EligibilityService.check(data);

      expect(result.isEligible, isTrue);
      expect(result.disposableIncome, 70000);
    });
  });
}
