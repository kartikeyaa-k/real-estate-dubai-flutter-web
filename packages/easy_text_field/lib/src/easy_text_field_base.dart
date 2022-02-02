import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

typedef ParseObjectToString<T> = String Function(T? object);

class EasyTextField<T> extends StatefulWidget {
  const EasyTextField({
    Key? key,
    this.controller,
    this.inputFormatters,
    required this.suggestionsCallback,
    required this.itemBuilder,
    required this.parseObjectToString,
    this.scrollableTagsPadding = const EdgeInsets.symmetric(horizontal: 4.0),
    this.scrollableTagsMargin,
    this.labelStyle,
    this.backgroundColor,
    this.loadingBuilder,
    this.text,
    this.focusedColor,
    this.enabledColor,
    this.errorColor,
    this.fillColor,
    this.obscureText = false,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.onChanged,
    this.maxLength,
    this.height = 48,
    this.minLines,
    this.maxLines = 1,
    this.keyboardType,
    this.initialValue,
    this.readOnly = false,
    this.enabled = true,
    this.errorText,
    this.hintStyle,
    required this.onSuggestionSelected,
    required this.onDeleted,
  }) : super(key: key);

  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final SuggestionsCallback<T> suggestionsCallback;
  final ItemBuilder<T> itemBuilder;
  final ParseObjectToString<T> parseObjectToString;
  final WidgetBuilder? loadingBuilder;
  final EdgeInsets scrollableTagsPadding;
  final EdgeInsets? scrollableTagsMargin;
  final TextStyle? labelStyle;
  final Color? backgroundColor;
  final String? text;
  final Color? focusedColor;
  final Color? enabledColor;
  final Color? errorColor;
  final Color? fillColor;
  final bool obscureText;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final ValueChanged<String>? onChanged;
  final SuggestionSelectionCallback<T> onSuggestionSelected;
  final int? maxLength;
  final double? height;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final List<T>? initialValue;
  final bool readOnly;
  final bool enabled;
  final String? errorText;
  final TextStyle? hintStyle;
  final ValueChanged<T> onDeleted;

  @override
  _EasyTextFieldState<T> createState() => _EasyTextFieldState<T>();
}

class _EasyTextFieldState<T> extends State<EasyTextField<T>> {
  final List<T> _selectedItems = [];
  final List<Chip> _selectedItemsChips = [];

  @override
  void initState() {
    super.initState();
    _selectedItems.addAll([...widget.initialValue ?? []]);
    for (var suggestion in _selectedItems) {
      ValueKey key = ValueKey("key$suggestion");
      _selectedItemsChips.add(
        Chip(
          key: key,
          label: Text(widget.parseObjectToString(suggestion)),
          labelStyle: widget.labelStyle,
          backgroundColor: widget.backgroundColor,
          onDeleted: () {
            _selectedItems.removeWhere((element) => element == suggestion);
            setState(() => _selectedItemsChips.removeWhere((element) => element.key == key));

            // user delete action
            widget.onDeleted(suggestion);
          },
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<T>(
      suggestionsCallback: widget.suggestionsCallback,
      itemBuilder: widget.itemBuilder,
      loadingBuilder: widget.loadingBuilder,
      debounceDuration: const Duration(milliseconds: 150),
      textFieldConfiguration: TextFieldConfiguration(
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.text,
          errorText: widget.errorText,
          hintStyle: widget.hintStyle,
          suffixIcon: widget.suffixIcon,
          suffixIconConstraints: widget.suffixIconConstraints,
          filled: widget.fillColor != null,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          fillColor: widget.fillColor ?? Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 2.5, color: widget.focusedColor ?? const Color(0xFF18A0FB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            borderSide: BorderSide(width: 2, color: widget.enabledColor ?? const Color(0xFF99C9E7)),
          ),
          errorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 2, color: widget.errorColor ?? const Color(0xFFF03738))),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 2, color: widget.errorColor ?? const Color(0xFFF03738))),
          prefixIcon: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 2,
            ),
            child: Container(
              margin: widget.scrollableTagsMargin,
              padding: widget.scrollableTagsPadding,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _selectedItemsChips,
                ),
              ),
            ),
          ),
        ),
        inputFormatters: widget.inputFormatters,
        autofocus: false,
      ),
      onSuggestionSelected: (T suggestion) {
        ValueKey key = ValueKey("key$suggestion");

        // check so same suggestion is not added again
        if (suggestion != null && !_selectedItems.contains(suggestion)) {
          _selectedItems.add(suggestion);
          setState(() {
            _selectedItemsChips.add(
              Chip(
                key: key,
                label: Text(widget.parseObjectToString(suggestion)),
                labelStyle: widget.labelStyle,
                backgroundColor: widget.backgroundColor,
                onDeleted: () {
                  _selectedItems.removeWhere((element) => element == suggestion);
                  setState(() => _selectedItemsChips.removeWhere((element) => element.key == key));

                  // user delete action
                  widget.onDeleted(suggestion);
                },
              ),
            );
          });

          widget.controller?.clear();

          // Call the method given by user
          widget.onSuggestionSelected(suggestion);
        }
      },
    );
  }
}
