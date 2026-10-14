import 'package:flutter/material.dart';

class ServiceRequestScreen extends StatelessWidget {
  const ServiceRequestScreen({super.key, required this.requestId});
  final String requestId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Request')),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Service Request Details',
              style: TextStyle(fontSize: 22),
            ),

            const SizedBox(height: 16),

            Text(
              'Request ID: $requestId',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
