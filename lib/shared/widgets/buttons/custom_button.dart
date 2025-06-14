import 'package:flutter/material.dart';

enum ButtonType { primary, secondary, outline, text }
enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // 버튼 높이 계산
    double height;
    double fontSize;
    EdgeInsets padding;

    switch (size) {
      case ButtonSize.small:
        height = 36;
        fontSize = 14;
        padding = const EdgeInsets.symmetric(horizontal: 16);
        break;
      case ButtonSize.medium:
        height = 44;
        fontSize = 16;
        padding = const EdgeInsets.symmetric(horizontal: 24);
        break;
      case ButtonSize.large:
        height = 52;
        fontSize = 18;
        padding = const EdgeInsets.symmetric(horizontal: 32);
        break;
    }

    // 버튼 스타일 정의
    ButtonStyle buttonStyle;
    Widget child;

    switch (type) {
      case ButtonType.primary:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          shadowColor: colorScheme.primary.withOpacity(0.3),
        );
        break;
      case ButtonType.secondary:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: colorScheme.secondary,
          foregroundColor: colorScheme.onSecondary,
          elevation: 1,
        );
        break;
      case ButtonType.outline:
        buttonStyle = OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.outline),
        );
        break;
      case ButtonType.text:
        buttonStyle = TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
        );
        break;
    }

    // 공통 스타일 적용
    buttonStyle = buttonStyle.copyWith(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      padding: MaterialStateProperty.all(padding),
      minimumSize: MaterialStateProperty.all(Size(0, height)),
      textStyle: MaterialStateProperty.all(
        TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
      ),
    );

    // 로딩 중이거나 비활성화 상태 처리
    final bool isButtonEnabled = isEnabled && !isLoading && onPressed != null;

    // 버튼 내용 구성
    if (isLoading) {
      child = SizedBox(
        height: fontSize,
        width: fontSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            type == ButtonType.primary
                ? colorScheme.onPrimary
                : colorScheme.primary,
          ),
        ),
      );
    } else if (icon != null) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: fontSize),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    } else {
      child = Text(text);
    }

    // 버튼 위젯 생성
    Widget button;

    switch (type) {
      case ButtonType.primary:
      case ButtonType.secondary:
        button = ElevatedButton(
          onPressed: isButtonEnabled ? onPressed : null,
          style: buttonStyle,
          child: child,
        );
        break;
      case ButtonType.outline:
        button = OutlinedButton(
          onPressed: isButtonEnabled ? onPressed : null,
          style: buttonStyle,
          child: child,
        );
        break;
      case ButtonType.text:
        button = TextButton(
          onPressed: isButtonEnabled ? onPressed : null,
          style: buttonStyle,
          child: child,
        );
        break;
    }

    // 너비 제한
    if (width != null) {
      return SizedBox(width: width, child: button);
    }

    return button;
  }
}