import 'package:cheese_shoppe/Cheese.dart';
import 'package:cheese_shoppe/CheeseDao.dart';
import 'package:flutter/material.dart';
import 'package:cheese_shoppe/CheeseDao.dart';
class AddCheesePage extends StatefulWidget {
  final CheeseDao cheeseDao;

  AddCheesePage({super.key, required this.cheeseDao});
  @override
  AddCheesePageState createState() => AddCheesePageState();
}

class AddCheesePageState extends State<AddCheesePage> {
  // Initialize the TextEditingController variables
  late TextEditingController name;
  late TextEditingController origin;
  late TextEditingController agingWindow;
  late TextEditingController animal;
  late TextEditingController texture;
  late TextEditingController flavorProfile;
  late TextEditingController usage;
  late TextEditingController history;

  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    origin = TextEditingController();
    agingWindow = TextEditingController();
    animal = TextEditingController();
    texture = TextEditingController();
    flavorProfile = TextEditingController();
    usage = TextEditingController();
    history = TextEditingController();
  }

  @override
  void dispose() {
    name.dispose();
    origin.dispose();
    agingWindow.dispose();
    animal.dispose();
    texture.dispose();
    flavorProfile.dispose();
    usage.dispose();
    history.dispose();
    super.dispose();
  }

  void tryInsertingCheese() async {
    int result = await widget.cheeseDao.insertCheese(Cheese(name: name.text, origin: origin.text, agingWindow: agingWindow.text, animal: animal.text, traditionallyRaw: true, flavorProfile: flavorProfile.text, texture: texture.text, usage: usage.text, history: history.text, imagePath: 'images/cheese-icon.jpeg'));
    if (result > 0) {
      Navigator.pop(context, true);
    }

    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Cheese could not be added.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new cheese"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: "Name", border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: origin, decoration: const InputDecoration(labelText: "Origin", border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: agingWindow, decoration: const InputDecoration(labelText: "Do inform us of the aging Window", border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: animal, decoration: const InputDecoration(labelText: "What animal did you milk?", border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: flavorProfile, decoration: const InputDecoration(labelText: "Tell us what does your cheese taste like", border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: texture, decoration: const InputDecoration(labelText: "Please inform us of this cheese's texture", border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: usage, decoration: const InputDecoration(labelText: "Uses for this cheese that you can think of, old chap", border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: history, decoration: const InputDecoration(labelText: "Please inform us of the history behind this cheese", border: OutlineInputBorder())),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: tryInsertingCheese,
              child: const Text("Add Cheese"),
            ),
          ],
        ),
      ),
    );
  }
}
