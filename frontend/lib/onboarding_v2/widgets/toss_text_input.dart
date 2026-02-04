import 'package:flutter/material.dart';
import '../../theme_v2/app_colors.dart';
import '../../theme_v2/app_typography.dart';

/// Text input component matching React implementation
class TossTextInput extends StatelessWidget {
  final String? value;
  final ValueChanged<String>? onChanged;
  final String? placeholder;
  final int? maxLength;
  final TextInputType? keyboardType;
  final String? counterText;

  const TossTextInput({
    super.key,
    this.value,
    this.onChanged,
    this.placeholder,
    this.maxLength,
    this.keyboardType,
    this.counterText,
  });

  @override
  Widget build(BuildContext context) {
    return _TossTextInputStateful(
      value: value,
      onChanged: onChanged,
      placeholder: placeholder,
      maxLength: maxLength,
      keyboardType: keyboardType,
      counterText: counterText,
    );
  }
}

class _TossTextInputStateful extends StatefulWidget {
  final String? value;
  final ValueChanged<String>? onChanged;
  final String? placeholder;
  final int? maxLength;
  final TextInputType? keyboardType;
  final String? counterText;

  const _TossTextInputStateful({
    this.value,
    this.onChanged,
    this.placeholder,
    this.maxLength,
    this.keyboardType,
    this.counterText,
  });

  @override
  State<_TossTextInputStateful> createState() => _TossTextInputStatefulState();
}

class _TossTextInputStatefulState extends State<_TossTextInputStateful> {
  late TextEditingController _controller;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(_TossTextInputStateful oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: _hasFocus ? AppColorsV2.surface : AppColorsV2.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _hasFocus ? AppColorsV2.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            _hasFocus = hasFocus;
          });
        },
        child: TextField(
          controller: _controller,
          onChanged: widget.onChanged,
          maxLength: widget.maxLength,
          keyboardType: widget.keyboardType,
          style: AppTypographyV2.body,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: AppTypographyV2.body.copyWith(
              color: AppColorsV2.textSub,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            counterText: widget.counterText ?? (widget.maxLength != null ? null : ''),
            counterStyle: AppTypographyV2.small,
            suffixIcon: widget.maxLength != null && widget.counterText == null
                ? Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      widthFactor: 1.0,
                      child: Text(
                        '${_controller.text.length}/${widget.maxLength}',
                        style: AppTypographyV2.small,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
