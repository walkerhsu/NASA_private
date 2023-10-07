import 'package:flutter/material.dart';
import 'package:water_app/processData/process_species.dart';

// class MenuBook extends StatefulWidget {

// }

class MenuBook extends StatelessWidget {
  const MenuBook({Key? key}) : super(key: key);
  final int crossAxisCount = 3;
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount, 
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        for (int i = 0; i < ProcessSpecies.species.length; i++)
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Center(child: Text("onTap")),
                ),
              );
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: const Color.fromARGB(255, 30, 29, 29),
              child: const Column(
                children: [
                  SizedBox(height: 10),
                  Icon(
                    Icons.menu_book,
                    size: 50,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Species',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          )
    ]);
  }
}
