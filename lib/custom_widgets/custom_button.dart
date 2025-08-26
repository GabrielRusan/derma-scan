import 'package:derma_scan/custom_widgets/custom_text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Icon? icon;
  final double? distanceBetweenTextIcon;
  final double? textSize;
  final EdgeInsets? margin;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.textSize,
    this.distanceBetweenTextIcon,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: margin ?? EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 16)),
        ),
        child:
            icon != null
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PoppinsText(
                      text,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(width: distanceBetweenTextIcon ?? 8),
                    icon!,
                  ],
                )
                : Text(text, style: TextStyle(fontSize: textSize)),
      ),
    );
  }
}
