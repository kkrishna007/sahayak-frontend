import 'package:flutter/material.dart';

class AttendanceTakerPage extends StatefulWidget {
  const AttendanceTakerPage({super.key});

  @override
  State<AttendanceTakerPage> createState() => _AttendanceTakerPageState();
}

class _AttendanceTakerPageState extends State<AttendanceTakerPage> {
  bool _imageCaptured = false;
  bool _isLoading = false;
  bool _showResults = false;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = "${now.day}/${now.month}/${now.year}";
    final formattedTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Taker'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Date: $formattedDate',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Time: $formattedTime',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: _imageCaptured
                          ? Stack(
                              children: [
                                // Simulated blurred image
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade400,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.image,
                                        size: 120, color: Colors.white30),
                                  ),
                                ),
                                if (_isLoading)
                                  Container(
                                    color: Colors.black.withOpacity(0.4),
                                    child: const Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircularProgressIndicator(
                                              color: Color(0xFF4CAF50)),
                                          SizedBox(height: 16),
                                          Text('Analysing attendance...',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          : const Center(
                              child: Icon(Icons.camera_alt,
                                  size: 120, color: Colors.grey),
                            ),
                    ),
                    if (!_imageCaptured && !_isLoading)
                      Positioned(
                        bottom: 32,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(24),
                          ),
                          child: const Icon(Icons.camera,
                              size: 32, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _imageCaptured = true;
                              _isLoading = true;
                            });
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                _isLoading = false;
                                _showResults = true;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AttendanceResultsPage(),
                                ),
                              );
                            });
                          },
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
}

class AttendanceResultsPage extends StatelessWidget {
  const AttendanceResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Results'),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Attendance Table',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Student Name')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('Rahul Sharma')),
                      DataCell(Text('Present'))
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Priya Patel')),
                      DataCell(Text('Absent'))
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Amit Kumar')),
                      DataCell(Text('Present'))
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Sneha Singh')),
                      DataCell(Text('Present'))
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Vikram Verma')),
                      DataCell(Text('Absent'))
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.image),
                label: const Text('Check Output Image'),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Processed Image'),
                      content: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Text('Processed image with facetags',
                              style: TextStyle(color: Colors.black54)),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
