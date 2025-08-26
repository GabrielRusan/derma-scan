import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PoppinsText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const PoppinsText(
    this.text, {
    super.key,
    this.color,
    this.size,
    this.fontWeight,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  /// ====== Factory Styles ======
  factory PoppinsText.headline(
    String text, {
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return PoppinsText(
      text,
      color: color,
      size: 24,
      fontWeight: FontWeight.bold,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  factory PoppinsText.headlineMedium(
    String text, {
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return PoppinsText(
      text,
      color: color,
      size: 20,
      fontWeight: FontWeight.w600,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
  factory PoppinsText.headlineSmall(
    String text, {
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow,
    FontWeight? fontWeight,
    int? maxLines,
  }) {
    return PoppinsText(
      text,
      color: color,
      size: 18,
      fontWeight: fontWeight ?? FontWeight.w600,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  factory PoppinsText.body(
    String text, {
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return PoppinsText(
      text,
      color: color,
      size: 16,
      fontWeight: FontWeight.normal,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  factory PoppinsText.bodyMedium(
    String text, {
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return PoppinsText(
      text,
      color: color,
      size: 14,
      fontWeight: FontWeight.normal,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  factory PoppinsText.bodySmall(
    String text, {
    Color? color,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    return PoppinsText(
      text,
      color: color,
      size: 12,
      fontWeight: FontWeight.w400,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: GoogleFonts.poppins(
        color: color ?? Colors.black,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}
