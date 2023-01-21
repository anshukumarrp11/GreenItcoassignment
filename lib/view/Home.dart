import 'package:flutter/material.dart';
import 'package:greenitcoassignment/view/SearchPage.dart';

import 'package:tmdb_api/tmdb_api.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _searchController = TextEditingController();
  List _data = [];
  bool _isLoading = true;

  final String apikey = '536df768e7209a730cf2ac28c5c5db24';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1MzZkZjc2OGU3MjA5YTczMGNmMmFjMjhjNWM1ZGIyNCIsInN1YiI6IjYzYzZlNDUyNGU2NzQyMDA5MTVlYTBhZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.3gp9tVbJTh-pmGM82X8nUn0vQcRmsNFFWiN3i9jpgTE';

  List tv = [];

  @override
  void initState() {
    super.initState();
    loadmovies();
  }

  void loadmovies() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      // ignore: prefer_const_constructors
      logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    // ignore: deprecated_member_use
    Map tvresult = await tmdbWithCustomLogs.v3.movies.getPouplar();
    setState(() {
      tv = tvresult['results'];
      _isLoading = false;
    });
  }

  _searchData(String query) {
    List<dynamic> filteredData = tv.where((item) {
      return item['original_title'].toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      _data = filteredData;
    });
  }

  String sortBy = "alphabetical";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Browser"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: DataSearch(tv, _searchController, _searchData));
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                sortBy = value;
              });
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: "popular",
                  child: Text("Most popular"),
                ),
                PopupMenuItem(
                  value: "rated",
                  child: Text("Highest rated"),
                ),
              ];
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: tv.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                if (sortBy == "alphabetical") {
                  tv.sort((a, b) =>
                      a['original_title'].compareTo(b['original_title']));
                } else if (sortBy == "popular") {
                  tv.sort((a, b) => b['popularity'].compareTo(a['popularity']));
                } else if (sortBy == "rated") {
                  tv.sort(
                      (a, b) => b['vote_average'].compareTo(a['vote_average']));
                }
                late String tittle = tv[index]['original_title'];
                late String vote = tv[index]['vote_average'].toString();
                late String popularity = tv[index]['popularity'].toString();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500' +
                                      tv[index]['backdrop_path']),
                              fit: BoxFit.cover),
                        ),
                        height: 120,
                      ),
                      Text(
                        tittle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            vote,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            popularity,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
                // return Card(
                //   child: Center(
                //     child: Text(items[index]['name']),
                //   ),
                // );
              },
            ),
    );
  }
}
