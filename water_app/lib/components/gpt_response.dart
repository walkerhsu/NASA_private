import 'package:flutter/material.dart';
import 'package:water_app/Components/loading.dart';
import 'package:water_app/HTTP/http_request.dart';
import 'package:water_app/Components/expanded_description.dart';
import 'package:water_app/Components/big_text.dart';

class GptResponse extends StatelessWidget {
  const GptResponse({
    Key? key,
    required this.species,
    required this.water,
    required this.type,
  }) : super(key: key);
  final String? species;
  final String? water;
  final String type;

  @override
  Widget build(BuildContext context) {
    List<String> title = ["Introduction"];
    if (type == "species") {
      title = ["Introduce", "Fun Fact", "How to protect species"];
    } else {
      title = ["Water Source", "Introduce", "What you need to be aware of"];
    }
    // print(title[0]);
    return FutureBuilder(
        future: type == "species"
            ? Future.wait(
                [
                  HttpRequest.getSpeciesDescription(species),
                  HttpRequest.getSpeciesFact(species),
                  HttpRequest.getSpeciesAdvice(species),
                ],
              )
            : Future.wait(
                [
                  HttpRequest.getWaterSource(water),
                  HttpRequest.getWaterFact(water),
                  HttpRequest.getWaterAdvice(water),
                ],
              ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            List<String> description = snapshot.data as List<String>;

            return Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < description.length; i++)
                      SizedBox(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BigText(
                                text: title[i],
                                size: 24,
                              ),
                              const SizedBox(height: 10),
                              ExpandedDescription(
                                description: description,
                                type: type,
                                index: i,
                              ),
                              const SizedBox(height: 10),
                            ]),
                      ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          } else {
            return const Loading();
          }
        });
  }
}
