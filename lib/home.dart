import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'calendar.dart';
import 'deal.dart';
import 'drawer.dart';
import 'deal_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Deal> newDealList = List.from(dealList);
  onItemSearch(String value) {
    setState(
      () {
        newDealList = dealList
            .where((element) => element.title!.contains(value))
            .toList();
      },
    );
  }

  // ];
  int index = 0;

  TextEditingController searchController = TextEditingController();
  String title = "Список дел";
  bool tittleAppBar = false;

  //Билдер для Listview
  Widget buildList(context, docs) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(docs['name']),
            subtitle: Text(
              docs['description'].toString(),
            ),
            leading: Image.network(
              docs['image'],
            ),
            trailing: const Icon(Icons.arrow_right),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => AddDeal(
                            documentFirebase: docs,
                            name: docs['name'],
                            description: docs['description'],
                            image: docs['image'],
                          ))));
            }));
  }

  @override
  Widget build(BuildContext context) {
    final list = [
      // listSearchWidget(context), // 0
      const CalendarPage(), // 1
    ];

    AppBar appBarSearch = AppBar(
      centerTitle: true,
      title: TextField(
        decoration: const InputDecoration(
          label: Text("Название"),
        ),
        controller: searchController,
        onChanged: onItemSearch,
      ),
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                searchController.clear();
                tittleAppBar = false;
              });
            },
            icon: const Icon(Icons.close))
      ],
    );
    AppBar appBar = AppBar(
      title: Text(title),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                tittleAppBar = true;
              });
            },
            icon: const Icon(Icons.search))
      ],
    );

    return Scaffold(
      appBar: tittleAppBar ? appBarSearch : appBar,
      drawer: const MenuDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber,
        selectedItemColor: Colors.white,
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
              ),
              label: "Список дел"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_today,
              ),
              label: "Календарь")
        ],
        onTap: (value) {
          setState(
            () {
              index = value;
              if (index == 0) {
                title = 'Список дел';
              } else {
                title = 'Календарь';
              }
            },
          );
        },
      ),
      body: StreamBuilder(
          //Firestore переименован в FirebaseFirestore
          //В stream вытаскиваем целую коллекцию контактов и делаем снимок(копию)
          stream: FirebaseFirestore.instance.collection("deals").snapshots(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            //проверка наналичие данных: на null и соединение с Firebase
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            } else {
              //Билд данных в listview через builder
              //Для БД лучше использовать его listView.builder
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                //Здесь был совет по тому, как лучше наименовать элемент docs
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) =>
                    buildList(context, snapshot.data.docs[index]),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
    );

    // Widget listSearchWidget(BuildContext context) {
    //   return ListView(
    //     children: newDealList.map(
    //       (deal) {
    //         return Card(
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(15),
    //             side: const BorderSide(
    //               color: Colors.black,
    //             ),
    //           ),
    //           child: ListTile(
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(15),
    //             ),
    //             tileColor: Colors.blueGrey[100],
    //             leading: Text(
    //               deal.id.toString(),
    //             ),
    //             title: Text(deal.title!),
    //             subtitle: Text(deal.discription!),
    //             trailing: const Icon(
    //               Icons.arrow_right,
    //               color: Colors.black,
    //             ),
    //             onTap: () {},
    //           ),
    //         );
    //       },
    //     ).toList(),
    //   );
    // }

    // final list = [
    //   listSearchWidget(context), // 0
    //   const CalendarPage(), // 1
    // ];
    // AppBar appBarSearch = AppBar(
    //   centerTitle: true,
    //   title: TextField(
    //     decoration: const InputDecoration(
    //       label: Text("Название"),
    //     ),
    //     controller: searchController,
    //     onChanged: onItemSearch,
    //   ),
    //   actions: [
    //     IconButton(
    //         onPressed: () {
    //           setState(() {
    //             searchController.clear();
    //             tittleAppBar = false;
    //           });
    //         },
    //         icon: const Icon(Icons.close))
    //   ],
    // );
    // AppBar appBar = AppBar(
    //   title: Text(title),
    //   centerTitle: true,
    //   actions: [
    //     IconButton(
    //         onPressed: () {
    //           setState(() {
    //             tittleAppBar = true;
    //           });
    //         },
    //         icon: const Icon(Icons.search))
    //   ],
    // );

    // return Scaffold(
    //   appBar: tittleAppBar ? appBarSearch : appBar,
    //   body: list.elementAt(index),
    //   floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {},
    //     child: const Icon(
    //       Icons.add,
    //     ),
    //   ),
    //   drawer: const MenuDrawer(),
    //   bottomNavigationBar: BottomNavigationBar(
    //     backgroundColor: Colors.amber,
    //     selectedItemColor: Colors.white,
    //     currentIndex: index,
    //     items: const [
    //       BottomNavigationBarItem(
    //           icon: Icon(
    //             Icons.list,
    //           ),
    //           label: "Список дел"),
    //       BottomNavigationBarItem(
    //           icon: Icon(
    //             Icons.calendar_today,
    //           ),
    //           label: "Календарь")
    //     ],
    //     onTap: (value) {
    //       setState(
    //         () {
    //           index = value;
    //           if (index == 0) {
    //             title = 'Список дел';
    //           } else {
    //             title = 'Календарь';
    //           }
    //         },
    //       );
    //     },
    //   ),
    // );
  }
}
