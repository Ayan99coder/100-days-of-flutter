import 'package:flutter/material.dart';
class custom extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconcolor;
  final String text;
  const custom({super.key, required this.color, required this.icon, required this.iconcolor, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,size: 80,color: iconcolor,),
          Text(text,style: TextStyle(color: iconcolor,fontSize: 15),),
        ],
      ),
    );
  }
}
class custom2 extends StatelessWidget {
  final Color color;
  final Widget child;
  const custom2({super.key, required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.all(15.0),
      child: child,
    );
  }
}
class custom3 extends StatelessWidget {
  final Color color;
  final Widget child;

  const custom3({super.key, required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
class roundicon extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onpressed;

  const roundicon({super.key, required this.iconData, required this.onpressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(iconData,color: Colors.white,),
      onPressed: onpressed,
      elevation: 6,
      constraints: BoxConstraints.tightFor(height: 36.0,width: 36.0),
      shape: CircleBorder(),
      fillColor: Color(0xFF4C4F5E),
    );
  }
}
const textstyle = TextStyle(
  color: Colors.white,
  fontSize: 25,
  fontWeight: FontWeight.w700,
  height: 3,
);
const textstyle1 = TextStyle(
  color: Colors.green,
  fontSize: 20,
  fontWeight: FontWeight.w500,
  height: 5,
);
const textstyle2 = TextStyle(
  color: Colors.white,
  fontSize: 40,
  fontWeight: FontWeight.bold,
  height: 5,
);
const textstyle3 = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.w400,
  height: 5,
);