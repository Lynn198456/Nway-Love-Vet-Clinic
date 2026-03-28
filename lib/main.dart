import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(const LoveVetClinicApp());
}

class LoveVetClinicApp extends StatelessWidget {
  const LoveVetClinicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Love Vet Clinic',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA8C0B3),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const _logoAsset =
      'Image/96834706b12cc7705f84b57428816f66b3983359.png';
  static const _dogAsset =
      'Image/12396e8a05092734d78448217d85a89baea8b970.png';
  static const _petsAsset = 'Image/image 4.png';

  bool _showLoginForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final metrics = _LoginMetrics.fromSize(constraints.biggest);

            return Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Colors.white,
                          const Color(0xFFF7F7F4),
                        ],
                        stops: const [0, 0.62, 1],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: metrics.logoTop,
                  left: metrics.sidePadding,
                  child: Image.asset(
                    _logoAsset,
                    width: metrics.logoWidth,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  right: metrics.dogRightOffset,
                  bottom: 0,
                  child: IgnorePointer(
                    child: Image.asset(
                      _dogAsset,
                      height: metrics.dogHeight,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                if (_showLoginForm)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: ColoredBox(
                        color: Colors.black.withValues(alpha: 0.14),
                      ),
                    ),
                  ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.08),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: _showLoginForm
                      ? _LoginFormSheet(
                          key: const ValueKey('login-form'),
                          metrics: metrics,
                          petsAsset: _petsAsset,
                        )
                      : Align(
                          key: const ValueKey('login-cta'),
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              metrics.sidePadding,
                              0,
                              metrics.sidePadding,
                              metrics.buttonBottomPadding,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: metrics.contentMaxWidth,
                              ),
                              child: SizedBox(
                                width: double.infinity,
                                height: metrics.primaryButtonHeight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _showLoginForm = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFA8C0B3),
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        metrics.primaryButtonRadius,
                                      ),
                                    ),
                                    textStyle: TextStyle(
                                      fontSize: metrics.primaryButtonTextSize,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  child: const Text('Log in'),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LoginFormSheet extends StatelessWidget {
  const _LoginFormSheet({
    super.key,
    required this.metrics,
    required this.petsAsset,
  });

  final _LoginMetrics metrics;
  final String petsAsset;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: viewInsets.bottom),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            metrics.sheetHorizontalMargin,
            0,
            metrics.sheetHorizontalMargin,
            metrics.sheetBottomMargin,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: metrics.contentMaxWidth,
              minHeight: metrics.sheetMinHeight,
              maxHeight: metrics.sheetMaxHeight,
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFA8C0B3),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(metrics.sheetTopRadius),
                  bottom: Radius.circular(metrics.sheetBottomRadius),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(metrics.sheetTopRadius),
                  bottom: Radius.circular(metrics.sheetBottomRadius),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    metrics.formHorizontalPadding,
                    metrics.formTopPadding,
                    metrics.formHorizontalPadding,
                    metrics.formBottomPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SheetLabel(text: 'Email', fontSize: metrics.labelSize),
                      SizedBox(height: metrics.fieldLabelGap),
                      _LoginTextField(
                        hintText: 'Enter your Email',
                        keyboardType: TextInputType.emailAddress,
                        height: metrics.fieldHeight,
                        fontSize: metrics.fieldFontSize,
                      ),
                      SizedBox(height: metrics.formSectionGap),
                      _SheetLabel(
                        text: 'Password',
                        fontSize: metrics.labelSize,
                      ),
                      SizedBox(height: metrics.fieldLabelGap),
                      _LoginTextField(
                        hintText: 'Enter your password',
                        obscureText: true,
                        height: metrics.fieldHeight,
                        fontSize: metrics.fieldFontSize,
                      ),
                      SizedBox(height: metrics.formSectionGap),
                      SizedBox(
                        width: double.infinity,
                        height: metrics.secondaryButtonHeight,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E2C2C),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                metrics.secondaryButtonRadius,
                              ),
                            ),
                            textStyle: TextStyle(
                              fontSize: metrics.secondaryButtonTextSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Sign In'),
                        ),
                      ),
                      SizedBox(height: metrics.linkTopGap),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          foregroundColor: const Color(0xFF222222),
                          textStyle: TextStyle(
                            fontSize: metrics.linkSize,
                            decoration: TextDecoration.underline,
                            decorationColor: const Color(0xFF222222),
                          ),
                        ),
                        child: const Text('Forgot password?'),
                      ),
                      SizedBox(height: metrics.petsTopGap),
                      Center(
                        child: Image.asset(
                          petsAsset,
                          width: metrics.petsWidth,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
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

class _SheetLabel extends StatelessWidget {
  const _SheetLabel({required this.text, required this.fontSize});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: const Color(0xFF222222),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _LoginTextField extends StatelessWidget {
  const _LoginTextField({
    required this.hintText,
    required this.height,
    required this.fontSize,
    this.keyboardType,
    this.obscureText = false,
  });

  final String hintText;
  final double height;
  final double fontSize;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        textInputAction: obscureText ? TextInputAction.done : TextInputAction.next,
        style: TextStyle(
          color: const Color(0xFF222222),
          fontSize: fontSize,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: const Color(0xFFB9B9B9),
            fontSize: fontSize,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: math.max(18, fontSize),
            vertical: math.max(14, fontSize * 0.8),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE4E4E4)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE4E4E4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF6D8E84), width: 1.6),
          ),
        ),
      ),
    );
  }
}

class _LoginMetrics {
  const _LoginMetrics({
    required this.width,
    required this.height,
    required this.sidePadding,
    required this.sheetHorizontalMargin,
    required this.sheetBottomMargin,
    required this.logoTop,
    required this.logoWidth,
    required this.dogHeight,
    required this.dogRightOffset,
    required this.contentMaxWidth,
    required this.buttonBottomPadding,
    required this.primaryButtonHeight,
    required this.primaryButtonRadius,
    required this.primaryButtonTextSize,
    required this.sheetMinHeight,
    required this.sheetMaxHeight,
    required this.sheetTopRadius,
    required this.sheetBottomRadius,
    required this.formHorizontalPadding,
    required this.formTopPadding,
    required this.formBottomPadding,
    required this.labelSize,
    required this.fieldHeight,
    required this.fieldFontSize,
    required this.fieldLabelGap,
    required this.formSectionGap,
    required this.secondaryButtonHeight,
    required this.secondaryButtonRadius,
    required this.secondaryButtonTextSize,
    required this.linkSize,
    required this.linkTopGap,
    required this.petsTopGap,
    required this.petsWidth,
  });

  final double width;
  final double height;
  final double sidePadding;
  final double sheetHorizontalMargin;
  final double sheetBottomMargin;
  final double logoTop;
  final double logoWidth;
  final double dogHeight;
  final double dogRightOffset;
  final double contentMaxWidth;
  final double buttonBottomPadding;
  final double primaryButtonHeight;
  final double primaryButtonRadius;
  final double primaryButtonTextSize;
  final double sheetMinHeight;
  final double sheetMaxHeight;
  final double sheetTopRadius;
  final double sheetBottomRadius;
  final double formHorizontalPadding;
  final double formTopPadding;
  final double formBottomPadding;
  final double labelSize;
  final double fieldHeight;
  final double fieldFontSize;
  final double fieldLabelGap;
  final double formSectionGap;
  final double secondaryButtonHeight;
  final double secondaryButtonRadius;
  final double secondaryButtonTextSize;
  final double linkSize;
  final double linkTopGap;
  final double petsTopGap;
  final double petsWidth;

  static _LoginMetrics fromSize(Size size) {
    final width = size.width;
    final height = size.height;
    final shortest = math.min(width, height);
    final isTablet = width >= 700;
    final isDesktop = width >= 1000;

    final sidePadding = width.clamp(320.0, 560.0) * 0.09;
    final contentMaxWidth = isDesktop ? 520.0 : (isTablet ? 500.0 : 420.0);
    final logoWidth = isDesktop
        ? 210.0
        : isTablet
            ? 180.0
            : width * 0.34;

    return _LoginMetrics(
      width: width,
      height: height,
      sidePadding: sidePadding,
      sheetHorizontalMargin: isDesktop ? 32 : math.max(16, sidePadding * 0.8),
      sheetBottomMargin: height < 700 ? 8 : 14,
      logoTop: math.max(24, height * 0.05),
      logoWidth: logoWidth.clamp(120, 220),
      dogHeight: isDesktop
          ? height * 0.88
          : isTablet
              ? height * 0.80
              : height * 0.67,
      dogRightOffset: isDesktop ? -120 : (isTablet ? -90 : -width * 0.22),
      contentMaxWidth: contentMaxWidth,
      buttonBottomPadding: height < 700 ? 18 : height * 0.06,
      primaryButtonHeight: isDesktop ? 68 : (shortest < 390 ? 58 : 64),
      primaryButtonRadius: isDesktop ? 24 : 28,
      primaryButtonTextSize: isDesktop ? 24 : (shortest < 390 ? 22 : 24),
      sheetMinHeight: height < 700 ? height * 0.58 : height * 0.54,
      sheetMaxHeight: isDesktop ? height * 0.78 : height * 0.64,
      sheetTopRadius: isDesktop ? 36 : 44,
      sheetBottomRadius: 28,
      formHorizontalPadding: isDesktop ? 40 : math.max(24, width * 0.08),
      formTopPadding: height < 700 ? 24 : 34,
      formBottomPadding: height < 700 ? 18 : 26,
      labelSize: isDesktop ? 22 : (shortest < 390 ? 18 : 22),
      fieldHeight: shortest < 390 ? 54 : 60,
      fieldFontSize: shortest < 390 ? 18 : 20,
      fieldLabelGap: shortest < 390 ? 8 : 12,
      formSectionGap: shortest < 390 ? 14 : 22,
      secondaryButtonHeight: shortest < 390 ? 54 : 60,
      secondaryButtonRadius: 12,
      secondaryButtonTextSize: shortest < 390 ? 19 : 21,
      linkSize: shortest < 390 ? 18 : 20,
      linkTopGap: shortest < 390 ? 12 : 18,
      petsTopGap: shortest < 390 ? 10 : 16,
      petsWidth: isDesktop ? 300 : (isTablet ? 290 : width * 0.55),
    );
  }
}
