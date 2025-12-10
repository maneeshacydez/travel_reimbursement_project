import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_reimbursement/dashboard/controller/new_req_provider.dart';

class NewRequestForm extends StatefulWidget {
  @override
  State<NewRequestForm> createState() => _NewRequestFormState();
}

class _NewRequestFormState extends State<NewRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _kmController = TextEditingController();
  final _clientController = TextEditingController();

  @override
  void dispose() {
    _kmController.dispose();
    _clientController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final km = double.tryParse(_kmController.text.trim()) ?? 0.0;
    final clientName = _clientController.text.trim();

    if (km <= 0) {
      _showSnackBar('Please enter a valid KM value', isError: true);
      return;
    }

    // Get the provider from context
    final provider = context.read<ReqstCreateProvider>();

    try {
      await provider.createRequest(
        name: clientName,
        km: km,
        status: 'pending',
      );

      if (!mounted) return;

      if (provider.error == null) {
        _showSnackBar('Travel request created successfully!', isError: false);
        Navigator.pop(context, true); // Return success to refresh the list
      } else {
        _showSnackBar('Error: ${provider.error}', isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Failed to create request: $e', isError: true);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }
@override
Widget build(BuildContext context) {
  return Consumer<ReqstCreateProvider>(
    builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // handle
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 10),

                const Text(
                  "New Travel Request",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _kmController,
                        decoration: const InputDecoration(
                          labelText: "KM",
                          prefixIcon: Icon(Icons.route, color: Colors.teal),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter KM';
                          }
                          final km = double.tryParse(value);
                          if (km == null || km <= 0) {
                            return 'Please enter a valid KM';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _clientController,
                        decoration: const InputDecoration(
                          labelText: "Client Name",
                          prefixIcon: Icon(Icons.person, color: Colors.teal),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter client name';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: provider.isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.teal,
                    ),
                    child: provider.isLoading
                        ? CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            "Submit",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                  ),
                ),

                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    },
  );
}
}