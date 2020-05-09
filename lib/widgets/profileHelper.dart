import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:mucbirsebepler/model/user.dart';
import 'package:mucbirsebepler/widgets/randomGradient.dart';

Widget profilePicture(String url,BuildContext context){
  return CircleAvatar(
    backgroundColor: Theme.of(context).accentColor,
    radius: 95,
    child: CircleAvatar(
      backgroundImage: NetworkImage(url),
      radius: 80,  //TODO radiusları mediaquerye göre yap
      backgroundColor: Theme.of(context).accentColor,
    ),
  );
}



Widget badgeMaker(int index, User gelenUser) {
  return FittedBox(
    child: Container(
      decoration: BoxDecoration(
          gradient: randomGradient(),
          borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
              backgroundColor: Colors.limeAccent,
              radius: 12,
              child: CircleAvatar(
                child: FaIcon(
                  LineAwesomeIcons.xing,
                  size: 14,
                  color: Colors.limeAccent,
                ),
                radius: 8,
                backgroundColor: Colors.black,
              )),
          Text(
            " Ayın Muhabiri $index ",
            style:
            GoogleFonts.righteous(fontSize: 10, color: Colors.black),
          )
        ],
      ),
    ),
  );
}