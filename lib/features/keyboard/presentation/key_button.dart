import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/native_input_service.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/settings_provider.dart';

class KeyButton extends ConsumerStatefulWidget {
  final String label;
  final String? value;
  final Widget? icon;
  final double flex;
  final bool isSpecial;
  final VoidCallback onTap;
  final List<String>? popupKeys;

  const KeyButton({
    super.key,
    required this.label,
    this.value,
    this.icon,
    this.flex = 1.0,
    this.isSpecial = false,
    required this.onTap,
    this.popupKeys,
  });

  @override
  ConsumerState<KeyButton> createState() => _KeyButtonState();
}

class _KeyButtonState extends ConsumerState<KeyButton> {
  bool _isPressed = false;

  void _triggerFeedback() {
    final settings = ref.read(settingsProvider);
    if (settings.hapticStrength > 0) {
      NativeInputService.vibrate(settings.hapticStrength);
    }
    NativeInputService.playSound(settings.soundType);
  }

  void _showPopupKeys(BuildContext context) {
    if (widget.popupKeys == null || widget.popupKeys!.isEmpty) return;

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (ctx) {
        final theme = ref.read(themeProvider).activeTheme;
        return Stack(
          children: [
            Positioned(
              left: offset.dx - 20,
              top: offset.dy - 60,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.keyColor.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: theme.accentColor.withOpacity(0.4),
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.popupKeys!.map((char) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(ctx).pop();
                          NativeInputService.commitText(char);
                          _triggerFeedback();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            char,
                            style: TextStyle(
                              color: theme.keyTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider).activeTheme;

    final bgColor = widget.isSpecial ? theme.specialKeyColor : theme.keyColor;
    final textColor = widget.isSpecial ? theme.specialKeyTextColor : theme.keyTextColor;

    return Expanded(
      flex: (widget.flex * 10).round(),
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: GestureDetector(
          onTapDown: (_) {
            setState(() => _isPressed = true);
            _triggerFeedback();
          },
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          onLongPress: () {
            if (widget.popupKeys != null) {
              _showPopupKeys(context);
            }
          },
          child: AnimatedScale(
            scale: _isPressed ? 0.92 : 1.0,
            duration: const Duration(milliseconds: 80),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: bgColor.withOpacity(theme.opacity),
                borderRadius: BorderRadius.circular(theme.borderRadius),
                border: Border.all(
                  color: _isPressed
                      ? theme.accentColor
                      : theme.borderColor.withOpacity(0.6),
                  width: theme.borderWidth,
                ),
                boxShadow: [
                  if (theme.glowIntensity > 0 || _isPressed)
                    BoxShadow(
                      color: theme.accentColor.withOpacity(_isPressed ? 0.6 : theme.glowIntensity * 0.4),
                      blurRadius: _isPressed ? 12 : theme.glowIntensity * 8,
                      spreadRadius: _isPressed ? 1 : 0,
                    ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: widget.icon ??
                    Text(
                      widget.label,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: theme.fontFamily,
                      ),
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
