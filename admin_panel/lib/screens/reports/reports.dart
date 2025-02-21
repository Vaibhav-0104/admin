import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedSemester = 'Semester 1';
  String selectedAttendanceReportType = 'Daily';
  DateTime? selectedDate;
  String selectedMonth = 'January';

  final List<String> semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
  ];
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2026),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _downloadReport(String type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$type Report Downloaded Successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C5364),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Reports"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Attendance Report"),
            const SizedBox(height: 10),
            _buildAttendanceReportSection(),
            const Divider(height: 40, thickness: 2, color: Colors.grey),
            _buildSectionTitle("Fees Collection Report"),
            const SizedBox(height: 10),
            _buildFeesReportSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildAttendanceReportSection() {
    return Card(
      color: const Color(0xFF2C5364),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Report Type:",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              value: selectedAttendanceReportType,
              items:
                  ['Daily', 'Monthly']
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
              onChanged:
                  (value) =>
                      setState(() => selectedAttendanceReportType = value!),
            ),
            const SizedBox(height: 15),
            if (selectedAttendanceReportType == 'Daily')
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: _pickDate,
                icon: const Icon(Icons.date_range),
                label: Text(
                  selectedDate == null
                      ? "Select Date"
                      : "Selected Date: ${selectedDate!.toLocal().toString().split(' ')[0]}",
                ),
              ),
            if (selectedAttendanceReportType == 'Monthly')
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                value: selectedMonth,
                items:
                    months
                        .map(
                          (month) => DropdownMenuItem(
                            value: month,
                            child: Text(month),
                          ),
                        )
                        .toList(),
                onChanged: (value) => setState(() => selectedMonth = value!),
              ),
            const SizedBox(height: 20),
            _buildDownloadButtons("Attendance"),
          ],
        ),
      ),
    );
  }

  Widget _buildFeesReportSection() {
    return Card(
      color: const Color(0xFF2C5364),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Semester:",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              value: selectedSemester,
              items:
                  semesters
                      .map(
                        (sem) => DropdownMenuItem(value: sem, child: Text(sem)),
                      )
                      .toList(),
              onChanged: (value) => setState(() => selectedSemester = value!),
            ),
            const SizedBox(height: 20),
            _buildDownloadButtons("Fees Collection"),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadButtons(String reportType) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const Size(140, 50),
          ),
          onPressed: () => _downloadReport("$reportType (PDF)"),
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text("Download PDF"),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(140, 50),
          ),
          onPressed: () => _downloadReport("$reportType (Excel)"),
          icon: const Icon(Icons.table_chart),
          label: const Text("Download Excel"),
        ),
      ],
    );
  }
}
