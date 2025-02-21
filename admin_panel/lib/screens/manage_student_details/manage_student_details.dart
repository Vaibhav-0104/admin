import 'package:flutter/material.dart';

class StudentManagementScreen extends StatefulWidget {
  const StudentManagementScreen({super.key});

  @override
  State<StudentManagementScreen> createState() =>
      _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> {
  List<Map<String, dynamic>> students = [
    {
      'id': 'S101',
      'name': 'Aman Kumar',
      'class': '10th',
      'contact': '9876543210',
      'bus': 'Bus #5',
      'attendance': 'Present',
    },
    {
      'id': 'S102',
      'name': 'Priya Sharma',
      'class': '9th',
      'contact': '8765432109',
      'bus': 'Bus #3',
      'attendance': 'Absent',
    },
  ];

  void _addOrEditStudent({Map<String, dynamic>? student}) {
    final TextEditingController nameController = TextEditingController(
      text: student?['name'] ?? '',
    );
    final TextEditingController contactController = TextEditingController(
      text: student?['contact'] ?? '',
    );
    String selectedClass = student?['class'] ?? '10th';
    String selectedBus = student?['bus'] ?? 'Bus #1';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                student == null ? "Add Student" : "Edit Student",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedClass,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Class',
                ),
                items:
                    ['8th', '9th', '10th', '11th', '12th']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged:
                    (value) => setState(() => selectedClass = value ?? '10th'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedBus,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Assigned Bus',
                ),
                items:
                    ['Bus #1', 'Bus #2', 'Bus #3', 'Bus #4', 'Bus #5']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged:
                    (value) => setState(() => selectedBus = value ?? 'Bus #1'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  if (student == null) {
                    setState(() {
                      students.add({
                        'id': 'S${100 + students.length + 1}',
                        'name': nameController.text,
                        'class': selectedClass,
                        'contact': contactController.text,
                        'bus': selectedBus,
                        'attendance': 'Absent', // Default until face recognized
                      });
                    });
                  } else {
                    setState(() {
                      student['name'] = nameController.text;
                      student['class'] = selectedClass;
                      student['contact'] = contactController.text;
                      student['bus'] = selectedBus;
                    });
                  }
                  Navigator.pop(context);
                },
                child: Text(student == null ? "Add Student" : "Update Student"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteStudent(int index) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Confirm Delete"),
            content: const Text(
              "Are you sure you want to delete this student?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() => students.removeAt(index));
                  Navigator.pop(context);
                },
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }

  Color _attendanceColor(String status) =>
      status == 'Present' ? Colors.green : Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C5364),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Manage Student Details"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: _addOrEditStudent,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: students.length,
        itemBuilder: (_, index) {
          var student = students[index];
          return Card(
            color: const Color(0xFF203A43),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _attendanceColor(student['attendance']),
                child: Text(
                  student['name'][0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                student['name'],
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Class: ${student['class']}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "Contact: ${student['contact']}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "Bus: ${student['bus']}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "Attendance: ${student['attendance']}",
                    style: TextStyle(
                      color: _attendanceColor(student['attendance']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'edit') _addOrEditStudent(student: student);
                  if (value == 'delete') _deleteStudent(index);
                },
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(value: 'edit', child: Text("Edit")),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text("Delete"),
                      ),
                    ],
              ),
            ),
          );
        },
      ),
    );
  }
}
