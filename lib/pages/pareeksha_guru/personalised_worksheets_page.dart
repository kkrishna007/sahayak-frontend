import 'package:flutter/material.dart';

class PersonalisedWorksheetsPage extends StatelessWidget {
  const PersonalisedWorksheetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Personalised Worksheets',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Personalised Worksheets',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create customized worksheets based on individual student weak concepts from previous assessments',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            // Student List
            const Text(
              'Select Student',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildStudentCard(
                    context,
                    'Aarav Sharma',
                    'Weak in: Algebra, Geometry',
                    '67%',
                    const Color(0xFFFF9800),
                    ['Mathematics', 'Physics'],
                  ),
                  const SizedBox(height: 12),
                  _buildStudentCard(
                    context,
                    'Priya Patel',
                    'Weak in: Chemical Reactions, Periodic Table',
                    '71%',
                    const Color(0xFF4CAF50),
                    ['Chemistry', 'Biology'],
                  ),
                  const SizedBox(height: 12),
                  _buildStudentCard(
                    context,
                    'Rohit Kumar',
                    'Weak in: Thermodynamics, Mechanics',
                    '58%',
                    const Color(0xFFEF5350),
                    ['Physics', 'Mathematics'],
                  ),
                  const SizedBox(height: 12),
                  _buildStudentCard(
                    context,
                    'Sneha Gupta',
                    'Weak in: Grammar, Essay Writing',
                    '74%',
                    const Color(0xFF4CAF50),
                    ['English', 'Hindi'],
                  ),
                  const SizedBox(height: 12),
                  _buildStudentCard(
                    context,
                    'Arjun Singh',
                    'Weak in: Modern History, Geography',
                    '63%',
                    const Color(0xFFFF9800),
                    ['History', 'Geography'],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(
    BuildContext context,
    String name,
    String weakAreas,
    String score,
    Color scoreColor,
    List<String> subjects,
  ) {
    return GestureDetector(
      onTap: () => _showWorksheetDialog(context, name, weakAreas, subjects),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF6B73FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Center(
                child: Text(
                  name.split(' ').map((e) => e[0]).join(''),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B73FF),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Student Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weakAreas,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subject chips
                  Wrap(
                    spacing: 4,
                    children: subjects
                        .map((subject) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                subject,
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            // Score
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: scoreColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    score,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showWorksheetDialog(BuildContext context, String studentName,
      String weakAreas, List<String> subjects) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Generate Worksheet for $studentName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Student: $studentName'),
              const SizedBox(height: 8),
              Text('Weak Areas: $weakAreas'),
              const SizedBox(height: 16),
              const Text('Worksheet Configuration:'),
              const SizedBox(height: 8),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Number of Questions',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Difficulty Level (1-5)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Focus Areas (comma separated)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B73FF),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _showWorksheetGeneratedDialog(context, studentName);
              },
              child: const Text('Generate Worksheet',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showWorksheetGeneratedDialog(BuildContext context, String studentName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Worksheet Generated!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFF4CAF50),
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                'Personalised worksheet for $studentName has been generated successfully!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                '• Focused on identified weak areas\n• Adaptive difficulty level\n• Progress tracking enabled',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('View Worksheet'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
