import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('온보딩'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go('/pet-profile'),
          child: const Text('시작하기'),
        ),
      ),
    );
  }
}

