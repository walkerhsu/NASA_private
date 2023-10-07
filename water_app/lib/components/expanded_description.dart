import 'package:flutter/material.dart';
import 'package:water_app/Components/small_text.dart';
import 'package:water_app/Components/tags_widget.dart';
import 'package:water_app/information/screen_info.dart';

class ExpandedDescription extends StatefulWidget {
  final String description;

  const ExpandedDescription({
    super.key,
    this.description = 'Brief description',
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
      firstHalf = widget.description.substring(0, textHeight.toInt());
      secondHalf = widget.description
          .substring(textHeight.toInt() + 1, widget.description.length);
    } else {
      firstHalf = widget.description;
      secondHalf = "";
      hidden = false;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: SingleChildScrollView(
          child: Container(
              child: secondHalf.isEmpty
                  ? SmallText(text: firstHalf)
                  : Column(
                      children: [
                        SmallText(
                          text: hidden
                              ? (firstHalf + "...")
                              : (firstHalf + secondHalf),
                          size: 20,
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
                                color: TagsWidget.defaultColor,
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
                    ))),
    );
  }
}
