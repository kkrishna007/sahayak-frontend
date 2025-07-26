import 'package:flutter/material.dart';

class SahayataChatPage extends StatefulWidget {
  const SahayataChatPage({super.key});

  @override
  State<SahayataChatPage> createState() => _SahayataChatPageState();
}

class _SahayataChatPageState extends State<SahayataChatPage> {
  final TextEditingController _messageController = TextEditingController();
  String? _userMessage;
  String? _botReply;
  bool _isLoading = false;
  bool _hasReplied = false;

  // Color palette
  static const Color primaryGreen = Color(0xFF008744); // RGB(0,135,68)
  static const Color primaryBlue = Color(0xFF0057E7); // RGB(0,87,231)
  static const Color primaryRed = Color(0xFFD62D20); // RGB(214,45,32)
  static const Color primaryYellow = Color(0xFFFFA700); // RGB(255,167,0)
  static const Color primaryWhite = Color(0xFFFFFFFF); // RGB(255,255,255)

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _userMessage = message;
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate bot response
    setState(() {
      _botReply = _generateBotResponse(message);
      _isLoading = false;
      _hasReplied = true;
    });

    _messageController.clear();
  }

  String _generateBotResponse(String message) {
    // Simple response simulation
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('attendance') ||
        lowerMessage.contains('हाजिरी')) {
      return "मैं आपकी हाजिरी के साथ मदद कर सकता हूं। आप कैमरा का उपयोग करके स्वचालित हाजिरी ले सकते हैं या मैन्युअल रूप से छात्रों को चिह्नित कर सकते हैं।";
    } else if (lowerMessage.contains('exam') ||
        lowerMessage.contains('परीक्षा')) {
      return "परीक्षा की तैयारी के लिए मैं आपकी मदद कर सकता हूं। आप प्रश्न पत्र बना सकते हैं, परीक्षा परिणाम का विश्लेषण कर सकते हैं।";
    } else if (lowerMessage.contains('student') ||
        lowerMessage.contains('छात्र')) {
      return "छात्र प्रबंधन के लिए मैं आपकी सहायता कर सकता हूं। आप छात्रों का प्रदर्शन ट्रैक कर सकते हैं और उनकी प्रगति देख सकते हैं।";
    } else if (lowerMessage.contains('help') || lowerMessage.contains('मदद')) {
      return "मैं आपका AI शिक्षक सहायक हूं। मैं हाजिरी, परीक्षा, छात्र प्रबंधन और शिक्षण में आपकी मदद कर सकता हूं। आप मुझसे कुछ भी पूछ सकते हैं!";
    } else {
      return "धन्यवाद आपके प्रश्न के लिए। मैं एक AI शिक्षक सहायक हूं और मैं शिक्षा संबंधी कार्यों में आपकी मदद कर सकता हूं। कृपया अधिक विशिष्ट प्रश्न पूछें।";
    }
  }

  void _startNewChat() {
    setState(() {
      _userMessage = null;
      _botReply = null;
      _hasReplied = false;
      _isLoading = false;
    });
  }

  void _recordVoiceNote() {
    // TODO: Implement voice recording functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice note feature coming soon!'),
        backgroundColor: primaryYellow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        title: const Text(
          'Sahayata Chat',
          style: TextStyle(
            color: primaryWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryWhite),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: primaryBlue,
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.smart_toy,
                  size: 48,
                  color: primaryWhite,
                ),
                SizedBox(height: 12),
                Text(
                  'आपका AI शिक्षक सहायक',
                  style: TextStyle(
                    color: primaryWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'मैं आपकी शिक्षण यात्रा में मदद करूंगा',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Chat Area
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: primaryWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_userMessage == null && _botReply == null)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: primaryBlue.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.chat_bubble_outline,
                                  size: 48,
                                  color: primaryBlue,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'नमस्ते! मैं आपका AI सहायक हूं',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'मुझसे कुछ भी पूछें या अपना संदेश टाइप करें',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_userMessage != null) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 50),
                                        padding: const EdgeInsets.all(16),
                                        decoration: const BoxDecoration(
                                          color: primaryGreen,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                            bottomLeft: Radius.circular(16),
                                            bottomRight: Radius.circular(4),
                                          ),
                                        ),
                                        child: Text(
                                          _userMessage!,
                                          style: const TextStyle(
                                            color: primaryWhite,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                              if (_isLoading) ...[
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                          bottomLeft: Radius.circular(4),
                                          bottomRight: Radius.circular(16),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                primaryBlue,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Text(
                                            'टाइप कर रहा है...',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ] else if (_botReply != null) ...[
                                Row(
                                  children: [
                                    Flexible(
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 50),
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                            bottomLeft: Radius.circular(4),
                                            bottomRight: Radius.circular(16),
                                          ),
                                        ),
                                        child: Text(
                                          _botReply!,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                    // Input Section or New Chat Button
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: _hasReplied
                          ? SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryBlue,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.chat_bubble_outline,
                                    color: primaryWhite),
                                label: const Text(
                                  'नई चैट शुरू करें',
                                  style: TextStyle(
                                    color: primaryWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: _startNewChat,
                              ),
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _messageController,
                                            enabled: !_isLoading,
                                            decoration: InputDecoration(
                                              hintText: 'अपना संदेश लिखें...',
                                              hintStyle: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 14,
                                              ),
                                              border: InputBorder.none,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 16,
                                              ),
                                            ),
                                            onSubmitted: _isLoading
                                                ? null
                                                : _sendMessage,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.mic,
                                            color: primaryYellow,
                                          ),
                                          onPressed: _isLoading
                                              ? null
                                              : _recordVoiceNote,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: primaryBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.send,
                                      color: primaryWhite,
                                    ),
                                    onPressed: _isLoading
                                        ? null
                                        : () => _sendMessage(
                                            _messageController.text),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
