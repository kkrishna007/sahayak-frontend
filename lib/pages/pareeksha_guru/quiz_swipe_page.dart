import 'package:flutter/material.dart';
import 'dart:convert';
import 'quiz_summary_page.dart';

class QuizSwipePage extends StatefulWidget {
  final Map<String, String> quizData;

  const QuizSwipePage({super.key, required this.quizData});

  @override
  State<QuizSwipePage> createState() => _QuizSwipePageState();
}

class _QuizSwipePageState extends State<QuizSwipePage>
    with TickerProviderStateMixin {
  PageController pageController = PageController();
  int currentQuestionIndex = 0;
  List<bool> likedQuestions = [];
  List<Map<String, dynamic>> questions = [];
  String? selectedAnswer;

  // Swipe animation variables
  double _dragDistance = 0.0;
  bool _isSwipeCompleted = false;
  Color _cardColor = Colors.white;

  late AnimationController _cardAnimationController;
  late AnimationController _swipeAnimationController;
  late AnimationController _colorAnimationController;

  late Animation<Offset> _swipeAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _generateQuestions();

    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _swipeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _colorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(3.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _swipeAnimationController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.2,
    ).animate(CurvedAnimation(
      parent: _swipeAnimationController,
      curve: Curves.easeOut,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.green,
    ).animate(CurvedAnimation(
      parent: _colorAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void _generateQuestions() {
    String subject = widget.quizData['subject']!;
    String chapter = widget.quizData['chapter']!;
    
    // Parse API response
    if (widget.quizData.containsKey('apiResponse')) {
      final apiData = json.decode(widget.quizData['apiResponse']!);
      final questionsData = apiData['questions'] as Map<String, dynamic>;
      
      questions = questionsData.entries.map((entry) {
        final questionData = entry.value as Map<String, dynamic>;
        return {
          'topic': questionData['topic'] ?? '',
          'question': questionData['question'] ?? '',
          'subject': subject,
          'chapter': chapter,
        };
      }).toList();
    } else {
      // Fallback to sample questions
      List<Map<String, dynamic>> sampleQuestions =
          _getSampleQuestions(subject, chapter);
      questions = sampleQuestions.take(5).toList();
    }
    
    likedQuestions = List.filled(questions.length, false);
  }

  List<Map<String, dynamic>> _getSampleQuestions(
      String subject, String chapter) {
    // Sample questions for different subjects
    if (subject == 'English') {
      return [
        {
          'question': 'What is the main character in "$chapter"?',
          'options': ['Raj', 'Priya', 'Amit', 'Sunita'],
          'subject': subject,
          'chapter': chapter,
        },
        {
          'question': 'Choose the correct spelling:',
          'options': ['Beautiful', 'Beautifull', 'Beutiful', 'Beatiful'],
          'subject': subject,
          'chapter': chapter,
        },
        {
          'question': 'What is the opposite of "happy"?',
          'options': ['Sad', 'Angry', 'Excited', 'Calm'],
          'subject': subject,
          'chapter': chapter,
        },
        {
          'question': 'Which word rhymes with "cat"?',
          'options': ['Bat', 'Dog', 'Fish', 'Bird'],
          'subject': subject,
          'chapter': chapter,
        },
        {
          'question': 'What is a group of lions called?',
          'options': ['Pride', 'Pack', 'Herd', 'Flock'],
          'subject': subject,
          'chapter': chapter,
        },
      ];
    } else if (subject == 'Maths') {
      return [
        {
          'question': 'What is 15 + 27?',
          'options': ['42', '41', '43', '40'],
          'subject': subject,
          'chapter': chapter,
        },
        {
          'question': 'How many sides does a triangle have?',
          'options': ['3', '4', '2', '5'],
          'subject': subject,
          'chapter': chapter,
        },
        {
          'question': 'What is 8 × 7?',
          'options': ['56', '54', '58', '52'],
          'subject': subject,
          'chapter': chapter,
        },
        {
          'question': 'Which number comes after 99?',
          'options': ['100', '101', '98', '90'],
          'subject': subject,
          'chapter': chapter,
        },
        {
          'question': 'What is half of 20?',
          'options': ['10', '15', '5', '25'],
          'subject': subject,
          'chapter': chapter,
        },
      ];
    } else {
      // EVS
      return [
        {
          'question': 'Which planet is closest to the Sun?',
          'options': ['Mercury', 'Venus', 'Earth', 'Mars'],
          'subject': subject,
          'chapter': chapter,
        },
        {
          'question': 'What do plants need to make food?',
          'options': ['Sunlight', 'Darkness', 'Ice', 'Sand'],
          'subject': subject,
          'chapter': chapter,
        },
        {
          'question': 'Which animal is known as the King of Jungle?',
          'options': ['Lion', 'Tiger', 'Elephant', 'Bear'],
          'subject': subject,
          'chapter': chapter,
        },
        {
          'question': 'How many seasons are there in a year?',
          'options': ['4', '3', '5', '6'],
          'subject': subject,
          'chapter': chapter,
        },
        {
          'question': 'Which gas do we breathe in?',
          'options': ['Oxygen', 'Carbon dioxide', 'Nitrogen', 'Hydrogen'],
          'subject': subject,
          'chapter': chapter,
        },
      ];
    }
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    _swipeAnimationController.dispose();
    _colorAnimationController.dispose();
    pageController.dispose();
    super.dispose();
  }

  void _handleSwipe(bool isLike) {
    if (_isSwipeCompleted) return;

    setState(() {
      _isSwipeCompleted = true;
      likedQuestions[currentQuestionIndex] = isLike;
    });

    // Set color animation based on swipe direction
    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: isLike ? Colors.green : Colors.red,
    ).animate(CurvedAnimation(
      parent: _colorAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start color animation
    _colorAnimationController.forward();

    // Start swipe animation
    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(isLike ? 3.0 : -3.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _swipeAnimationController,
      curve: Curves.easeOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: isLike ? 0.2 : -0.2,
    ).animate(CurvedAnimation(
      parent: _swipeAnimationController,
      curve: Curves.easeOut,
    ));

    _swipeAnimationController.forward().then((_) {
      // Reset animations and move to next question
      _colorAnimationController.reset();
      _swipeAnimationController.reset();

      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          _isSwipeCompleted = false;
          _dragDistance = 0.0;
        });
      } else {
        _navigateToSummary();
      }
    });
  }

  void _navigateToSummary() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QuizSummaryPage(
          totalQuestions: questions.length,
          likedQuestions: likedQuestions.where((liked) => liked).length,
          quizData: widget.quizData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Question ${currentQuestionIndex + 1} of ${questions.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress Bar
          Container(
            height: 4,
            margin: const EdgeInsets.all(16),
            child: LinearProgressIndicator(
              value: (currentQuestionIndex + 1) / questions.length,
              backgroundColor: Colors.grey[300],
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
            ),
          ),

          // Question Card
          Expanded(
            child: Center(
              child: GestureDetector(
                onPanUpdate: (details) {
                  if (_isSwipeCompleted) return;

                  setState(() {
                    _dragDistance += details.delta.dx;
                  });

                  // Update card color based on drag distance
                  double normalizedDistance =
                      (_dragDistance / 150).clamp(-1.0, 1.0);
                  if (normalizedDistance > 0.3) {
                    // Right swipe - green
                    setState(() {
                      _cardColor = Color.lerp(Colors.white,
                          Colors.green.withOpacity(0.3), normalizedDistance)!;
                    });
                  } else if (normalizedDistance < -0.3) {
                    // Left swipe - red
                    setState(() {
                      _cardColor = Color.lerp(Colors.white,
                          Colors.red.withOpacity(0.3), -normalizedDistance)!;
                    });
                  } else {
                    setState(() {
                      _cardColor = Colors.white;
                    });
                  }
                },
                onPanEnd: (details) {
                  if (_isSwipeCompleted) return;

                  double velocity = details.velocity.pixelsPerSecond.dx;
                  double threshold = 300.0;

                  if (velocity > threshold || _dragDistance > 100) {
                    _handleSwipe(true); // Swipe right - like
                  } else if (velocity < -threshold || _dragDistance < -100) {
                    _handleSwipe(false); // Swipe left - dislike
                  } else {
                    // Reset card position
                    setState(() {
                      _dragDistance = 0.0;
                      _cardColor = Colors.white;
                    });
                  }
                },
                child: AnimatedBuilder(
                  animation: Listenable.merge(
                      [_swipeAnimationController, _colorAnimationController]),
                  builder: (context, child) {
                    double translateX = _isSwipeCompleted
                        ? _swipeAnimation.value.dx *
                            MediaQuery.of(context).size.width
                        : _dragDistance;

                    double rotation = _isSwipeCompleted
                        ? _rotationAnimation.value
                        : (_dragDistance / 1000).clamp(-0.1, 0.1);

                    Color currentColor = _isSwipeCompleted
                        ? _colorAnimation.value ?? Colors.white
                        : _cardColor;

                    return Transform.translate(
                      offset: Offset(translateX, 0),
                      child: Transform.rotate(
                        angle: rotation,
                        child: _buildQuestionCard(currentColor),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Dislike Button
                GestureDetector(
                  onTap: () => _handleSwipe(false),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),

                // Like Button
                GestureDetector(
                  onTap: () => _handleSwipe(true),
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Color cardColor) {
    final question = questions[currentQuestionIndex];

    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subject/Chapter Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF6B73FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              question['topic'] ?? '${question['subject']} • ${question['chapter']}',
              style: const TextStyle(
                color: Color(0xFF6B73FF),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Question
          Expanded(
            child: Center(
              child: Text(
                question['question'],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Swipe Instructions
          const Center(
            child: Text(
              '👈 Swipe left to discard • Swipe right to keep 👉',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
