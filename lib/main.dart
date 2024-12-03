// Pages
import 'package:cheese_shoppe/AddCheesePage.dart';
import 'package:cheese_shoppe/ModifyCheesePage.dart';

// DAO and DB
import 'package:cheese_shoppe/CheeseDao.dart';
import 'package:cheese_shoppe/Database.dart';

// Model
import 'Cheese.dart';

// Extra
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cheese_shoppe/AppLocalizations.dart';

  /// Initialises and runs the application
  void main() {

    // Run app as usual.
    runApp(const MyApp());
  }

  /// Main application widget.
  /// Handles localization for the app
  class MyApp extends StatefulWidget {
    const MyApp({super.key});

    /// Sets a new Locale for the app, updating the UI
    static void setLocale(BuildContext context, Locale newLocale) async {
      _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
      state?.changeLanguage(newLocale);
    }

    @override
    State<StatefulWidget> createState() { return _MyAppState(); }
  }

  /// State class for MyApp. Manages the current Locale
  class _MyAppState extends State<MyApp> {
    /// Current Locale of the app. Default is UK English.
    var _locale = const Locale('en', 'GB');

    /// Updates the locale and triggers a rebuild of the UI to reflect the new language.
    void changeLanguage(Locale newLocale) {
      setState(() {
        _locale = newLocale;
      });
    }

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
          supportedLocales: const [Locale('en', 'GB'), Locale('fr', 'FR')],
          localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, AppLocalizations.delegate],
          locale: _locale,
          title: 'Tony Soprano\'s cheese archives',
          theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange), useMaterial3: true),
          home: const MyHomePage(title: 'Tony Soprano\'s cheese archives'),
        );
  }
  }

  /// Home page widget for the app
  class MyHomePage extends StatefulWidget {
    const MyHomePage({super.key, required this.title});

    /// Title of the home page
    final String title;

    @override
    State<MyHomePage> createState() => _MyHomePageState();
  }

  /// State class for MyHomePage
  /// Manages the list of cheese and interactions with the DB.
  /// The heart of the application.
  class _MyHomePageState extends State<MyHomePage> {
    /// DB instance
    late AppDatabase database;
    /// DAO for cheesy operations
    late CheeseDao cheeseDao;
    /// List of cheeses to stuff the cheeses found in the the DB
    List<Cheese> cheeses = [];

    /// Current cheese, if any
    Cheese? selectedCheese;

    @override
    void initState() {
     super.initState();
     initDB();
    }

    /// Initializes the database connection and retrieves the list of cheeses to the cheese list.
    void initDB () async {
      database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
      cheeseDao = database.cheeseDao;

      // Clever
      var temp  = await cheeseDao.getAllCheeses();
      setState(() {
        cheeses = temp;
      });
    }

    @override
    void dispose() {
      super.dispose();
    }

    /// Builds the main layout dynamically based on screen size and orientation.
    /// Returns a single column is the screen is not wide enough, or the list with
    /// the cheese details for a wider screen
    Widget reactiveCheeseLayout() {
      var size = MediaQuery.of(context).size;
      var height = size.height;
      var width = size.width;

      if ((width > height) && (width > 720)) {
        return Row(
          children: [
            Expanded(flex: 1, child: cheeseList()),
            Expanded(flex: 3, child: cheeseDetails())
          ]);
      } else {
        if (selectedCheese == null) {
          return cheeseList();
        } else {
          return cheeseDetails();
        }
      }
    }

    /// Displays detailed information about the selected cheese
    /// If user clicks to go back or else, then display text prompting user to select a text.
    Widget cheeseDetails() {
      return SingleChildScrollView( // Wrap everything in a SingleChildScrollView
        child: Column(
            children: [
              if (selectedCheese == null)
                Text(AppLocalizations.of(context)!.translate("pleaseSelectCheese")!, style: const TextStyle(fontSize: 40))
              else
              // Yes, I GPT'd this part. The styling, to be precise. This sincerely feels like Nietzsche's concept of the abyss.
              // I try not to look at it too much, or it looks back
              // at me.
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedCheese = null;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(5), boxShadow: [
                                  BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 3, offset: const Offset(1, 1))]),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [const Icon(Icons.arrow_back, size: 20, color: Colors.black54), const SizedBox(width: 5), Text(AppLocalizations.of(context)!.translate("back")!, style: const TextStyle(fontSize: 14, fontFamily: 'Courier', color: Colors.black54, fontWeight: FontWeight.bold))]
                                ),
                              )),
                        ),
                      ),
                      // Main Info Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Left Side: Details
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2)),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context)!.translate("name")!}: ${selectedCheese!.name}',
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Courier'),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${AppLocalizations.of(context)!.translate("origin")}: ${selectedCheese!.origin}',
                                    style: const TextStyle(fontSize: 16, fontFamily: 'Courier'),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${AppLocalizations.of(context)!.translate("agingWindow")}: ${selectedCheese!.agingWindow}',
                                    style: const TextStyle(fontSize: 16, fontFamily: 'Courier'),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${AppLocalizations.of(context)!.translate("animals")}: ${selectedCheese!.animal}',
                                    style: const TextStyle(fontSize: 16, fontFamily: 'Courier'),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${AppLocalizations.of(context)!.translate("texture")}: ${selectedCheese!.texture}',
                                    style: const TextStyle(fontSize: 16, fontFamily: 'Courier'),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Right Side: Image
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[600]!, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.asset(
                                  selectedCheese!.imagePath,
                                  width: 150, // adjust width based on your layout
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // History Section
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 3,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context)!.translate("history")!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Courier')),
                              const SizedBox(height: 10),
                              Text(
                                selectedCheese!.history,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Courier',
                                  color: Colors.grey[700],
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(onPressed: () async {
                                final isCheeseModified = await Navigator.push(context, MaterialPageRoute(builder: (context) => ModifyCheesePage(cheeseDao: cheeseDao, selectedCheese: selectedCheese!)));
                                if (isCheeseModified) {
                                  var temp = await cheeseDao.getAllCheeses();
                                  setState(() {
                                    cheeses = temp;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.translate("congratulationsMessage")!)));
                                }
                              }, icon: const Icon(Icons.edit, color: Colors.blue)),
                              IconButton(onPressed: () {
                                showDialog(context: context, builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(AppLocalizations.of(context)!.translate("areYouSure")!),
                                    content: Text(AppLocalizations.of(context)!.translate("deleteWarning")!),
                                    actions: <Widget>[
                                      TextButton(onPressed: () { Navigator.of(context).pop(); }, child: Text(AppLocalizations.of(context)!.translate("cancel")!, style: const TextStyle(color: Colors.grey))),
                                      TextButton(onPressed: () async {
                                        cheeseDao.deleteCheese(selectedCheese!);
                                        Navigator.of(context).pop();
                                        var temp  = await cheeseDao.getAllCheeses();
                                        setState(() {
                                          cheeses = temp;
                                          selectedCheese = null;
                                        });
                                      }, child: Text(AppLocalizations.of(context)!.translate("delete")!, style: const TextStyle(color: Colors.red)))
                                    ],
                                  );
                                });
                              }, icon: const Icon(Icons.delete, color: Colors.red))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
            ]
        ),
      );
    }


    /// Display a list of cheeses with selectable cards
    /// Each cheese is displayed with its name and image
    /// Selecting a cheese updates selectedCheese and refreshes the UI, triggering
    /// cheeseDetails to show detailed cheese information when tapped
    Widget cheeseList() {
      // I started off implementing the logic, but then gradually I GPT'd the styling to look like a criminal dossier, or a police file.
      return Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Cheese List
            Expanded(
              child: ListView.builder(
                itemCount: cheeses.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCheese = cheeses[index];
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!), boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 3, offset: const Offset(0, 2))]),
                      child: Row(
                        children: [
                          // Display cheese image using imagePath property
                          Image.asset(cheeses[index].imagePath, width: 24, height: 24, fit: BoxFit.cover),
                          const SizedBox(width: 12),
                          Expanded(child: Text(cheeses[index].name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Courier')))
                        ]
                      )
                    )
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    /// Builds the UI, including an AppBar with action buttons
    /// and the dynamic body using the dynamicCheeseLayout().
    /// feeds on cheese data.
    /// The AppBar contains a button to add cheeses, and two buttons for changing language; one for
    /// English, and another one for French.
    @override
    Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0), // Add padding as needed
              child: TextButton.icon(
                onPressed: () async {
                    final isCheeseAdded = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddCheesePage(cheeseDao: cheeseDao)));
                    if (isCheeseAdded) {
                      var temp  = await cheeseDao.getAllCheeses();
                      setState(() {
                        cheeses = temp;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.translate( "congratulationsMessage")!)));
                    }

                    else {

                    }
                  },
                icon: ClipOval(child: Container(width: 36, height: 36, color: Colors.grey[200], child: const Icon(Icons.add, size: 24, color: Colors.black))), label: Text(AppLocalizations.of(context)!.translate("addCheese")!),
              )),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: IconButton(onPressed: () {
                    MyApp.setLocale(context, const Locale('en', 'GB'));
                }, icon: ClipOval(child: Image.asset('images/british-flag.jpeg', fit: BoxFit.cover, width: 36, height: 36)))),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: IconButton(onPressed: () {
              MyApp.setLocale(context, const Locale('fr', 'FR'));
            }, icon: ClipOval(child: Image.asset('images/french-flag.jpeg', fit: BoxFit.cover, width: 36, height: 36))))

          ],

        ),
        body: reactiveCheeseLayout()
      );
    }
  }