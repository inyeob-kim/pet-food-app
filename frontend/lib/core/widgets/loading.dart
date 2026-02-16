import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/animations/loading_dots.json',
        width: 500,
        height: 500,
        fit: BoxFit.contain,
        repeat: true,
        animate: true,
      ),
    );
  }
}
