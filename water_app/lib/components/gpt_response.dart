import 'package:flutter/material.dart';
import 'package:water_app/HTTP/http_request.dart';
import 'package:water_app/Components/expanded_description.dart';

class GptResponse extends StatelessWidget {
  const GptResponse(
      {Key? key,
      required this.species,
      required this.water,
      required this.type})
      : super(key: key);
  final String? species;
  final String? water;
  final String type;
  @override
  Widget build(BuildContext context) {
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
                  HttpRequest.getWaterFact(water),
                  HttpRequest.getWaterAdvice(water),
                ],
              ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            List<String> description = [];
            if (type == "species") {
              description = snapshot.data as List<String>;
            } else if (type == "water") {
              description = snapshot.data as List<String>;
            }
            return ExpandedDescription(description: description, type: type);
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
