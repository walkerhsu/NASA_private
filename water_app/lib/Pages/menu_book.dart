import 'package:flutter/material.dart';
import 'package:water_app/processData/process_species.dart';

// class MenuBook extends StatefulWidget {

// }

class MenuBook extends StatelessWidget {
  const MenuBook({Key? key}) : super(key: key);
  final int crossAxisCount = 2;
  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        children: [
          for (int i = 0; i < ProcessSpecies.TaiwanSpecies.length; i++)
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
                color: Colors.white,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Icon(
                      Icons.menu_book,
                      size: 50,
                      color: Colors.black,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Species',
                      style: TextStyle(
                        color: Colors.black,
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
