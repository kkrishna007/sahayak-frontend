class AppTranslations {
  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'sahayak': 'Sahayak',
      'your_ai_teaching_assistant': 'Your AI Teaching Assistant',
      'mrs_priya_sharma': 'Mrs. Priya Sharma',
      'shishu_vidhyalay': 'Shishu Vidhyalay',
      'active': 'Active',
      'aapka_ai_sahayak': 'Your AI Assistant',
      'shikshak_mitra': 'Shikshak Mitra',
      'teaching_companion': 'Teaching Companion',
      'pareeksha_guru': 'Pareeksha Guru',
      'exam_master': 'Exam Master',
      'sahayata_chat': 'Sahayata Chat',
      'help_assistant': 'Help Assistant',
      'prabandhan_saathi': 'Prabandhan Saathi',
      'management_assistant': 'Management Assistant',
      'ready': 'Ready',
      'live': 'Live',
      'running': 'Running',
    },
    'hi': {
      'sahayak': 'सहायक',
      'your_ai_teaching_assistant': 'आपका AI शिक्षण सहायक',
      'mrs_priya_sharma': 'श्रीमती प्रिया शर्मा',
      'shishu_vidhyalay': 'शिशु विद्यालय',
      'active': 'सक्रिय',
      'aapka_ai_sahayak': 'आपका AI सहायक',
      'shikshak_mitra': 'शिक्षक मित्र',
      'teaching_companion': 'शिक्षण साथी',
      'pareeksha_guru': 'परीक्षा गुरु',
      'exam_master': 'परीक्षा मास्टर',
      'sahayata_chat': 'सहायता चैट',
      'help_assistant': 'सहायता सहायक',
      'prabandhan_saathi': 'प्रबंधन साथी',
      'management_assistant': 'प्रबंधन सहायक',
      'ready': 'तैयार',
      'live': 'लाइव',
      'running': 'चालू',
    },
  };

  static String translate(String key, String languageCode) {
    return _translations[languageCode]?[key] ?? key;
  }
}
