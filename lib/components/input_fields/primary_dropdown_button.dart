import 'package:flutter/material.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/styles.dart';

class CustomDropdownButtonFormField<T> extends FormField<T> {
  final ValueChanged<T?>? onChanged;
  final InputDecoration decoration;

  CustomDropdownButtonFormField({
    Key? key,
    required List<DropdownMenuItem<T>>? items,
    DropdownButtonBuilder? selectedItemBuilder,
    T? value,
    Widget? hint,
    Widget? disabledHint,
    this.onChanged,
    VoidCallback? onTap,
    int elevation = 8,
    TextStyle? style,
    Widget? icon,
    Color? iconDisabledColor,
    Color? iconEnabledColor,
    double iconSize = 24.0,
    bool isDense = true,
    bool isExpanded = false,
    double? itemHeight,
    Color? focusColor,
    FocusNode? focusNode,
    bool autofocus = false,
    Color? dropdownColor,
    InputDecoration? decoration,
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
    @Deprecated(
      'Use autovalidateMode parameter which provide more specific '
      'behaviour related to auto validation. '
      'This feature was deprecated after v1.19.0.',
    )
        bool autovalidate = false,
    AutovalidateMode? autovalidateMode,
    double? menuMaxHeight,
  })  : assert(
          items == null ||
              items.isEmpty ||
              value == null ||
              items.where((DropdownMenuItem<T> item) {
                    return item.value == value;
                  }).length ==
                  1,
          "There should be exactly one item with [DropdownButton]'s value: "
          '$value. \n'
          'Either zero or 2 or more [DropdownMenuItem]s were detected '
          'with the same value',
        ),
        assert(itemHeight == null || itemHeight >= kMinInteractiveDimension),
        assert(
          autovalidate == false || autovalidate == true && autovalidateMode == null,
          'autovalidate and autovalidateMode should not be used together.',
        ),
        decoration = decoration ?? InputDecoration(focusColor: focusColor),
        super(
          key: key,
          onSaved: onSaved,
          initialValue: value,
          validator: validator,
          autovalidateMode: autovalidate ? AutovalidateMode.always : (autovalidateMode ?? AutovalidateMode.disabled),
          builder: (FormFieldState<T> field) {
            final _DropdownButtonFormFieldState<T> state = field as _DropdownButtonFormFieldState<T>;
            final InputDecoration decorationArg = decoration ?? InputDecoration(focusColor: focusColor);
            final InputDecoration effectiveDecoration = decorationArg.applyDefaults(
              Theme.of(field.context).inputDecorationTheme,
            );
            // An unfocusable Focus widget so that this widget can detect if its
            // descendants have focus or not.
            return Focus(
              canRequestFocus: false,
              skipTraversal: true,
              child: Builder(builder: (BuildContext context) {
                return InputDecorator(
                  decoration: effectiveDecoration.copyWith(
                    errorText: field.errorText,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  isEmpty: state.value == null,
                  isFocused: Focus.of(context).hasFocus,
                  child: Container(
                    constraints: BoxConstraints(minHeight: 48),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<T>(
                        items: items,
                        selectedItemBuilder: selectedItemBuilder,
                        value: state.value,
                        hint: hint,
                        disabledHint: disabledHint,
                        onChanged: onChanged == null ? null : state.didChange,
                        onTap: onTap,
                        elevation: elevation,
                        style: style,
                        icon: icon,
                        iconDisabledColor: iconDisabledColor,
                        iconEnabledColor: iconEnabledColor,
                        iconSize: iconSize,
                        isDense: isDense,
                        isExpanded: isExpanded,
                        itemHeight: itemHeight,
                        focusColor: focusColor,
                        focusNode: focusNode,
                        autofocus: autofocus,
                        dropdownColor: dropdownColor,
                        menuMaxHeight: menuMaxHeight,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        );

  @override
  FormFieldState<T> createState() => _DropdownButtonFormFieldState<T>();
}

// Increase clickable area in dropdownbutton
class PrimaryDropdownButton<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final List<DropdownMenuItem<T>> itemList;
  final bool isExpand;
  final ValueChanged<T?>? onChanged;

  const PrimaryDropdownButton(
      {Key? key, this.value, required this.itemList, this.hint = "", this.isExpand = false, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: CustomDropdownButtonFormField<T>(
        value: value,
        isExpanded: isExpand,
        hint: Text(
          hint,
          style: TextStyles.body14.copyWith(color: kBlackVariant),
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          isDense: false,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 2, color: kLightBlue),
          ),
        ),
        onChanged: onChanged,
        iconSize: 18,
        items: itemList,
      ),
    );
  }
}

class _DropdownButtonFormFieldState<T> extends FormFieldState<T> {
  @override
  CustomDropdownButtonFormField<T> get widget => super.widget as CustomDropdownButtonFormField<T>;

  @override
  void didChange(T? value) {
    super.didChange(value);
    assert(widget.onChanged != null);
    widget.onChanged!(value);
  }

  @override
  void didUpdateWidget(CustomDropdownButtonFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setValue(widget.initialValue);
    }
  }
}
