import 'package:flutter/material.dart';

class ManageNotificationScreen extends StatefulWidget {
  const ManageNotificationScreen({super.key});

  @override
  State<ManageNotificationScreen> createState() =>
      _ManageNotificationScreenState();
}

class _ManageNotificationScreenState extends State<ManageNotificationScreen> {
  final List<String> notificationTypes = [
    'Emergency',
    'College Holiday',
    'Festival Greetings',
  ];

  final List<String> recipients = ['Students', 'Drivers', 'Both'];

  String? selectedNotificationType;
  List<String> selectedRecipients = [];
  final TextEditingController messageController = TextEditingController();

  void _sendNotification() {
    if (selectedNotificationType == null ||
        selectedRecipients.isEmpty ||
        messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the fields before sending."),
        ),
      );
      return;
    }

    // Simulate FCM integration for now
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${selectedNotificationType!} notification sent to ${selectedRecipients.join(', ')}.",
        ),
      ),
    );

    // Reset fields after sending
    setState(() {
      selectedNotificationType = null;
      selectedRecipients.clear();
      messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C5364),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 189, 189, 189),
        elevation: 0,
        title: const Text("Manage Notifications"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Notification Type',
                  border: OutlineInputBorder(),
                ),
                value: selectedNotificationType,
                items:
                    notificationTypes
                        .map(
                          (type) =>
                              DropdownMenuItem(value: type, child: Text(type)),
                        )
                        .toList(),
                onChanged:
                    (value) => setState(() => selectedNotificationType = value),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: messageController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Message Content',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Select Recipients:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Wrap(
                spacing: 10,
                children:
                    recipients.map((recipient) {
                      return FilterChip(
                        label: Text(recipient),
                        selected: selectedRecipients.contains(recipient),
                        onSelected: (isSelected) {
                          setState(() {
                            isSelected
                                ? selectedRecipients.add(recipient)
                                : selectedRecipients.remove(recipient);
                          });
                        },
                      );
                    }).toList(),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _sendNotification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: const Size(200, 50),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: const Icon(Icons.send),
                  label: const Text("Send Notification"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
