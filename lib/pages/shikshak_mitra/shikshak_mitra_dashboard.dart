import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ShikshakMitraDashboard extends StatefulWidget {
  const ShikshakMitraDashboard({super.key});

  @override
  State<ShikshakMitraDashboard> createState() => _ShikshakMitraDashboardState();
}

class _ShikshakMitraDashboardState extends State<ShikshakMitraDashboard>
    with TickerProviderStateMixin {
  String activePhase = 'pre';
  late AnimationController _dotPulseController;
  late Animation<double> _dotPulseAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize pulsing animation for status indicator (removed)

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
          colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
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
            // Phase toggle buttons
            _buildPhaseToggle(),
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

  Widget _buildPhaseToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton('Pre-Class', 'pre'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildToggleButton('During Class', 'during'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildToggleButton('Post-Class', 'post'),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String title, String phase) {
    bool isActive = activePhase == phase;
    return GestureDetector(
      onTap: () {
        setState(() {
          activePhase = phase;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: isActive ? Border.all(color: const Color(0xFF3B82F6)) : null,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? const Color(0xFF3B82F6) : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Pulsing status indicator
        _buildStatusIndicator(),
        const SizedBox(height: 20),
        // Phase-specific content
        ..._buildPhaseContent(),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    String statusText = _getStatusText();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              statusText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText() {
    switch (activePhase) {
      case 'pre':
        return 'Auto-Running Background Tasks';
      case 'during':
        return 'Live Teaching Support';
      case 'post':
        return 'Student Tracking & Assessment';
      default:
        return 'AI Assistant Active';
    }
  }

  Map<String, Color> _getPhaseColors() {
    switch (activePhase) {
      case 'pre':
        return {
          'primary': const Color(0xFFEA580C),
          'background': const Color(0xFFFED7AA),
        };
      case 'during':
        return {
          'primary': const Color(0xFF2563EB),
          'background': const Color(0xFFDBEAFE),
        };
      case 'post':
        return {
          'primary': const Color(0xFF9333EA),
          'background': const Color(0xFFF3E8FF),
        };
      default:
        return {
          'primary': const Color(0xFF2563EB),
          'background': const Color(0xFFDBEAFE),
        };
    }
  }

  List<Widget> _buildPhaseContent() {
    switch (activePhase) {
      case 'pre':
        return _buildPreClassContent();
      case 'during':
        return _buildDuringClassContent();
      case 'post':
        return _buildPostClassContent();
      default:
        return [];
    }
  }

  List<Widget> _buildPreClassContent() {
    return [
      _buildFeatureCard(
        'Daily Lesson Scheduler',
        'Updated with new curriculum changes',
        [
          'Created 25 lesson plans across Math, Science, English',
          'Aligned with curriculum standards',
          'Optimized for your teaching schedule',
        ],
        Icons.schedule,
      ),
      const SizedBox(height: 16),
      _buildFeatureCard(
        'Material Preparation',
        'Preparing for today\'s classes',
        [
          'Prepared worksheets for Grade 5 Math',
          'Generated visual aids for Science lesson',
          'Created assessment rubrics',
        ],
        Icons.library_books,
      ),
    ];
  }

  List<Widget> _buildDuringClassContent() {
    return [
      _buildFeatureCard(
        'BlackBoard Layout',
        'Mermaid diagrams ready',
        [
          'Generated flowchart for water cycle',
          'Created fraction visualization layout',
          'Optimized board space usage',
        ],
        Icons.dashboard,
      ),
      const SizedBox(height: 16),
      _buildFeatureCard(
        'Activity Suggestions',
        'Real-time recommendations',
        [
          'Interactive game for Grade 3 (5 min)',
          'Quick assessment for Grade 4 (3 min)',
          'Discussion starter for Grade 5 (7 min)',
        ],
        Icons.sports_esports,
      ),
      const SizedBox(height: 16),
      _buildFeatureCard(
        'Contextual Content',
        'Photo-based assistance',
        [
          'Click textbook page for explanations',
          'Generate Manim animations',
          'Hyper-local content suggestions',
          'Video recommendations from internet',
        ],
        Icons.photo_camera,
      ),
    ];
  }

  List<Widget> _buildPostClassContent() {
    return [
      _buildFeatureCard(
        'Quiz Worksheets',
        'Personalized for each student',
        [
          'Tailored quizzes (70% strong areas)',
          'Next quiz focuses on weak areas (30%)',
          'Multi-level auto-generation',
        ],
        Icons.quiz,
      ),
      const SizedBox(height: 16),
      _buildFeatureCard(
        'Exam Management',
        'NCERT-based generation',
        [
          'Standard exam generation',
          'OMR/OCR-based checking',
          'Automated grading system',
        ],
        Icons.assignment,
      ),
      const SizedBox(height: 16),
      _buildFeatureCard(
        'Absentee Support',
        'Video delivery system',
        [
          'Send beamer videos to absent students',
          'Lesson summaries for catch-up',
          'Parent notification system',
        ],
        Icons.video_library,
      ),
      const SizedBox(height: 16),
      _buildFeatureCard(
        'Sahayak AI Chat',
        'Spontaneous learning support',
        [
          'Student curiosity questions',
          'Current events discussions',
          'Real-world connections',
          'News-to-lesson integration',
        ],
        Icons.chat_bubble,
      ),
    ];
  }

  Widget _buildFeatureCard(
    String title,
    String subtitle,
    List<String> bulletPoints,
    IconData icon,
  ) {
    final colors = _getPhaseColors();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors['background']!.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: colors['primary']!,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          // Pulsing green dot
                          AnimatedBuilder(
                            animation: _dotPulseAnimation,
                            builder: (context, child) {
                              return Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF059669),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF059669)
                                          .withOpacity(
                                              _dotPulseAnimation.value),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 8),
                          // Green subtitle text
                          Expanded(
                            child: Text(
                              subtitle,
                              style: const TextStyle(
                                fontSize: 14,
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
              ],
            ),
            const SizedBox(height: 16),
            // Bullet points
            ...bulletPoints.map((point) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: colors['primary']!,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          point,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
