import 'package:flutter/material.dart';
import 'package:water_app/OceanData/ocean_data.dart';

class OceanDetailData extends StatelessWidget {
  final OceanData oceanData;
  const OceanDetailData({super.key, required this.oceanData});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black,
            child: Column(children: [
              Expanded(
                  flex: 3,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Stack(children: [
                            Positioned.fill(
                                child: Image.asset(
                              oceanData.image,
                              fit: BoxFit.cover,
                            )),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 50, left: 20, right: 20),
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.arrow_back_ios_outlined,
                                          color: Colors.white.withOpacity(.5),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 30, right: 30, left: 30),
                                    height: MediaQuery.of(context).size.height *
                                        0.18,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(.6),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(50),
                                            topRight: Radius.circular(50))),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(children: [
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    oceanData.oceanName,
                                                    style: const TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        decoration:
                                                            TextDecoration
                                                                .none),
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.location_on,
                                                        color: Colors.red,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                          '(${oceanData.location.latitude}, ${oceanData.location.longitude})',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20,
                                                          )),
                                                    ],
                                                  )
                                                ])
                                          ])
                                        ])))
                          ])))),
              Expanded(
                  flex: 2,
                  child: Container(
                      margin:
                          const EdgeInsets.only(top: 20, left: 20, right: 30, bottom: 60),
                      height: double.infinity,
                      width: double.infinity,
                      child: Column(children: [
                        SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.description,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Description",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(.5),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "This is a description text",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.thermostat,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Temperature",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(.5),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${oceanData.temperature}°C / ${1.8 * oceanData.temperature + 32}°F",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.water_drop,
                                    color: Colors.blue,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Quality",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(.5),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${oceanData.quality}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.height,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Sea level",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(.5),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "${oceanData.seaLevel}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ])),
                      ]))),
            ])));
  }
}
