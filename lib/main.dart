import 'package:cheese_shoppe/AddCheesePage.dart';
import 'package:flutter/material.dart';

// BOTH are necessary. It's a story, really.
// It all started with my loadCheeses() not working.
// That's where the error came from.
// Apparently, it's a problem related to flutter, not me.
// At first, I used the ffi only, but since I'm running my application
// on edge, I had to have the ffi_web version alongside the standard FFI one
// then, there was another problem, SW related, and I had to go to this
// website: https://github.com/tekartik/sqflite/tree/master/packages_web/sqflite_common_ffi_web#setup-binaries
// to fix the something worker related. DB something ...
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

// my stuff
import 'cheese.dart';


void main() async {
  // Initialise the database factory
  // DON'T touch it.
  databaseFactory = databaseFactoryFfiWeb;

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
      home: const MyHomePage(title: 'We Do Funny Things'),
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
  List<Cheese> cheeses = [
    Cheese(id: 1, name: 'Parmigiano Reggiano', origin: 'Emilia-Romagna and Lombardy, Italy', agingWindow: '12-36', animal: ['Cow'], traditionallyRaw: true, flavorProfile: ['Nutty', 'savory'], texture: ['Hard', 'granular'], usage: ['grated on pasta', 'risottos', 'cheese boards'], history: 'Parmigiano Reggiano has a rich history dating back to the Middle Ages, with its origins traceable to the 12th century. The cheese was first produced by Benedictine monks in the Emilia-Romagna region of Italy. They aimed to create a long-lasting cheese that could be easily transported and stored.\n\nThe name \"Parmigiano Reggiano\" is protected under European law and is classified as a Protected Designation of Origin (PDO) product. This designation ensures that only cheese produced in certain areas, following specific traditional methods, can bear the name. The regions that can produce Parmigiano Reggiano include Parma, Reggio Emilia, Modena, Bologna (to the west of the Reno River), and Mantua (to the south of the Po River).\n\nHistorically, Parmigiano Reggiano was popular among nobility and was often referred to as the \"king of cheeses.\" Its reputation grew throughout Italy and eventually around the world. The production process is still strictly regulated, and each wheel is carefully monitored for quality. After aging, each cheese wheel is inspected, and those that meet the stringent quality standards are branded with a unique mark, ensuring authenticity.\n\nToday, Parmigiano Reggiano remains a staple in Italian cuisine and is highly regarded globally, valued for its complex flavour, versatility in cooking, and the artisanal craftsmanship behind its production.', imagePath: 'images/parmigiano-reggiano.jpeg'),
    Cheese(id: 2, name: 'Cheddar', origin: 'Somerset, England', agingWindow: '3-24', animal: ['cow'], traditionallyRaw: false, flavorProfile: ['Sharp', 'nutty'], texture: ['Hard'], usage: ['sandwiches', 'soups', 'snack'], history: 'Cheddar cheese has a rich history that dates back to the 12th century, originating from the village of Cheddar in Somerset, England. According to legend, the cheese was discovered when a milkmaid accidentally left milk in a cave, and it curdled due to the natural bacteria present in the cave. The resulting cheese was found to have a unique flavour and texture, leading to the development of what we now know as cheddar.\n\nBy the 16th century, Cheddar cheese was being produced in larger quantities and became widely popular across England. The cheese was originally made in large rounds, and its production spread throughout the country, with various regions developing their own styles and characteristics.\n\nCheddar\'s popularity continued to grow, and by the 19th century, it was being produced in various regions of the world, including the United States, Canada, and Australia. The cheese became known for its distinctive sharp flavour and crumbly texture, and it has since evolved into many varieties, including mild, sharp, extra sharp, and even flavoured versions with herbs or spices.\n\nToday, Cheddar cheese is one of the most widely consumed cheeses in the world and is a staple in many households. It is used in a variety of culinary applications, from sandwiches and burgers to casseroles and cheese sauces. The cheese has earned a place in both traditional British cuisine and modern international dishes, making it a beloved choice for cheese lovers everywhere.', imagePath: 'images/cheddar.jpeg'),
    Cheese(id: 3, name: 'Jarlsberg', origin: 'Norway', agingWindow: '3-6', animal: ['cow'], traditionallyRaw: false, flavorProfile: ['Nutty', 'mild', 'sweet'], texture: ['Semi-soft', 'elastic'], usage: ['sandwiches', 'soups', 'snack'], history: 'Jarlsberg cheese has its origins in Norway, specifically in the region of Østfold, and it was first developed in the 1950s. The cheese was inspired by traditional Swiss Emmental cheese, which the Norwegian cheese-makers sought to replicate while creating a unique Norwegian product.\n\nThe name \"Jarlsberg\" comes from the Jarlsberg estate in the area, where the cheese was originally produced. It was developed by a group of Norwegian dairymen and cheese-makers, who aimed to create a cheese with a mild, nutty flavor and a characteristic, distinctive holes (or \"eyes\") throughout. The holes are formed by the activity of the propionic acid bacteria used in the fermentation process, which produces carbon dioxide gas that creates the bubbles in the curd.\n\nJarlsberg gained international recognition when it was introduced to markets outside of Norway in the late 20th century, particularly in the United States. Its mild, creamy flavor and versatility made it popular for use in sandwiches, cooking, and as a snack cheese.\n\nThe cheese is produced using strict quality controls, and while there are several varieties of Jarlsberg, the original version is still the most recognized and widely consumed. Jarlsberg is often associated with Norwegian cuisine and is a beloved cheese in many parts of the world.\n\nToday, Jarlsberg continues to be a popular cheese choice, known for its smooth texture and mild taste, making it a favorite for cheese platters, melting in dishes, or simply enjoyed on its own.', imagePath: 'images/jarlsberg.jpeg')

  ];
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    CheeseDatabase.instance.closeDB();
    super.dispose();
  }

  // put the annoying underline cause there's already
  // a loadCheeses function
  Future<void> _loadCheeses() async {
    final freshCheeses = await CheeseDatabase.instance.loadCheeses();
    setState(() {
      cheeses = freshCheeses;
    });
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
            child: IconButton(
              onPressed: () {
                // Send to AddCheesePage
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddCheesePage()));
              },
              icon: ClipOval(child: Image.asset('images/cheese-icon.jpeg', width: 36, height: 36, fit: BoxFit.cover))
            ),
          ),
        ],

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(width: 100, height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "List of Cheeses",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Cheese...', border: OutlineInputBorder()),
                    controller: searchController,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, child: const Text('Cheese'))
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: cheeses.isEmpty
                  // I GPT'd this. Pretty cool.
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: cheeses.length,
                itemBuilder: (context, index) {
                  final cheese = cheeses[index];
                  return CheeseCard(cheese: cheese);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}