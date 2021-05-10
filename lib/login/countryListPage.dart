import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CountryListPage extends StatefulWidget {
  CountryListPage(this.countryList);
  var countryList;

  @override
  _CountryListPageState createState() => _CountryListPageState();
}

class _CountryListPageState extends State<CountryListPage> {
  TextEditingController cntCountry = TextEditingController();
  List mainCountryName = [];
  List countryName = [];
  @override
  void initState() {
    super.initState();
    mainCountryName = widget.countryList.keys.toList();
    countryListInit();
  }

  countryListInit() {
    countryName = mainCountryName;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(countryName);
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose a country"),
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.all(10.0),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: TextField(
              style: TextStyle(fontSize: 20),
              controller: cntCountry,
              decoration: InputDecoration(
                hintText: "Search countries",
                contentPadding: EdgeInsets.all(3.0),
                suffix: IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    cntCountry.clear();
                    countryListInit();
                  },
                ),
              ),
              onChanged: (value) {
                countryListInit();
                countryName = countryName
                    .where((string) =>
                        string.toLowerCase().contains(value.toLowerCase()))
                    .toList();
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: countryName.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(countryName[index]),
                    trailing: Text(widget.countryList[countryName[index]]),
                    onTap: () {
                      Navigator.pop(context, countryName[index]);
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
