import 'package:flutter/material.dart';

class ManageBusDetailsScreen extends StatefulWidget {
  const ManageBusDetailsScreen({super.key});

  @override
  State<ManageBusDetailsScreen> createState() => _ManageBusDetailsScreenState();
}

class _ManageBusDetailsScreenState extends State<ManageBusDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _busNumberController = TextEditingController();
  final TextEditingController _routeController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();

  String? _selectedDriver;
  bool _isActive = true;
  int? _editingIndex;

  final List<String> _drivers = ['John Doe', 'Alice Smith', 'Bob Johnson'];

  List<Map<String, dynamic>> _busList = [];

  @override
  void dispose() {
    _busNumberController.dispose();
    _routeController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  void _addOrUpdateBus() {
    if (_formKey.currentState!.validate()) {
      final busDetails = {
        'id': _editingIndex ?? DateTime.now().millisecondsSinceEpoch,
        'busNumber': _busNumberController.text,
        'route': _routeController.text,
        'capacity': _capacityController.text,
        'driver': _selectedDriver,
        'status': _isActive ? 'Active' : 'Inactive',
      };

      setState(() {
        if (_editingIndex == null) {
          _busList.add(busDetails);
          _showSnackBar('Bus added successfully!');
        } else {
          _busList[_editingIndex!] = busDetails;
          _showSnackBar('Bus updated successfully!');
          _editingIndex = null;
        }
        _clearForm();
      });
    }
  }

  void _editBus(int index) {
    final bus = _busList[index];
    setState(() {
      _busNumberController.text = bus['busNumber'];
      _routeController.text = bus['route'];
      _capacityController.text = bus['capacity'];
      _selectedDriver = bus['driver'];
      _isActive = bus['status'] == 'Active';
      _editingIndex = index;
    });
  }

  void _deleteBus(int index) {
    setState(() {
      _busList.removeAt(index);
      _showSnackBar('Bus deleted successfully!');
    });
  }

  void _clearForm() {
    _busNumberController.clear();
    _routeController.clear();
    _capacityController.clear();
    _selectedDriver = null;
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
        title: const Text('Manage Bus Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildFormCard(),
              const SizedBox(height: 30),
              _buildBusTable(),
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
              _buildTitle('Bus Details Form'),
              const SizedBox(height: 16),
              _buildTextField(
                _busNumberController,
                'Bus Number',
                Icons.directions_bus,
                'Enter bus number',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _routeController,
                'Route',
                Icons.alt_route,
                'Enter route',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                _capacityController,
                'Capacity',
                Icons.people,
                'Enter capacity',
                inputType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildDropdown(),
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

  Widget _buildBusTable() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle('Bus Details List'),
            const SizedBox(height: 16),
            _busList.isEmpty
                ? const Center(
                  child: Text(
                    'No bus details available!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                )
                : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Bus ID')),
                      DataColumn(label: Text('Bus Number')),
                      DataColumn(label: Text('Route')),
                      DataColumn(label: Text('Capacity')),
                      DataColumn(label: Text('Driver')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows:
                        _busList.asMap().entries.map((entry) {
                          int index = entry.key;
                          var bus = entry.value;
                          return DataRow(
                            cells: [
                              DataCell(Text(bus['id'].toString())),
                              DataCell(Text(bus['busNumber'])),
                              DataCell(Text(bus['route'])),
                              DataCell(Text(bus['capacity'])),
                              DataCell(Text(bus['driver'] ?? '-')),
                              DataCell(Text(bus['status'])),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.orange,
                                      ),
                                      onPressed: () => _editBus(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _deleteBus(index),
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

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person, color: Colors.teal),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelText: 'Driver Name',
      ),
      value: _selectedDriver,
      items:
          _drivers.map((driver) {
            return DropdownMenuItem(value: driver, child: Text(driver));
          }).toList(),
      onChanged: (value) => setState(() => _selectedDriver = value),
      validator: (value) => value == null ? 'Please select a driver' : null,
    );
  }

  Widget _buildStatusToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Bus Status:', style: TextStyle(fontSize: 18)),
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
          label: Text(_editingIndex == null ? 'Add Bus' : 'Update Bus'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: _addOrUpdateBus,
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
