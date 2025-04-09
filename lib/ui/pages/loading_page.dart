import 'dart:math';

import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();

    debugPrint("LoadingPage.dispose()");

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final opacity = sin(_controller.value * 2 * pi) * 0.35 + 0.65;
                return Opacity(
                  opacity: opacity.clamp(0.2, 0.8),
                  child: Text(
                    "Connect to the server...",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                );
              },
            ),

            const SizedBox(height: 15),
            const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
