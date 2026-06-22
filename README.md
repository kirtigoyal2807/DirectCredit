# Loan Application Form

A Flutter app with a loan application form and proper field validation.

## Fields

- Full Name
- Mobile Number
- Monthly Income
- Existing EMI
- Required Loan Amount

## Validation Rules

| Field | Validation |
|-------|------------|
| Full Name | Cannot be empty |
| Mobile Number | Must contain exactly 10 digits |
| Monthly Income | Required, valid number, must be greater than 0 |
| Existing EMI | Required, valid number, cannot be negative (0 allowed), cannot exceed monthly income |
| Required Loan Amount | Required, valid number, must be greater than 0 |

## Run

```bash
cd loan_application_form
flutter pub get
cd ios && pod install && cd ..
flutter run
```

### iPhone build fix (CocoaPods / xcfilelist error)

If you see `Unable to load contents of file list: Pods-Runner-frameworks-Debug-input-files.xcfilelist`, run:

```bash
cd loan_application_form
flutter clean
flutter pub get
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter run
```

Always open **`ios/Runner.xcworkspace`** in Xcode (not `Runner.xcodeproj`).

## State management

Uses [flutter_bloc](https://pub.dev/packages/flutter_bloc) (Cubit). See `lib/cubit/`.

## Test

```bash
flutter test
```
