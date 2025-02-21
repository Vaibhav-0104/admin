import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageRouteBasedFeesScreen extends StatefulWidget {
  const ManageRouteBasedFeesScreen({super.key});

  @override
  State<ManageRouteBasedFeesScreen> createState() =>
      _ManageRouteBasedFeesScreenState();
}

class _ManageRouteBasedFeesScreenState
    extends State<ManageRouteBasedFeesScreen> {
  final List<Map<String, dynamic>> routes = [
    {
      'route': 'Route A',
      'students': ['Aman Kumar', 'Priya Sharma'],
      'fee': 5000,
    },
    {
      'route': 'Route B',
      'students': ['Rohan Singh', 'Sita Verma'],
      'fee': 6000,
    },
    {
      'route': 'Route C',
      'students': ['John Doe', 'Jane Smith'],
      'fee': 7000,
    },
  ];

  String? selectedRoute;
  List<String> studentsForRoute = [];
  final TextEditingController feeController = TextEditingController();
  bool isPaid = false;
  DateTime? paymentDate;
  String paymentMethod = 'UPI';

  Future<void> _pickPaymentDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024, 1),
      lastDate: DateTime(2025, 12),
    );
    if (pickedDate != null) {
      setState(() => paymentDate = pickedDate);
    }
  }

  void _sendPaymentReminder() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Payment reminder sent to all students in $selectedRoute ",
        ),
      ),
    );
  }

  void _downloadInvoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Invoice Downloaded Successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C5364),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Manage Fees by Route"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: 'Select Route',
                border: OutlineInputBorder(),
              ),
              items:
                  routes
                      .map(
                        (route) => DropdownMenuItem(
                          value: route['route'],
                          child: Text(route['route']),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  selectedRoute = value as String?;
                  var selected = routes.firstWhere((r) => r['route'] == value);
                  studentsForRoute = selected['students'];
                  feeController.text = selected['fee'].toString();
                });
              },
            ),
            const SizedBox(height: 15),
            Text(
              "👥 Students for $selectedRoute:",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...studentsForRoute.map(
              (student) => ListTile(
                leading: const Icon(Icons.person, color: Colors.white),
                title: Text(
                  student,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: feeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Fee Amount (₹)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Payment Status:",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Switch(
                  value: isPaid,
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.red,
                  onChanged: (value) => setState(() => isPaid = value),
                ),
                Text(
                  isPaid ? 'Paid' : 'Pending',
                  style: TextStyle(color: isPaid ? Colors.green : Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                    onPressed: _pickPaymentDate,
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      paymentDate == null
                          ? "Select Payment Date"
                          : "Date: ${DateFormat('dd-MM-yyyy').format(paymentDate!)}",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Payment Method',
              ),
              value: paymentMethod,
              items:
                  ['UPI', 'Credit/Debit Card', 'Net Banking']
                      .map(
                        (method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ),
                      )
                      .toList(),
              onChanged:
                  (value) => setState(() => paymentMethod = value ?? 'UPI'),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(150, 50),
                  ),
                  onPressed: _downloadInvoice,
                  icon: const Icon(Icons.file_download),
                  label: const Text("Download Invoice"),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    minimumSize: const Size(150, 50),
                  ),
                  onPressed: _sendPaymentReminder,
                  icon: const Icon(Icons.notifications),
                  label: const Text("Send Reminder"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
