import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingDotsPage(),
    );
  }
}

class LoadingDotsPage extends StatelessWidget {
  const LoadingDotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: const Center(child: LoadingDots()),
    );
  }
}

class LoadingDots extends StatefulWidget {
  const LoadingDots({super.key});

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _scaleAnimations;
  late List<Animation<double>> _opacityAnimations;

  @override
  void initState() {
    super.initState();
    // AnimationController is the "engine" of the animation
    // duration = 1200ms, it will keep repeating in a loop
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(); // ..repeat(reverse: true); ==> for reverse
    // Create 3 scale animations with delays between them
    _scaleAnimations = List.generate(3, (index) {
      final start =
          index * 0.2; // each animation starts later (staggered effect)
      final end =
          start + 0.5; // each animation lasts 50% of the controller’s timeline
      // Tween defines the range: from 0.5x size (smaller) to 1.2x size (bigger)
      return Tween<double>(begin: 0.5, end: 1.2).animate(
        CurvedAnimation(
          parent: _controller, // controlled by _controller
          curve: Interval(
            // Interval = when this animation should run
            start,
            end,
            curve: Curves.easeInOut,
          ), // smooth in & out movement
        ),
      );
    });
    // Create 3 opacity animations with the same staggered timing
    _opacityAnimations = List.generate(3, (index) {
      final start = index * 0.2; // delay each animation
      final end = start + 0.5; // lasts half of the total duration
      // Tween defines the range: from 0.3 opacity (semi-transparent) to 1.0 (fully visible)

      return Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller, // controlled by _controller
          curve: Interval(
            start,
            end,
            curve: Curves.easeInOut,
          ), // smooth fade in/out
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Opacity(
                opacity: _opacityAnimations[index].value,
                child: Transform.scale(
                  scale: _scaleAnimations[index].value,
                  child: const Dot(),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
    );
  }
}
