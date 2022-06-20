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
    //sharedPreferences.setString('source', getCurrentAddressFromSharedPrefs());
    
    //LatLng sourceLatLng = getCurrentLatLngFromSharedPrefs();
    //LatLng destinationLatLng = getTripLatLngFromSharedPrefs('destination');
    //Map modifiedResponse = await getDirectionsAPIResponse(sourceLatLng, destinationLatLng);
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
            //maxWidth: 600,
            axisAlignment:0.0,
            scrollPadding: EdgeInsets.only(top: 16,bottom: 20),
            elevation: 4.0,
            physics: BouncingScrollPhysics(),
            onQueryChanged: (query){
              _searchHandler(query);
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
                        isLoading
                  ? const LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                  : Container(),
                  SizedBox(
                    height: 200.0,
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