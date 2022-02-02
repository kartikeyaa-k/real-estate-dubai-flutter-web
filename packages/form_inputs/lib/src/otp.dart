import 'package:formz/formz.dart';

/// Validation errors for the [OTP] [FormzInput].
enum OTPValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template OTP}
/// Form input for an OTP input.
/// {@endtemplate}
class OTP extends FormzInput<String, OTPValidationError> {
  /// {@macro OTP}
  const OTP.pure() : super.pure('');

  /// {@macro OTP}
  const OTP.dirty([String value = '']) : super.dirty(value);

  static final _passwordRegExp = RegExp(r'^([0-9]).{5,6}$');

  @override
  OTPValidationError? validator(String? value) {
    return _passwordRegExp.hasMatch(value ?? '') ? null : OTPValidationError.invalid;
  }
}
