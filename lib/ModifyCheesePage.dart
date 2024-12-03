import 'package:cheese_shoppe/AppLocalizations.dart';
import 'package:cheese_shoppe/Cheese.dart';
import 'package:cheese_shoppe/CheeseDao.dart';
import 'package:flutter/material.dart';

/// A page that allows the user to modify the details of an existing cheese.
/// It displays a form with pre-filled information of the selected cheese.
/// The user is supposed to modify
class ModifyCheesePage extends StatefulWidget {
  const ModifyCheesePage({super.key, required this.cheeseDao, required this.selectedCheese});
  final Cheese selectedCheese;
  final CheeseDao cheeseDao;

  @override
  State<ModifyCheesePage> createState() => _ModifyCheesePageState();
}

class _ModifyCheesePageState extends State<ModifyCheesePage> {
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
    // this way, the controllers are loaded with data already there.
    name = TextEditingController(text: widget.selectedCheese.name);
    origin = TextEditingController(text: widget.selectedCheese.origin);
    agingWindow = TextEditingController(text: widget.selectedCheese.agingWindow);
    animal = TextEditingController(text: widget.selectedCheese.animal);
    texture = TextEditingController(text: widget.selectedCheese.texture);
    flavorProfile = TextEditingController(text: widget.selectedCheese.flavorProfile);
    usage = TextEditingController(text: widget.selectedCheese.usage);
    history = TextEditingController(text: widget.selectedCheese.history);
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

  void tryModifyingCheese() async {

    Cheese modifiedCheese = widget.selectedCheese;


    if (name.text.isNotEmpty) { modifiedCheese.name = name.text; }
    if (origin.text.isNotEmpty) { modifiedCheese.origin = origin.text; }
    if (agingWindow.text.isNotEmpty) { modifiedCheese.agingWindow = agingWindow.text; }
    if (animal.text.isNotEmpty) { modifiedCheese.animal = animal.text; }
    if (texture.text.isNotEmpty) { modifiedCheese.texture = texture.text; }
    if (flavorProfile.text.isNotEmpty) { modifiedCheese.flavorProfile = flavorProfile.text; }
    if (usage.text.isNotEmpty) { modifiedCheese.usage = usage.text; }
    if (history.text.isNotEmpty) { modifiedCheese.history = history.text; }
    int result = await widget.cheeseDao.updateCheese(modifiedCheese);

    if (result > 0) {
      Navigator.pop(context, true);
    }

    else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: Cheese could not be modified.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate("modifyCheese")!),
        leading: IconButton(onPressed: () {
          Navigator.pop(context, false);
        }, icon: const Icon(Icons.arrow_back))
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: name, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate("name"), border: const OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: origin, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate("origin"), border: const OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: agingWindow, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate("agingWindow"), border: const OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: animal, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate("animalMilked"), border: const OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: flavorProfile, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate("tasteLike"), border: const OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: texture, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate("textureLike"), border: const OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: usage, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate("usages"), border: const OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: history, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate("story"), border: const OutlineInputBorder())),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: tryModifyingCheese,
              child: Text(AppLocalizations.of(context)!.translate("modify")!),
            ),
          ],
        ),
      ),
    );
  }
}