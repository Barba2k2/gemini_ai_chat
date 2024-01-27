import 'package:flutter/material.dart';

class TypingMessageBubble extends StatefulWidget {
  final String message;
  final int speedFactor;

  const TypingMessageBubble({
    Key? key,
    required this.message,
    this.speedFactor = 30,
  }) : super(key: key);

  @override
  _TypingMessageBubbleState createState() => _TypingMessageBubbleState();
}

class _TypingMessageBubbleState extends State<TypingMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _typingAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration:
          Duration(milliseconds: widget.message.length * widget.speedFactor),
      vsync: this,
    );

    _typingAnimation =
        IntTween(begin: 0, end: widget.message.length).animate(_controller)
          ..addListener(() {
            setState(() {});
          });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        widget.message.substring(0, _typingAnimation.value),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          height: 1.7,
        ),
      ),
    );
  }
}
