import 'package:flutter/material.dart';

class AddCheesePage extends StatelessWidget {
  late TextEditingController name;
  late TextEditingController origin;
  late TextEditingController history;
  late TextEditingController agingWindow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Cheese"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Name", border: OutlineInputBorder())
            ),
            const SizedBox(height: 16),
            TextField(
              controller: origin,
              decoration: const InputDecoration(labelText: "Origin", border: OutlineInputBorder())
            ),
            const SizedBox(height: 16),
            TextField(
              controller: agingWindow,
              decoration: const InputDecoration(labelText: "Aging Window", border: OutlineInputBorder())
            ),
            // Add more TextFields as needed for other properties...
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add functionality to save cheese data
              },
              child: const Text("Add Cheese"),
            ),
          ],
        ),
      ),
    );
  }
}
