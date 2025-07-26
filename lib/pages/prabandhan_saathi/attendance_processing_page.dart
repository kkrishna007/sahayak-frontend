import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'attendance_results_page.dart';

class AttendanceProcessingPage extends StatefulWidget {
  final Map<String, dynamic> attendanceData;
  final File capturedImage;

  const AttendanceProcessingPage({
    super.key,
    required this.attendanceData,
    required this.capturedImage,
  });

  @override
  State<AttendanceProcessingPage> createState() =>
      _AttendanceProcessingPageState();
}

class _AttendanceProcessingPageState extends State<AttendanceProcessingPage> {
  final List<String> _steps = [
    'Initializing...',
    'Connecting to AI model...',
    'Analyzing image data...',
    'Processing facial features...',
    'Querying student database...',
    'Computing attendance logic...',
    'Generating final report...',
    'Task completed ✅',
  ];

  int _currentStep = 0;
  Timer? _stepTimer;
  Timer? _typingTimer;
  int _typedChars = 0;
  bool _navigated = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _startStep();
  }

  void _startStep() {
    _typedChars = 0;
    _typingTimer?.cancel();
    _typingTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {
        _typedChars++;
        if (_typedChars >= _steps[_currentStep].length) {
          _typingTimer?.cancel();
          _stepTimer = Timer(
            Duration(seconds: _currentStep == _steps.length - 1 ? 1 : 2),
            _completeCurrentStep,
          );
        }
      });
    });
  }

  void _completeCurrentStep() {
    if (!mounted) return;
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      _startStep();
      // Auto-scroll to bottom to show new step
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } else {
      _navigateToResults();
    }
  }

  void _navigateToResults() {
    if (_navigated) return;
    _navigated = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AttendanceResultsPage(
              attendanceData: widget.attendanceData,
              capturedImage: widget.capturedImage,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _stepTimer?.cancel();
    _typingTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color blue = const Color(0xFF0057e7);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: blue,
        elevation: 0,
        title: const Text(
          'AI Processing Attendance',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F0FF), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Build cumulative list of steps
                  for (int i = 0; i <= _currentStep; i++) ...[
                    _buildStepItem(i),
                    if (i <= _currentStep) const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(int stepIndex) {
    final bool isCurrent = stepIndex == _currentStep;
    final bool isLast = stepIndex == _steps.length - 1;
    final Color blue = const Color(0xFF0057e7);

    if (isCurrent) {
      // Current step: Show typing effect and loading dots with dots below
      final String textToShow = _steps[stepIndex]
          .substring(0, _typedChars.clamp(0, _steps[stepIndex].length));
      final bool showTyping = _typedChars < _steps[stepIndex].length;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isLast
                      ? Colors.green.withOpacity(0.15)
                      : blue.withOpacity(0.15),
                ),
                child: isLast
                    ? Icon(Icons.check_circle, color: Colors.green, size: 20)
                    : _PulsingDots(),
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                    children: [
                      TextSpan(text: textToShow),
                      if (showTyping)
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: _TypingCursor(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Add dot lines below current step (but not for last step)
          if (!isLast) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0057e7),
                      height: 0.8,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0057e7),
                      height: 0.8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      );
    } else {
      // Completed step: Show with checkmark, no dots
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(0.15),
            ),
            child: Icon(Icons.check_circle, color: Colors.green, size: 20),
          ),
          Expanded(
            child: Text(
              _steps[stepIndex],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      );
    }
  }
}

// Pulsing dots widget for loading effect
class _PulsingDots extends StatefulWidget {
  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _dot = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..addListener(() {
        if (_controller.status == AnimationStatus.completed) {
          _controller.repeat();
        }
        setState(() {
          _dot = ((_controller.value * 3).floor()) % 3;
        });
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
    String dots = '.' * (_dot + 1);
    return Text(
      dots,
      style: const TextStyle(
        color: Color(0xFF0057e7),
        fontWeight: FontWeight.bold,
        fontSize: 18,
        letterSpacing: 1.5,
      ),
    );
  }
}

// Typing cursor widget for typing effect
class _TypingCursor extends StatefulWidget {
  @override
  State<_TypingCursor> createState() => _TypingCursorState();
}

class _TypingCursorState extends State<_TypingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
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
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 10,
        height: 18,
        margin: const EdgeInsets.only(left: 2),
        decoration: BoxDecoration(
          color: Colors.blue.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
