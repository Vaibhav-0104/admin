import 'package:flutter/material.dart';

class ViewStudentAttendance extends StatefulWidget {
  const ViewStudentAttendance({super.key});

  @override
  State<ViewStudentAttendance> createState() => _ViewStudentAttendanceState();
}

class _ViewStudentAttendanceState extends State<ViewStudentAttendance> {
  DateTime? selectedDate;
  String? selectedBus;
  final List<String> busNumbers = ['Bus 1', 'Bus 2', 'Bus 3', 'Bus 4'];

  // Sample student attendance data
  final List<Map<String, dynamic>> studentAttendanceList = [
    {"name": "Aman Sharma", "status": "Present"},
    {"name": "Priya Verma", "status": "Absent"},
    {"name": "Rohan Mehta", "status": "Present"},
    {"name": "Kavya Iyer", "status": "Present"},
    {"name": "Arjun Patel", "status": "Absent"},
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _attendanceStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status == 'Present' ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C5364),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("View Student Attendance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Select Date"),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () => _selectDate(context),
              icon: const Icon(Icons.calendar_today),
              label: Text(
                selectedDate == null
                    ? "Select Date"
                    : "Selected Date: ${selectedDate!.toLocal().toString().split(' ')[0]}",
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Select Bus Number"),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              value: selectedBus,
              hint: const Text("Choose Bus Number"),
              items:
                  busNumbers
                      .map(
                        (bus) => DropdownMenuItem(value: bus, child: Text(bus)),
                      )
                      .toList(),
              onChanged: (value) => setState(() => selectedBus = value),
            ),
            const SizedBox(height: 30),
            _buildSectionTitle("Student Attendance List"),
            const SizedBox(height: 10),
            Expanded(
              child:
                  selectedBus == null || selectedDate == null
                      ? const Center(
                        child: Text(
                          "Please select both date and bus number to view attendance.",
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                      : ListView.builder(
                        itemCount: studentAttendanceList.length,
                        itemBuilder: (context, index) {
                          final student = studentAttendanceList[index];
                          return Card(
                            color: const Color(0xFF2C5364),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal,
                                child: Text(
                                  student["name"][0],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                student["name"],
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: _attendanceStatusChip(
                                student["status"],
                              ),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
