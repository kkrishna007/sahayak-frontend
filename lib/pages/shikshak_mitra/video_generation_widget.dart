import 'package:flutter/material.dart';

class VideoGenerationWidget extends StatefulWidget {
  final Map<String, Color> colors;

  const VideoGenerationWidget({
    super.key,
    required this.colors,
  });

  @override
  State<VideoGenerationWidget> createState() => _VideoGenerationWidgetState();
}

class _VideoGenerationWidgetState extends State<VideoGenerationWidget>
    with TickerProviderStateMixin {
  // Video generation state
  bool isGeneratingVideo = false;
  bool videoGenerated = false;

  // Shimmer animation for loading
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  // Loading messages for video generation
  final List<String> _loadingMessages = [
    "Starting video generation...",
    "Processing concept details...",
    "Building animation scenes...",
    "Rendering visual content...",
    "Finalizing video output...",
    "Video ready for preview"
  ];
  int _currentMessageIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize shimmer animation for video loading
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.colors['background']!,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.colors['primary']!.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          _buildHeader(),
          const SizedBox(height: 20),
          // Dynamic content based on state
          if (videoGenerated) ...[
            _buildVideoPlaceholder(),
          ] else if (isGeneratingVideo) ...[
            _buildShimmerLoader(),
          ] else ...[
            // Initial state: Feature card + Generate button
            _buildFeatureCard(),
            const SizedBox(height: 20),
            _buildVideoGenerateButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.video_library,
          color: widget.colors['primary']!,
          size: 28,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Generate Concept Video',
                style: TextStyle(
                  color: widget.colors['primary']!,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'AI-generated concept explanation video if possible',
                style: TextStyle(
                  color: widget.colors['primary']!,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: widget.colors['primary']!.withOpacity(0.1),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: widget.colors['background']!.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.play_circle_filled,
              color: widget.colors['primary']!,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manim Video Generation',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Concept explanation video',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF059669),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoGenerateButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _startVideoGeneration,
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.colors['primary']!,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          elevation: 2,
        ),
        child: const Text(
          'Generate',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _startVideoGeneration() async {
    setState(() {
      isGeneratingVideo = true;
      _currentMessageIndex = 0;
    });

    // Start shimmer animation
    try {
      _shimmerController.repeat();
    } catch (e) {
      print('Error starting shimmer animation: $e');
    }

    // Cycle through loading messages
    for (int i = 0; i < _loadingMessages.length; i++) {
      setState(() {
        _currentMessageIndex = i;
      });
      await Future.delayed(const Duration(seconds: 2));
    }

    // Stop shimmer animation
    try {
      _shimmerController.stop();
    } catch (e) {
      print('Error stopping shimmer animation: $e');
    }

    // Initialize video completion
    await _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    // Simulate video generation completion
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      isGeneratingVideo = false;
      videoGenerated = true;
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Concept video generated successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Widget _buildShimmerLoader() {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        final shimmerValue = _shimmerAnimation.value;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.colors['primary']!.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Shimmer effect container
              Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment(shimmerValue - 1, 0),
                    end: Alignment(shimmerValue, 0),
                    colors: [
                      widget.colors['primary']!.withOpacity(0.1),
                      widget.colors['primary']!.withOpacity(0.3),
                      widget.colors['primary']!.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: widget.colors['primary']!,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _loadingMessages[_currentMessageIndex],
                          style: TextStyle(
                            color: widget.colors['primary']!,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Progress indicator
              LinearProgressIndicator(
                backgroundColor: widget.colors['primary']!.withOpacity(0.1),
                valueColor:
                    AlwaysStoppedAnimation<Color>(widget.colors['primary']!),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideoPlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: widget.colors['background']!.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.colors['primary']!.withOpacity(0.2),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library,
            size: 64,
            color: widget.colors['primary']!.withOpacity(0.7),
          ),
          const SizedBox(height: 16),
          Text(
            'Concept Video Generated',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.colors['primary']!,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mathematical concept explanation',
            style: TextStyle(
              fontSize: 14,
              color: widget.colors['primary']!.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: widget.colors['primary']!,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Video Ready',
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
}
