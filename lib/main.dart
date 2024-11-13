  import 'package:cheese_shoppe/AddCheesePage.dart';
  import 'package:cheese_shoppe/CheeseDao.dart';
  import 'package:cheese_shoppe/Database.dart';
  import 'Cheese.dart';
  import 'package:flutter/material.dart';

  void main() async {

    // Run app as usual.
    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Cheese Factory',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Tony Soprano\' totally legitimate cheese shop'),
      );
    }
  }

  class MyHomePage extends StatefulWidget {
    const MyHomePage({super.key, required this.title});

    final String title;

    @override
    State<MyHomePage> createState() => _MyHomePageState();
  }

  class _MyHomePageState extends State<MyHomePage> {
    late AppDatabase database;
    late CheeseDao cheeseDao;
    List<Cheese> cheeses = [];

    Cheese? selectedCheese;

    @override
    void initState() {
     super.initState();
     initDB();
    }

    void initDB () async
    {
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


    // Big deal function that displays the entire she-bang with all the whistles
    // Heavily inspired by professor Ethan's teachings
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

    // This may, or may not have been inspired by monsieur
    // Ethan's teachings and his ways of casting spells
    Widget cheeseDetails() {
      return Column(
        children: [
          if (selectedCheese == null)
            const Text('Monsieur, please select un cheese from ze list, oui?', style: TextStyle(fontSize: 40))
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
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Icon(Icons.arrow_back, size: 20, color: Colors.black54), SizedBox(width: 5), Text('Back', style: TextStyle(fontSize: 14, fontFamily: 'Courier', color: Colors.black54, fontWeight: FontWeight.bold))]
                        ),
                      ),
                    )),
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
                                'Name: ${selectedCheese!.name}',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Courier'),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Origin: ${selectedCheese!.origin}',
                                style: const TextStyle(fontSize: 16, fontFamily: 'Courier'),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Aging Window: ${selectedCheese!.agingWindow}',
                                style: const TextStyle(fontSize: 16, fontFamily: 'Courier'),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Animals: ${selectedCheese!.animal}',
                                style: const TextStyle(fontSize: 16, fontFamily: 'Courier'),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Texture: ${selectedCheese!.texture}',
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
                          const Text(
                            "History",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Courier',
                            ),
                          ),
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
                            IconButton(onPressed: () {

                            }, icon: const Icon(Icons.edit, color: Colors.blue)),
                            IconButton(onPressed: () {
                              showDialog(context: context, builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Are you sure?'),
                                  content: const Text('This cheese seems yummy, is it in your heart to discard it?'),
                                  actions: <Widget>[
                                    TextButton(onPressed: () { Navigator.of(context).pop(); }, child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
                                    TextButton(onPressed: () async {
                                      cheeseDao.deleteCheese(selectedCheese!);
                                      Navigator.of(context).pop();
                                      var temp  = await cheeseDao.getAllCheeses();
                                      setState(() {
                                        cheeses = temp;
                                        selectedCheese = null;
                                      });
                                    }, child: const Text('Delete', style: TextStyle(color: Colors.red)))
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
      );
    }

    // I started off implementing the logic, but then gradually I GPT'd the styling to look like a criminal dossier, or a police file.
    Widget cheeseList() {
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


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.home),
          ),
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

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Congratulations, you have added a cheese')));
                    }
                  },
                icon: ClipOval(child: Image.asset('images/cheese-icon.jpeg', width: 36, height: 36, fit: BoxFit.cover)), label: const Text('Add cheese')),
              )

          ],

        ),
        body: reactiveCheeseLayout()
      );
    }
  }