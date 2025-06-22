import 'package:flutter/material.dart';

class PulsatingMedalIcon extends StatefulWidget {
  final Color color;
  final double size;

  const PulsatingMedalIcon({Key? key, required this.color, this.size = 40})
    : super(key: key);

  @override
  _PulsatingMedalIconState createState() => _PulsatingMedalIconState();
}

class _PulsatingMedalIconState extends State<PulsatingMedalIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Icon(Icons.emoji_events, color: widget.color, size: widget.size),
    );
  }
}
