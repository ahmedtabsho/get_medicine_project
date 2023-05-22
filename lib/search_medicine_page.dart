import 'package:flutter/material.dart';


class SearchMedicine extends StatefulWidget {
  const SearchMedicine({Key? key}) : super(key: key);

  @override
  State<SearchMedicine> createState() => _SearchMedicineState();
}

class _SearchMedicineState extends State<SearchMedicine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search widget"),
      ),
    );
  }
}
