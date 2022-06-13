import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:photo_view/photo_view.dart';

void main()=> runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}



class CustomSearchDelegate extends SearchDelegate {
  CustomSearchDelegate();

  
  // Demo list to show querying
  List<String> searchTerms = [
    "Apple",
    "Banana",
    "Mango",
    "Pear",
    "Watermelons",
    "Blueberries",
    "Pineapples",
    "Strawberries"
  ];

  @override
  ThemeData appBarTheme(BuildContext context) {
  final ThemeData theme = Theme.of(context);
  return theme.copyWith(
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
    ),
    inputDecorationTheme: searchFieldDecorationTheme ??
        InputDecorationTheme(
          hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
          border: InputBorder.none,
        ),
  );
  }

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
        return IconButton(
          onPressed: () {
            close(context, null);
          },
          icon: Icon(Icons.arrow_back),
        );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  // last overwrite to show the
  // querying process at the runtime
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }  
}




class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  int _currentIndex = 0;
  TextEditingController editingController = TextEditingController();


  final items = List<String>.generate(20, (i) => "Item $i");

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: widgetOption(_currentIndex),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Find Place',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),

    );
  }


  Widget widgetOption(int index) {
    
    if (index ==0 ){
          return Stack(
        fit: StackFit.expand,
        children: [
          PhotoView(
            imageProvider: AssetImage("assets/map(2).png"),
            initialScale: 2.0,
          ), 
          searchBarUI()
        ],
      );

    }else if(index == 1){
      return savedList();
    }else{
      return const Center(
       child:  Text("index out of bounds")
      );
    }
  }


  Widget savedList(){
    return Container(
        child: Column(
          children: <Widget>[
            AppBar(
              title: const Text("Test"),
              actions:[
                IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: CustomSearchDelegate(
                      ),
                    );
                  }, 
                  icon: const Icon(Icons.search)
                ),
              ]
            ),
            
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(items[index]),
                  );
                },
              ),
            ),
          ],
        ),
      );
  }

  Widget searchBarUI(){

    return FloatingSearchBar(
            hint: 'Search...',
            openAxisAlignment: 0.0,
            //maxWidth: 600,
            axisAlignment:0.0,
            scrollPadding: EdgeInsets.only(top: 16,bottom: 20),
            elevation: 4.0,
            physics: BouncingScrollPhysics(),
            onQueryChanged: (query){
              //Your methods will be here
            },
            //showDrawerHamburger: false,
            transitionCurve: Curves.easeInOut,
            transitionDuration: Duration(milliseconds: 500),
            transition: CircularFloatingSearchBarTransition(),
            debounceDelay: Duration(milliseconds: 500),
            actions: [
              FloatingSearchBarAction(
                showIfOpened: false,
                child: CircularButton(icon: Icon(Icons.place),
                    onPressed: (){
                  print('Places Pressed');
                    },),
              ),
              FloatingSearchBarAction.searchToClear(
                showIfClosed: false,
              ),
            ],
            builder: (context, transition){
              return ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Material(
                  color: Colors.white,
                  child: Container(
                    height: 200.0,
                    color: Colors.white,
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('Home'),
                          subtitle: Text('more info here........'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },

          );
  }
}


    