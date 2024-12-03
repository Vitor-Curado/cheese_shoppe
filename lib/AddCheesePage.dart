import 'package:cheese_shoppe/AppLocalizations.dart';
import 'package:cheese_shoppe/Cheese.dart';
import 'package:cheese_shoppe/CheeseDao.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/material.dart';
import 'package:cheese_shoppe/CheeseDao.dart';

/// A stateful widget that provides a page for adding a new cheese to the system.
/// Allows the user to input name, origin, aging window, and more. The data is then
/// inserted into the cheese DB using the cheeseDAO
class AddCheesePage extends StatefulWidget {
  /// The cheeseDAO object used to interact with the dedicated cheese database
  final CheeseDao cheeseDao;

  /// Creates an instance of AddCheesePage. The cheeseDAO is required for DB operations.
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

  late EncryptedSharedPreferences preferences;

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

  /// failed attempt at setting up Encrypted shared preferences to preload
  /// data, were the user to fill the rows, and leave the session, coming back later
  void initialisePreferences() async {
    preferences = await EncryptedSharedPreferences.getInstance();
    String encryptionKey = '12345';

    // Load. If empty, load empty string.
    name.text = await preferences.getString('name') ?? '';
    origin.text = await preferences.getString('origin') ?? '';
    agingWindow.text = await preferences.getString('agingWindow') ?? '';
    animal.text = await preferences.getString('animal') ?? '';
    texture.text = await preferences.getString('texture') ?? '';
    flavorProfile.text = await preferences.getString('flavorProfile') ?? '';
    usage.text = await preferences.getString('usage') ?? '';
    history.text = await preferences.getString('history') ?? '';

    addListeners();
  }

  /// Helper function for paying attention to TextEditingControllers and pairing
  /// the preference data with the controllers. Not working well.
  void addListeners() {
    name.addListener(() async => await preferences.setString('name', name.text));
    origin.addListener(() async => await preferences.setString('origin', origin.text));
    agingWindow.addListener(() async => await preferences.setString('agingWindow', agingWindow.text));
    animal.addListener(() async => await preferences.setString('animal', animal.text));
    texture.addListener(() async => await preferences.setString('texture', texture.text));
    flavorProfile.addListener(() async => await preferences.setString('flavorProfile', flavorProfile.text));
    usage.addListener(() async => await preferences.setString('usage', usage.text));
    history.addListener(() async => await preferences.setString('history', history.text));
  }

  /// Attempts to insert a new cheese into the DB.
  /// if successful, leads user back to main page, displaying a message
  /// everything went well. If not, it doesn't go back, and it shows a SnackBar
  /// with an error message.
  void tryInsertingCheese() async {
    int result = await widget.cheeseDao.insertCheese(Cheese(name: name.text, origin: origin.text, agingWindow: agingWindow.text, animal: animal.text, traditionallyRaw: true, flavorProfile: flavorProfile.text, texture: texture.text, usage: usage.text, history: history.text, imagePath: 'images/cheese-icon.jpeg'));
    if (result > 0) {
      Navigator.pop(context, true);
    }

    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.translate('error')!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate("addNewCheese")!),
        leading: IconButton(onPressed: () { Navigator.pop(context, false); }, icon: const Icon(Icons.arrow_back))
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: name, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate("name")!, border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: origin, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate("origin")!, border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: agingWindow, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate("agingWindow")!, border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: animal, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate("animalMilked")!, border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: flavorProfile, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate("tasteLike")!, border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: texture, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate("textureLike")!, border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: usage, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate("usages")!, border: OutlineInputBorder())),
            const SizedBox(height: 16),
            TextField(controller: history, decoration: InputDecoration(labelText: AppLocalizations.of(context)!.translate("story")!, border: OutlineInputBorder())),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: tryInsertingCheese,
              child: Text(AppLocalizations.of(context)!.translate("add")!),
            ),
          ],
        ),
      ),
    );
  }
}
