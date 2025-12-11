

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Replace this with your actual provider import
// import 'package:travel_reimbursement/dashboard/controller/reqst_create_provider.dart';

class NewRequestForm extends StatefulWidget {
  const NewRequestForm({super.key});

  @override
  State<NewRequestForm> createState() => _NewRequestFormState();
}

class _NewRequestFormState extends State<NewRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: SafeArea(
              child: Material(
                color: Colors.transparent,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 40),
                          const Text(
                            "New Travel Request",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Client Name Field
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "Client Name",
                          prefixIcon: Icon(Icons.person, color: Colors.teal),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter client name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      
                      // KM Field
                      TextFormField(
                        controller: _kmController,
                        decoration: const InputDecoration(
                          labelText: "KM",
                          prefixIcon: Icon(Icons.route, color: Colors.teal),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter KM';
                          }
                          final km = int.tryParse(value.trim());
                          if (km == null || km <= 0) {
                            return 'Please enter a valid KM value';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      
                      // Submit Button
                      Consumer<dynamic>(
                        builder: (context, provider, child) {
                          final isLoading = false; // Replace with: provider.isLoading
                          
                          return ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      final km = int.parse(_kmController.text.trim());
                                      
                                      // Call your provider method here
                                      // final success = await provider.addRequest(
                                      //   _nameController.text.trim(),
                                      //   km,
                                      // );
                                      
                                      // Handle success/error
                                      if (!context.mounted) return;
                                      
                                      // if (success) {
                                      //   Navigator.pop(context);
                                      //   ScaffoldMessenger.of(context).showSnackBar(
                                      //     const SnackBar(
                                      //       content: Text("Request added successfully!"),
                                      //       backgroundColor: Colors.green,
                                      //     ),
                                      //   );
                                      // } else {
                                      //   ScaffoldMessenger.of(context).showSnackBar(
                                      //     SnackBar(
                                      //       content: Text(provider.error ?? "Something went wrong"),
                                      //       backgroundColor: Colors.red,
                                      //     ),
                                      //   );
                                      // }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Submit Request",
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _kmController.dispose();
    super.dispose();
  }
}

// If you're calling this from a showModalBottomSheet, use it like this:
void showNewRequestForm(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const NewRequestForm(),
  );
}