import 'package:flutter/material.dart';
import 'quiz_generator_page.dart';
import 'omr_section_page.dart';
import 'personalised_worksheets_page.dart';

class PareekshaGuruPage extends StatefulWidget {
  const PareekshaGuruPage({super.key});

  @override
  State<PareekshaGuruPage> createState() => _PareekshaGuruPageState();
}

class _PareekshaGuruPageState extends State<PareekshaGuruPage>
    with TickerProviderStateMixin {
  late AnimationController _dotPulseController;
  late Animation<double> _dotPulseAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize pulsing animation for green dots in subtitles
    _dotPulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _dotPulseAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _dotPulseController,
      curve: Curves.easeInOut,
    ));
    _dotPulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _dotPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with gradient and status bar
          _buildHeader(),
          // Content area
          Expanded(
            child: Container(
              color: const Color(0xFFF9FAFB), // gray-50 equivalent
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8A50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Navigation and title
            _buildNavigationBar(),
            // Teacher profile card
            _buildProfileCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sahayak',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Your AI Teaching Assistant',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xFFFF6B9D),
            child: Text(
              'PS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mrs. Priya Sharma',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Shishu Vidhyalay',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'AI Active',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Status indicator container with nested feature cards
        _buildStatusIndicatorContainer(),
      ],
    );
  }

  Widget _buildStatusIndicatorContainer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFED7AA), // Light orange background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF6B35).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          Row(
            children: [
              const Icon(
                Icons.quiz,
                color: Color(0xFFEA580C),
                size: 28,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assessment & Testing Tools',
                      style: TextStyle(
                        color: Color(0xFFEA580C),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'AI-powered assessment generation and evaluation',
                      style: TextStyle(
                        color: Color(0xFFEA580C),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Feature cards section
          _buildFeatureCard(
            'Quiz Generator',
            'Generate quizzes from NCERT database',
            [
              'Create quizzes from textbook pages',
              'Multiple choice questions',
              'Aligned with curriculum standards',
            ],
            Icons.quiz,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QuizGeneratorPage(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildFeatureCard(
            'OMR Section',
            'Automated answer sheet processing',
            [
              'Generate OMR sheets instantly',
              'Scan and check bubbled sheets',
              'Automatic grading and analysis',
            ],
            Icons.scanner,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OMRSectionPage(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildFeatureCard(
            'Personalised Worksheets',
            'Adaptive learning materials',
            [
              'Based on student performance',
              'Target weak concepts',
              'Progressive difficulty levels',
            ],
            Icons.assignment,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PersonalisedWorksheetsPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    String title,
    String subtitle,
    List<String> bulletPoints,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFEA580C).withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFED7AA).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFFEA580C),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          // Pulsing green dot
                          AnimatedBuilder(
                            animation: _dotPulseAnimation,
                            builder: (context, child) {
                              return Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF059669),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF059669)
                                          .withOpacity(
                                              _dotPulseAnimation.value),
                                      blurRadius: 3,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 6),
                          // Green subtitle text
                          Expanded(
                            child: Text(
                              subtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
            // Bullet points
            if (bulletPoints.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...bulletPoints.map((point) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 4,
                          height: 4,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEA580C),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            point,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}
