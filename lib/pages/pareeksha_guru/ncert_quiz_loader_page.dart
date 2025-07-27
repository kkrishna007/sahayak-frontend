import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'quiz_swipe_page.dart';

class NCERTQuizLoaderPage extends StatefulWidget {
  final Map<String, String> quizData;

  const NCERTQuizLoaderPage({super.key, required this.quizData});

  @override
  State<NCERTQuizLoaderPage> createState() => _NCERTQuizLoaderPageState();
}

class _NCERTQuizLoaderPageState extends State<NCERTQuizLoaderPage>
    with TickerProviderStateMixin {
  int currentMessageIndex = 0;
  Timer? messageTimer;
  Map<String, dynamic>? apiResponse;

  late AnimationController _fadeController;
  late AnimationController _progressController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _progressAnimation;

  final List<Map<String, dynamic>> loadingMessages = [
    {'emoji': '🧠', 'text': 'Thinking...'},
    {'emoji': '📚', 'text': 'Fetching NCERT Database...'},
    {'emoji': '🧐', 'text': 'Handpicking the best questions...'},
    {'emoji': '🛠️', 'text': 'Building your personalized quiz...'},
    {'emoji': '✅', 'text': 'Ready! Let\'s begin…'},
  ];

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _startLoadingSequence();
  }

  void _startLoadingSequence() {
    _fadeController.forward();
    _progressController.forward();

    messageTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentMessageIndex < loadingMessages.length - 1) {
        setState(() {
          currentMessageIndex++;
        });

        _fadeController.reset();
        _fadeController.forward();
      } else {
        timer.cancel();
      }
    });

    // Make API call immediately
    _makeAPICall();
    
    // Navigate after exactly 15 seconds
    Timer(const Duration(seconds: 15), () {
      if (mounted) {
        final quizDataWithAPI = Map<String, String>.from(widget.quizData);
        if (apiResponse != null) {
          quizDataWithAPI['apiResponse'] = json.encode(apiResponse);
        }
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizSwipePage(
              quizData: quizDataWithAPI,
            ),
          ),
        );
      }
    });
  }

  Future<void> _makeAPICall() async {
    try {
      final response = await http.post(
        Uri.parse('https://mcf0c3q9-4000.inc1.devtunnels.ms/api/v1/shikshak-mitra/generation-questions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'question': 'Generate questions related to ${widget.quizData['chapter']}'
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          apiResponse = responseData;
        });
      }
    } catch (e) {
      print('API Error: $e');
    }
  }

  @override
  void dispose() {
    messageTimer?.cancel();
    _fadeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6B73FF),
              Color(0xFF9C27B0),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Generating Quiz',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Message
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          // Emoji
                          Text(
                            loadingMessages[currentMessageIndex]['emoji'],
                            style: const TextStyle(fontSize: 80),
                          ),
                          const SizedBox(height: 24),
                          // Message Text
                          Text(
                            loadingMessages[currentMessageIndex]['text'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Progress Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                              return LinearProgressIndicator(
                                value: _progressAnimation.value,
                                backgroundColor: Colors.white24,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                minHeight: 4,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          AnimatedBuilder(
                            animation: _progressAnimation,
                            builder: (context, child) {
                              return Text(
                                '${(_progressAnimation.value * 100).toInt()}%',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Quiz Details
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Quiz Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow('Class', widget.quizData['class']!),
                          _buildDetailRow(
                              'Subject', widget.quizData['subject']!),
                          _buildDetailRow(
                              'Chapter', widget.quizData['chapter']!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
