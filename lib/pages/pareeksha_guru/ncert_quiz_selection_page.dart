import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ncert_quiz_loader_page.dart';

class NCERTQuizSelectionPage extends StatefulWidget {
  const NCERTQuizSelectionPage({super.key});

  @override
  State<NCERTQuizSelectionPage> createState() => _NCERTQuizSelectionPageState();
}

class _NCERTQuizSelectionPageState extends State<NCERTQuizSelectionPage> {
  String? selectedClass;
  String? selectedSubject;
  String? selectedChapter;

  final Map<String, Map<String, List<String>>> chaptersData = {
    '3': {
      'English': [
        'Colours',
        'Badal and Moti',
        'Best Friends',
        'Out in the Garden',
        'Talking Toys',
        'Paper Boats',
        'The Big Laddoo',
        'Thank God',
        'Madhu\'s Wish',
        'Night',
        'Chanda Mama Counts the Stars',
        'Chandrayaan',
      ],
      'Maths': [
        'What\'s in a Name?',
        'Toy Joy',
        'Double Century',
        'Vacation with My Nani Maa',
        'Fun with Shapes',
        'House of Hundreds - I',
        'Raksha Bandhan',
        'Fair Share',
        'House of Hundreds - II',
        'Fun at Class Party!',
        'Filling and Lifting',
        'Give and Take',
        'Time Goes On',
        'The Surajkund Fair',
      ],
      'EVS': [
        'Family and Friends',
        'Going to the Mela',
        'Celebrating Festivals',
        'Getting to Know Plants',
        'Plants and Animals Live Together',
        'Living in Harmony',
        'Water— A Precious Gift',
        'Food We Eat',
        'Staying Healthy and Happy',
        'This World of Things',
        'Making Things',
        'Taking Charge of Waste',
      ],
    },
    '4': {
      'English': [
        'Together We Can',
        'The Tinkling Bells',
        'Be Smart, Be Safe',
        'One Thing at a Time',
        'The Old Stag',
        'Braille',
        'Fit Body, Fit Mind, Fit Nation',
        'The Lagori Champions',
        'Hekko',
        'The Swing',
        'A Journey to the Magical Mountains',
        'Maheshwar',
      ],
      'Maths': [
        'Shapes Around Us',
        'Hide and Seek',
        'Pattern Around Us',
        'Thousands Around Us',
        'Sharing and Measuring',
        'Measuring Length',
        'The Cleanest Village',
        'Weigh it, Pour it',
        'Equal Groups',
        'Elephants, Tigers, and Leopards',
        'Fun with Symmetry',
        'Ticking Clocks and Turning Calendar',
        'The Transport Museum',
        'Data Handling',
      ],
      'EVS': [
        'Living Together',
        'Exploring Our Neighbourhood',
        'Nature Trail',
        'Growing up with Nature',
        'Food for Health',
        'Happy and Healthy Living',
        'How Things Work',
        'How Things are Made',
        'Different Lands, Different Lives',
        'Our Sky',
      ],
    },
  };

  List<String> get availableChapters {
    if (selectedClass != null && selectedSubject != null) {
      return chaptersData[selectedClass]?[selectedSubject] ?? [];
    }
    return [];
  }

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
          'Generate from NCERT Database',
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
            const Text(
              'Select Quiz Parameters',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose your preferences to generate a personalized quiz',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildDropdown(
                      'Class',
                      selectedClass,
                      ['3', '4'],
                      (value) {
                        setState(() {
                          selectedClass = value;
                          selectedSubject = null;
                          selectedChapter = null;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildDropdown(
                      'Subject',
                      selectedSubject,
                      selectedClass != null ? ['English', 'Maths', 'EVS'] : [],
                      (value) {
                        setState(() {
                          selectedSubject = value;
                          selectedChapter = null;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildDropdown(
                      'Chapter',
                      selectedChapter,
                      availableChapters,
                      (value) {
                        setState(() {
                          selectedChapter = value;
                        });
                      },
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormValid()
                              ? const Color(0xFF4CAF50)
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isFormValid() ? _generateQuiz : null,
                        child: const Text(
                          'Generate Quiz',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                'Select $label',
                style: const TextStyle(color: Colors.grey),
              ),
              isExpanded: true,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              onChanged: items.isEmpty ? null : onChanged,
            ),
          ),
        ),
      ],
    );
  }

  bool _isFormValid() {
    return selectedClass != null &&
        selectedSubject != null &&
        selectedChapter != null;
  }

  void _generateQuiz() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NCERTQuizLoaderPage(
          quizData: {
            'class': selectedClass!,
            'subject': selectedSubject!,
            'chapter': selectedChapter!,
          },
        ),
      ),
    );
  }
}
