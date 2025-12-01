import 'package:flutter/material.dart';
import 'package:travel_reimbursement/dashboard/service/reqservice.dart';
import 'package:travel_reimbursement/dashboard/model/travel_modelreq.dart';

class NewRequestForm extends StatefulWidget {
  @override
  State<NewRequestForm> createState() => _NewRequestFormState();
}

class _NewRequestFormState extends State<NewRequestForm> {
  final km = TextEditingController();
  final client = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
        
            TextField(
              controller: km,
              decoration: const InputDecoration(
                labelText: "KM",
                prefixIcon: Icon(Icons.route, color: Colors.teal),
              ),
              keyboardType: TextInputType.number,
            ),
        
            const SizedBox(height: 12),
        
            TextField(
              controller: client,
              decoration: const InputDecoration(
                labelText: "Client Name",
                prefixIcon: Icon(Icons.person, color: Colors.teal),
              ),
            ),
        
            const SizedBox(height: 20),
        
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (km.text.isEmpty || client.text.isEmpty) return;
        
                  await RequestService.addRequest(
                    TravelRequest(
                      km: km.text,
                      client: client.text,
                      status: "Pending",
                    ),
                  );
        
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.teal,
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
        
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
