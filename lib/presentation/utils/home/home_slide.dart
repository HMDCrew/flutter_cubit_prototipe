import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../hex_color.dart';

class HomeSlide extends StatelessWidget {
  final dynamic slide;
  const HomeSlide({Key? key, required this.slide}) : super(key: key);

  Future<void> launchUrlStart({required String url}) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    slide['include_metas']['color_title'] =
        (slide['include_metas']['color_title'] == ''
            ? '#6B8B8D'
            : slide['include_metas']['color_title']);

    return Row(children: <Widget>[
      DecoratedBox(
        decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                  color: HexColor(slide['include_metas']['color_title']),
                  width: 10,
                  style: BorderStyle.solid),
            ),
            color: const Color.fromARGB(64, 0, 0, 0)),
        child: TextButton(
          onPressed: () => slide['include_metas']['click_through_url'] != ''
              ? launchUrlStart(url: slide['include_metas']['click_through_url'])
              : null,
          child: Text(slide['include_metas']['banner_text'],
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.normal)),
        ),
      )
    ]);
  }
}
