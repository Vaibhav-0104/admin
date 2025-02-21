import 'package:flutter/material.dart';

class AllocateBusScreen extends StatefulWidget {
  const AllocateBusScreen({super.key});

  @override
  State<AllocateBusScreen> createState() => _AllocateBusScreenState();
}

class _AllocateBusScreenState extends State<AllocateBusScreen> {
  final List<Map<String, String>> students = [
    {'id': 'S101', 'name': 'Aman Kumar', 'bus': 'Bus 2'},
    {'id': 'S102', 'name': 'Priya Sharma', 'bus': 'Bus 1'},
    {'id': 'S103', 'name': 'Rohan Singh', 'bus': 'Bus 3'},
  ];

  final List<String> buses = ['Bus 1', 'Bus 2', 'Bus 3', 'Bus 4'];

  String? selectedStudentId;
  String studentName = '';
  String? selectedBus;
  String currentBus = '';

  void _saveBusAssignment() {
    if (selectedStudentId != null && selectedBus != null) {
      setState(() {
        final index = students.indexWhere((s) => s['id'] == selectedStudentId);
        if (index != -1) {
          students[index]['bus'] = selectedBus!;
          currentBus = selectedBus!;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Bus $selectedBus assigned to $studentName successfully!",
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select both Student and Bus."),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C5364),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Allocate Bus to Student"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Select Student ID"),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: _inputDecoration("Select Student ID"),
              value: selectedStudentId,
              items:
                  students
                      .map(
                        (student) => DropdownMenuItem(
                          value: student['id'],
                          child: Text("${student['id']} - ${student['name']}"),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  selectedStudentId = value;
                  final selectedStudent = students.firstWhere(
                    (s) => s['id'] == value,
                  );
                  studentName = selectedStudent['name']!;
                  currentBus = selectedStudent['bus'] ?? 'Not Assigned';
                  selectedBus = selectedStudent['bus'];
                });
              },
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Student Name"),
            const SizedBox(height: 10),
            TextFormField(
              readOnly: true,
              decoration: _inputDecoration(
                studentName.isEmpty ? "Student Name" : studentName,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Currently Assigned Bus"),
            const SizedBox(height: 10),
            TextFormField(
              readOnly: true,
              decoration: _inputDecoration(
                currentBus.isEmpty ? "Not Assigned" : currentBus,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Assign New Bus"),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: _inputDecoration("Select Bus"),
              value: selectedBus,
              items:
                  buses
                      .map(
                        (bus) => DropdownMenuItem(value: bus, child: Text(bus)),
                      )
                      .toList(),
              onChanged: (value) => setState(() => selectedBus = value),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size(180, 50),
                ),
                onPressed: _saveBusAssignment,
                icon: const Icon(Icons.save_alt),
                label: const Text(
                  "Save/Update Assignment",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("Assigned Bus List"),
            const SizedBox(height: 10),
            _buildBusAssignmentTable(),
          ],
        ),
      ),
    );
  }

  /// Input decoration styling
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black54),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  /// Section title with uniform style
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  /// Display table for showing assigned bus data
  Widget _buildBusAssignmentTable() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: DataTable(
        columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('Student ID')),
          DataColumn(label: Text('Student Name')),
          DataColumn(label: Text('Assigned Bus')),
        ],
        rows:
            students
                .map(
                  (student) => DataRow(
                    cells: [
                      DataCell(Text(student['id'] ?? '')),
                      DataCell(Text(student['name'] ?? '')),
                      DataCell(Text(student['bus'] ?? 'Not Assigned')),
                    ],
                  ),
                )
                .toList(),
      ),
    );
  }
}
