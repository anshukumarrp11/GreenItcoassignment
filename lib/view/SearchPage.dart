import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate<String> {
  final List data;
  final TextEditingController searchController;
  final Function searchData;

  DataSearch(this.data, this.searchController, this.searchData);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchData(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List filteredData = data.where((item) {
      return item['original_title'].toLowerCase().contains(query.toLowerCase());
    }).toList();
    return GridView.builder(
        itemCount: filteredData.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 10.0, mainAxisSpacing: 10.0),
        itemBuilder: (context, index) {
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
                        image: NetworkImage('https://image.tmdb.org/t/p/w500' +
                            filteredData[index]['backdrop_path']),
                        fit: BoxFit.cover),
                  ),
                  height: 120,
                ),
                Text(
                  filteredData[index]['original_title'] ?? 'Loading',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      filteredData[index]['vote_average'].toString() ??
                          'Loading',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      filteredData[index]['popularity'].toString() ?? 'Loading',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
