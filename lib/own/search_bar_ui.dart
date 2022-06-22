import 'dart:convert';

import 'package:bike_nav/helpers/mapbox_handler.dart';
import 'package:bike_nav/main.dart';
import 'package:bike_nav/own/review_destination.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';



class SearchBarUI extends StatefulWidget {
  SearchBarUI({Key? key}) : super(key: key);

  @override
  State<SearchBarUI> createState() => _SearchBarUIState();
}


class _SearchBarUIState extends State<SearchBarUI> {

  List response = [];
  bool isLoading = false;


  @override
  void initState(){
    super.initState();
    getParsedResponseForQuery("B").then((value) {
      response = value;
    });
  }

  _searchHandler(String query) async {
    setState(() {
      isLoading = true;
    });
    getParsedResponseForQuery(query).then(
      (value) => {
        setState(() {
          isLoading = false;
          response = value;
        })
      }
    );
  }

  _handleTileTap(int index) async {
    sharedPreferences.setString('destination', json.encode(response[index]));
    if (!mounted) return;
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ReviewDestination()));
    
  }
  

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
            hint: 'Search...',
            openAxisAlignment: 0.0,
            height: 55.0,
            axisAlignment:0.0,
            borderRadius: BorderRadius.all(Radius.circular(30.0)) ,
            elevation: 4.0,
            physics: BouncingScrollPhysics(),
            onQueryChanged: (query){
              _searchHandler(query);
            },
            transitionCurve: Curves.easeInOut,
            transitionDuration: Duration(milliseconds: 500),
            transition: CircularFloatingSearchBarTransition(),
            debounceDelay: Duration(milliseconds: 500),
            actions: [
              FloatingSearchBarAction(
                showIfOpened: false,
                child: CircularButton(icon: Icon(Icons.place),
                    onPressed: (){
                    },),
              ),
              FloatingSearchBarAction.searchToClear(
                showIfClosed: false,
              ),
            ],
            builder: (context, transition){
              return ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Material(
                  color: Colors.white,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.75,
                    color: Colors.white,
                    child: Column(
                      children: [
                        isLoading
                  ? const LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                  : Container(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: double.infinity,
                    child: ListView.builder(
                          itemCount: response.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                ListTile(
                                  onTap: (){_handleTileTap(index);},
                                  leading: const SizedBox(
                                    height: double.infinity,
                                    child: CircleAvatar(child: Icon(Icons.map)),
                                  ),
                                  title: Text(response[index]['name'],
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text(response[index]['address'],
                                      overflow: TextOverflow.ellipsis),
                                ),
                                const Divider(),
                              ],
                            );
                          },
                        ))
                        
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  

  }
}