import 'package:flutter/material.dart';
import 'pareeksha_guru/pareeksha_guru_page.dart';
import 'prabandhan_saathi/prabandhan_saathi_page.dart';
import 'sahayata_chat/sahayata_chat_page.dart';
import '../utils/translations.dart';

class SahayakHomePage extends StatefulWidget {
  const SahayakHomePage({super.key});

  @override
  State<SahayakHomePage> createState() => _SahayakHomePageState();
}

class _SahayakHomePageState extends State<SahayakHomePage> {
  String _currentLanguage = 'en';

  void _toggleLanguage() {
    setState(() {
      _currentLanguage = _currentLanguage == 'en' ? 'hi' : 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6B73FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
        title: const Text(
          '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: _toggleLanguage,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  _currentLanguage == 'en' ? 'हिंदी' : 'English',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF6B73FF),
            ),
            child: Column(
              children: [
                Text(
                  AppTranslations.translate('sahayak', _currentLanguage),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  AppTranslations.translate(
                      'your_ai_teaching_assistant', _currentLanguage),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                // Profile Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6B9D),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'PS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppTranslations.translate(
                                  'mrs_priya_sharma', _currentLanguage),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              AppTranslations.translate(
                                  'shishu_vidhyalay', _currentLanguage),
                              style: const TextStyle(
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
                        child: Text(
                          AppTranslations.translate('active', _currentLanguage),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Aapka AI Sahayak
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.smart_toy,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        AppTranslations.translate(
                            'aapka_ai_sahayak', _currentLanguage),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main Content Section
          Expanded(
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    context,
                    AppTranslations.translate(
                        'shikshak_mitra', _currentLanguage),
                    AppTranslations.translate(
                        'teaching_companion', _currentLanguage),
                    const Color(0xFF4CAF50),
                    Icons.school,
                    AppTranslations.translate('ready', _currentLanguage),
                    null,
                  ),
                  _buildFeatureCard(
                    context,
                    AppTranslations.translate(
                        'pareeksha_guru', _currentLanguage),
                    AppTranslations.translate('exam_master', _currentLanguage),
                    const Color(0xFFFF9800),
                    Icons.quiz,
                    AppTranslations.translate('active', _currentLanguage),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PareekshaGuruPage(),
                      ),
                    ),
                  ),
                  _buildFeatureCard(
                    context,
                    AppTranslations.translate(
                        'sahayata_chat', _currentLanguage),
                    AppTranslations.translate(
                        'help_assistant', _currentLanguage),
                    const Color(0xFF0057E7), // Updated to match color palette
                    Icons.chat,
                    AppTranslations.translate('live', _currentLanguage),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SahayataChatPage(),
                      ),
                    ),
                  ),
                  _buildFeatureCard(
                    context,
                    AppTranslations.translate(
                        'prabandhan_saathi', _currentLanguage),
                    AppTranslations.translate(
                        'management_assistant', _currentLanguage),
                    const Color(0xFF9C27B0),
                    Icons.bar_chart,
                    AppTranslations.translate('running', _currentLanguage),
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PrabandhanSaathiPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    // Map status text to colors
    final Map<String, Color> statusColors = {
      'Ready': const Color(0xFF4CAF50),
      'तैयार': const Color(0xFF4CAF50),
      'Active': const Color(0xFFFF9800),
      'सक्रिย': const Color(0xFFFF9800),
      'Live': const Color(0xFF2196F3),
      'लाइव': const Color(0xFF2196F3),
      'Running': const Color(0xFF9C27B0),
      'चालू': const Color(0xFF9C27B0),
    };

    return statusColors[status] ?? const Color(0xFF4CAF50);
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    IconData icon,
    String status,
    VoidCallback? onTap,
  ) {
    Color statusColor = _getStatusColor(status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
