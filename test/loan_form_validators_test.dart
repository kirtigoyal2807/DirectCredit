import 'package:flutter_test/flutter_test.dart';
import 'package:loan_application_form/validators/loan_form_validators.dart';

void main() {
  group('LoanFormValidators.fullName', () {
    test('rejects empty values', () {
      expect(LoanFormValidators.fullName(null), LoanFormValidators.fullNameEmpty);
      expect(LoanFormValidators.fullName(''), LoanFormValidators.fullNameEmpty);
      expect(
        LoanFormValidators.fullName('   '),
        LoanFormValidators.fullNameEmpty,
      );
    });

    test('accepts non-empty values', () {
      expect(LoanFormValidators.fullName('John Doe'), isNull);
    });
  });

  group('LoanFormValidators.mobileNumber', () {
    test('rejects empty values', () {
      expect(
        LoanFormValidators.mobileNumber(null),
        LoanFormValidators.mobileRequired,
      );
      expect(
        LoanFormValidators.mobileNumber(''),
        LoanFormValidators.mobileRequired,
      );
    });

    test('requires exactly 10 digits', () {
      expect(
        LoanFormValidators.mobileNumber('987654321'),
        LoanFormValidators.mobileInvalid,
      );
      expect(
        LoanFormValidators.mobileNumber('98765432101'),
        LoanFormValidators.mobileInvalid,
      );
      expect(LoanFormValidators.mobileNumber('9876543210'), isNull);
    });
  });

  group('LoanFormValidators.monthlyIncome', () {
    test('rejects empty values', () {
      expect(
        LoanFormValidators.monthlyIncome(null),
        LoanFormValidators.monthlyIncomeRequired,
      );
      expect(
        LoanFormValidators.monthlyIncome(''),
        LoanFormValidators.monthlyIncomeRequired,
      );
    });

    test('rejects invalid numbers', () {
      expect(
        LoanFormValidators.monthlyIncome('abc'),
        LoanFormValidators.invalidNumber,
      );
    });

    test('must be greater than 0', () {
      expect(
        LoanFormValidators.monthlyIncome('0'),
        LoanFormValidators.monthlyIncomeInvalid,
      );
      expect(
        LoanFormValidators.monthlyIncome('-100'),
        LoanFormValidators.monthlyIncomeInvalid,
      );
      expect(LoanFormValidators.monthlyIncome('50000'), isNull);
      expect(LoanFormValidators.monthlyIncome('25000.50'), isNull);
    });
  });

  group('LoanFormValidators.existingEmi', () {
    test('rejects empty values', () {
      expect(
        LoanFormValidators.existingEmi(null),
        LoanFormValidators.existingEmiRequired,
      );
      expect(
        LoanFormValidators.existingEmi(''),
        LoanFormValidators.existingEmiRequired,
      );
    });

    test('rejects invalid numbers', () {
      expect(
        LoanFormValidators.existingEmi('xyz'),
        LoanFormValidators.invalidNumber,
      );
    });

    test('cannot be negative', () {
      expect(
        LoanFormValidators.existingEmi('-100'),
        LoanFormValidators.existingEmiNegative,
      );
      expect(LoanFormValidators.existingEmi('0'), isNull);
      expect(LoanFormValidators.existingEmi('5000'), isNull);
    });

    test('cannot exceed monthly income', () {
      expect(
        LoanFormValidators.existingEmi(
          '60000',
          monthlyIncomeValue: '50000',
        ),
        LoanFormValidators.existingEmiExceedsIncome,
      );
      expect(
        LoanFormValidators.existingEmi(
          '50000',
          monthlyIncomeValue: '50000',
        ),
        isNull,
      );
      expect(
        LoanFormValidators.existingEmi(
          '10000',
          monthlyIncomeValue: '50000',
        ),
        isNull,
      );
    });
  });

  group('LoanFormValidators.requiredLoanAmount', () {
    test('rejects empty values', () {
      expect(
        LoanFormValidators.requiredLoanAmount(null),
        LoanFormValidators.loanAmountRequired,
      );
      expect(
        LoanFormValidators.requiredLoanAmount(''),
        LoanFormValidators.loanAmountRequired,
      );
    });

    test('rejects invalid numbers', () {
      expect(
        LoanFormValidators.requiredLoanAmount('abc'),
        LoanFormValidators.invalidNumber,
      );
    });

    test('must be greater than 0', () {
      expect(
        LoanFormValidators.requiredLoanAmount('0'),
        LoanFormValidators.loanAmountInvalid,
      );
      expect(
        LoanFormValidators.requiredLoanAmount('-5000'),
        LoanFormValidators.loanAmountInvalid,
      );
      expect(LoanFormValidators.requiredLoanAmount('100000'), isNull);
    });
  });
}
