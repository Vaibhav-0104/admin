import 'package:flutter/material.dart';

class ManageBusDriverDetailsScreen extends StatefulWidget {
  const ManageBusDriverDetailsScreen({super.key});

  @override
  State<ManageBusDriverDetailsScreen> createState() =>
      _ManageBusDriverDetailsScreenState();
}

class _ManageBusDriverDetailsScreenState
    extends State<ManageBusDriverDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  String? _selectedBus;
  bool _isActive = true;
  int? _editingIndex;

  final List<String> _busList = ['Bus 101', 'Bus 202', 'Bus 303'];
  List<Map<String, dynamic>> _driverList = [];

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  void _addOrUpdateDriver() {
    if (_formKey.currentState!.validate()) {
      final driverDetails = {
        'id': _editingIndex ?? DateTime.now().millisecondsSinceEpoch,
        'name': _nameController.text,
        'contact': _contactController.text,
        'license': _licenseController.text,
        'assignedBus': _selectedBus ?? 'Not Assigned',
        'status': _isActive ? 'Active' : 'Inactive',
      };

      setState(() {
        if (_editingIndex == null) {
          _driverList.add(driverDetails);
          _showSnackBar('Driver added successfully!');
        } else {
          _driverList[_editingIndex!] = driverDetails;
          _showSnackBar('Driver updated successfully!');
          _editingIndex = null;
        }
        _clearForm();
      });
    }
  }

  void _editDriver(int index) {
    final driver = _driverList[index];
    setState(() {
      _nameController.text = driver['name'];
      _contactController.text = driver['contact'];
      _licenseController.text = driver['license'];
      _selectedBus = driver['assignedBus'];
      _isActive = driver['status'] == 'Active';
      _editingIndex = index;
    });
  }

  void _deleteDriver(int index) {
    setState(() {
      _driverList.removeAt(index);
      _showSnackBar('Driver deleted successfully!');
    });
  }

  void _clearForm() {
    _nameController.clear();
    _contactController.clear();
    _licenseController.clear();
    _selectedBus = null;
    _isActive = true;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C5364),
      appBar: AppBar(
        backgroundColor: const Color(0xFF203A43),
        title: const Text('Manage Bus Driver Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildFormCard(),
              const SizedBox(height: 30),
              _buildDriverTable(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('Driver Details Form'),
              const SizedBox(height: 16),
              _buildTextField(
                _nameController,
                'Full Name',
                Icons.person,
                'Enter full name',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _contactController,
                'Contact Number',
                Icons.phone,
                'Enter contact number',
                inputType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _licenseController,
                'License Number',
                Icons.credit_card,
                'Enter license number',
              ),
              const SizedBox(height: 16),
              _buildBusDropdown(),
              const SizedBox(height: 16),
              _buildStatusToggle(),
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDriverTable() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle('Driver Details List'),
            const SizedBox(height: 16),
            _driverList.isEmpty
                ? const Center(
                  child: Text(
                    'No driver details available!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                )
                : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Driver ID')),
                      DataColumn(label: Text('Full Name')),
                      DataColumn(label: Text('Contact Number')),
                      DataColumn(label: Text('License Number')),
                      DataColumn(label: Text('Assigned Bus')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows:
                        _driverList.asMap().entries.map((entry) {
                          int index = entry.key;
                          var driver = entry.value;
                          return DataRow(
                            cells: [
                              DataCell(Text(driver['id'].toString())),
                              DataCell(Text(driver['name'])),
                              DataCell(Text(driver['contact'])),
                              DataCell(Text(driver['license'])),
                              DataCell(Text(driver['assignedBus'])),
                              DataCell(Text(driver['status'])),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () => _editDriver(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _deleteDriver(index),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF203A43),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    String hint, {
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator:
          (value) =>
              value == null || value.isEmpty ? 'Please enter $label' : null,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildBusDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.directions_bus, color: Colors.teal),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelText: 'Assigned Bus',
      ),
      value: _selectedBus,
      items:
          _busList.map((bus) {
            return DropdownMenuItem(value: bus, child: Text(bus));
          }).toList(),
      onChanged: (value) => setState(() => _selectedBus = value),
      validator:
          (value) => value == null ? 'Please select an assigned bus' : null,
    );
  }

  Widget _buildStatusToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Driver Status:', style: TextStyle(fontSize: 18)),
        Row(
          children: [
            const Text('Inactive'),
            Switch(
              value: _isActive,
              activeColor: Colors.green,
              onChanged: (value) => setState(() => _isActive = value),
            ),
            const Text('Active'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: Icon(_editingIndex == null ? Icons.add : Icons.update),
          label: Text(_editingIndex == null ? 'Add Driver' : 'Update Driver'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: _addOrUpdateDriver,
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.clear),
          label: const Text('Clear'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueGrey,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: _clearForm,
        ),
      ],
    );
  }
}
