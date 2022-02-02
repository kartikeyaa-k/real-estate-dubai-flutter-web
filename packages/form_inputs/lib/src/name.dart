import 'package:formz/formz.dart';

/// Validation errors for the [Name] [FormzInput].
enum NameValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template name}
/// Form input for an name input.
/// {@endtemplate}
class Name extends FormzInput<String, NameValidationError> {
  /// {@macro name}
  const Name.pure() : super.pure('');

  /// {@macro name}
  const Name.dirty([String value = '']) : super.dirty(value);

  static final _nameRegExp = RegExp(r'^([a-zA-Z]).{1,50}$');

  @override
  NameValidationError? validator(String? value) {
    return _nameRegExp.hasMatch(value ?? '') ? null : NameValidationError.invalid;
  }
}
