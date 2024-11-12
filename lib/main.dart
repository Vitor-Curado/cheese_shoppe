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
  /*List<Cheese> cheeses = [
    Cheese(id: 1, name: 'Parmigiano Reggiano', origin: 'Emilia-Romagna and Lombardy, Italy', agingWindow: '12-36', animal: 'Cow', traditionallyRaw: true, flavorProfile: 'Nutty, savory', texture: 'Hard, granular', usage: 'grated on pasta, risottos, cheese boards', history: 'Parmigiano Reggiano has a rich history dating back to the Middle Ages, with its origins traceable to the 12th century. The cheese was first produced by Benedictine monks in the Emilia-Romagna region of Italy. They aimed to create a long-lasting cheese that could be easily transported and stored.\n\nThe name \"Parmigiano Reggiano\" is protected under European law and is classified as a Protected Designation of Origin (PDO) product. This designation ensures that only cheese produced in certain areas, following specific traditional methods, can bear the name. The regions that can produce Parmigiano Reggiano include Parma, Reggio Emilia, Modena, Bologna (to the west of the Reno River), and Mantua (to the south of the Po River).\n\nHistorically, Parmigiano Reggiano was popular among nobility and was often referred to as the \"king of cheeses.\" Its reputation grew throughout Italy and eventually around the world. The production process is still strictly regulated, and each wheel is carefully monitored for quality. After aging, each cheese wheel is inspected, and those that meet the stringent quality standards are branded with a unique mark, ensuring authenticity.\n\nToday, Parmigiano Reggiano remains a staple in Italian cuisine and is highly regarded globally, valued for its complex flavour, versatility in cooking, and the artisanal craftsmanship behind its production.', imagePath: 'images/parmigiano-reggiano.jpeg'),
    Cheese(id: 2, name: 'Cheddar', origin: 'Somerset, England', agingWindow: '3-24', animal: 'cow', traditionallyRaw: false, flavorProfile: 'Sharp nutty', texture: 'Hard', usage: 'sandwiches, soups, snack', history: 'Cheddar cheese has a rich history that dates back to the 12th century, originating from the village of Cheddar in Somerset, England. According to legend, the cheese was discovered when a milkmaid accidentally left milk in a cave, and it curdled due to the natural bacteria present in the cave. The resulting cheese was found to have a unique flavour and texture, leading to the development of what we now know as cheddar.\n\nBy the 16th century, Cheddar cheese was being produced in larger quantities and became widely popular across England. The cheese was originally made in large rounds, and its production spread throughout the country, with various regions developing their own styles and characteristics.\n\nCheddar\'s popularity continued to grow, and by the 19th century, it was being produced in various regions of the world, including the United States, Canada, and Australia. The cheese became known for its distinctive sharp flavour and crumbly texture, and it has since evolved into many varieties, including mild, sharp, extra sharp, and even flavoured versions with herbs or spices.\n\nToday, Cheddar cheese is one of the most widely consumed cheeses in the world and is a staple in many households. It is used in a variety of culinary applications, from sandwiches and burgers to casseroles and cheese sauces. The cheese has earned a place in both traditional British cuisine and modern international dishes, making it a beloved choice for cheese lovers everywhere.', imagePath: 'images/cheddar.jpeg'),
    Cheese(id: 3, name: 'Jarlsberg', origin: 'Norway', agingWindow: '3-6', animal: 'cow', traditionallyRaw: false, flavorProfile: 'Nutty, mild, sweet', texture: 'Semi-soft, elastic', usage: 'sandwiches, soups, snack', history: 'Jarlsberg cheese has its origins in Norway, specifically in the region of Østfold, and it was first developed in the 1950s. The cheese was inspired by traditional Swiss Emmental cheese, which the Norwegian cheese-makers sought to replicate while creating a unique Norwegian product.\n\nThe name \"Jarlsberg\" comes from the Jarlsberg estate in the area, where the cheese was originally produced. It was developed by a group of Norwegian dairymen and cheese-makers, who aimed to create a cheese with a mild, nutty flavor and a characteristic, distinctive holes (or \"eyes\") throughout. The holes are formed by the activity of the propionic acid bacteria used in the fermentation process, which produces carbon dioxide gas that creates the bubbles in the curd.\n\nJarlsberg gained international recognition when it was introduced to markets outside of Norway in the late 20th century, particularly in the United States. Its mild, creamy flavor and versatility made it popular for use in sandwiches, cooking, and as a snack cheese.\n\nThe cheese is produced using strict quality controls, and while there are several varieties of Jarlsberg, the original version is still the most recognized and widely consumed. Jarlsberg is often associated with Norwegian cuisine and is a beloved cheese in many parts of the world.\n\nToday, Jarlsberg continues to be a popular cheese choice, known for its smooth texture and mild taste, making it a favorite for cheese platters, melting in dishes, or simply enjoyed on its own.', imagePath: 'images/jarlsberg.jpeg')
  ];*/

  late AppDatabase database;
  late CheeseDao mydao;
  List<Cheese> cheeses = [];

  Cheese? selectedCheese;

  @override
  void initState() {
   super.initState();
   initDB();
  }

  // Temporary
  void initDB () async
  {
    database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    mydao = database.cheeseDao;

    var temp  = await mydao.getAllCheeses();
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
                        Expanded(child: Text(cheeses[index].name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Courier'))),
                        // Modify button (icon)
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.cyan),
                          onPressed: () {
                            // Modify logic to be implemented later
                          },
                        ),
                        // Delete button (trash bin icon)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.grey),
                          onPressed: () {
                            // Delete logic to be implemented later
                          },
                        ),
                      ],
                    ),
                  ),
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
              onPressed: () {
                // Send to AddCheesePage
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddCheesePage()));
              },
              icon: ClipOval(child: Image.asset('images/cheese-icon.jpeg', width: 36, height: 36, fit: BoxFit.cover)), label: const Text('Add cheese')),
            )

        ],

      ),
      body: reactiveCheeseLayout()
    );
  }
}