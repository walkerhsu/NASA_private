import 'package:flutter/material.dart';
import 'package:water_app/Components/small_text.dart';
import 'package:water_app/Components/tags_widget.dart';
import 'package:water_app/Constants/screen_info.dart';

class ExpandedDescription extends StatefulWidget {
  final List<String> description; // [description, fact, advice] or [source, fact, advice]
  final String type;
  final int index;

  const ExpandedDescription({
    super.key,
    required this.description,
    required this.type, // species or water
    this.index = 0, // 0: description, 1: fact, 2: advice
  });

  @override
  State<ExpandedDescription> createState() => _ExpandedDescriptionState();
}

class _ExpandedDescriptionState extends State<ExpandedDescription> {
  late String firstHalf;
  late String secondHalf;
  final double textHeight = Constants.screenHeight / 5.63;

  bool hidden = true;

  @override
  void initState() {
    super.initState();

    if (widget.description.length > textHeight) {
      firstHalf = widget.description[widget.index].substring(0, textHeight.toInt());
      secondHalf = widget.description[widget.index]
          .substring(textHeight.toInt() + 1, widget.description.length);
    } else {
      firstHalf = widget.description[widget.index];
      secondHalf = "";
      hidden = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
    Container(
            child: secondHalf.isEmpty
                ? SmallText(text: firstHalf, size: 15)
                : Column(
                    children: [
                      SmallText(
                        text: hidden
                            ? (firstHalf + "...")
                            : (firstHalf + secondHalf),
                        // size: 25,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            hidden = !hidden;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SmallText(
                              text: hidden ? "show more" : "show less",
                              fontColor: TagsWidget.defaultColor,
                            ),
                            Icon(
                              hidden
                                  ? Icons.keyboard_arrow_down_rounded
                                  : Icons.keyboard_arrow_up_rounded,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
  }
}
