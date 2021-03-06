import 'package:bike_nav/own/saved_search_delegate.dart';
import 'package:flutter/material.dart';

class SavedList extends StatelessWidget{
  SavedList({Key? key}) : super(key: key);
  
  final items = List<String>.generate(20, (i) => "Item $i");

  @override
  Widget build(BuildContext context) {  
    return Container(
        child: Column(
          children: <Widget>[
            AppBar(
              title: const Text("Test"),
              actions:[
                IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: SavedSearchDelegate(),);
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
}