import 'package:flutter/material.dart';

class QuizSummaryPage extends StatelessWidget {
  final int totalQuestions;
  final int likedQuestions;
  final Map<String, String> quizData;

  const QuizSummaryPage({
    super.key,
    required this.totalQuestions,
    required this.likedQuestions,
    required this.quizData,
  });

  @override
  Widget build(BuildContext context) {
    double percentage = (likedQuestions / totalQuestions) * 100;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () =>
              Navigator.popUntil(context, (route) => route.isFirst),
        ),
        title: const Text(
          'Quiz Complete',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success Icon
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 80,
                      color: Color(0xFF4CAF50),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Main Result Text
                  Text(
                    'You liked $likedQuestions out of $totalQuestions questions',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  // Percentage
                  Text(
                    '${percentage.toInt()}% Success Rate',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Quiz Details Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quiz Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDetailRow('Class', quizData['class']!),
                        _buildDetailRow('Subject', quizData['subject']!),
                        _buildDetailRow('Chapter', quizData['chapter']!),
                        _buildDetailRow(
                            'Total Questions', totalQuestions.toString()),
                        _buildDetailRow(
                            'Liked Questions', likedQuestions.toString()),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Motivational Message
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B73FF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '🎉',
                          style: TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getMotivationalMessage(percentage),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6B73FF),
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _regenerateQuiz(context),
                    child: const Text(
                      'Generate Another Quiz',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF6B73FF)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => _reviewLikedQuestions(context),
                    child: const Text(
                      'Review Liked Questions',
                      style: TextStyle(
                        color: Color(0xFF6B73FF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () =>
                        Navigator.popUntil(context, (route) => route.isFirst),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getMotivationalMessage(double percentage) {
    if (percentage >= 80) {
      return 'Excellent work! You have great taste in questions!';
    } else if (percentage >= 60) {
      return 'Good job! You\'re getting better at identifying quality questions!';
    } else if (percentage >= 40) {
      return 'Keep practicing! You\'re learning to spot the good ones!';
    } else {
      return 'Don\'t worry! Every expert was once a beginner. Keep going!';
    }
  }

  void _regenerateQuiz(BuildContext context) {
    Navigator.popUntil(context, (route) => route.settings.name == '/');
    // Navigate back to quiz selection
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Generate New Quiz'),
        content: const Text(
            'Would you like to generate a new quiz with the same settings or choose different parameters?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to quiz selection page
            },
            child: const Text('Different Settings'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Regenerate with same settings
            },
            child: const Text('Same Settings'),
          ),
        ],
      ),
    );
  }

  void _reviewLikedQuestions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Review Liked Questions'),
        content: Text(
            'You liked $likedQuestions questions. This feature will show you all the questions you marked as favorites for further study.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement review functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Review feature coming soon!'),
                ),
              );
            },
            child: const Text('View Questions'),
          ),
        ],
      ),
    );
  }
}
