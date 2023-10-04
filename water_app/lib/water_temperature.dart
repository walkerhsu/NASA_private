import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class WaterTemperature extends StatefulWidget {
  const WaterTemperature({Key? key}) : super(key: key);

  @override
  State<WaterTemperature> createState() => _WaterTemperatureState();
}

class _WaterTemperatureState extends State<WaterTemperature> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SfMaps(layers: [
      MapShapeLayer(
        source: MapShapeSource.asset(
            "assets/maps/world_map.json",
            shapeDataField: "continent",
        ),
      )
    ]);
  }
}
