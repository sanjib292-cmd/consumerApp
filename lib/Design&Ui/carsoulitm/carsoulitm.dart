import 'package:flutter/material.dart';

class CarouselItms extends StatelessWidget {
  const CarouselItms({this.img});
  final img;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(

                  boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black, spreadRadius: 0)],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                  
                  fit: BoxFit.fill,
                  image: AssetImage(
                  img
                )),
                
                ),
                
            // child: Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Image.network(
            //     imgurl,
            //     fit: BoxFit.fill,
            //   ),
            // ),
          ),
          Container(
          height: 350.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,
              gradient: LinearGradient(
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                  colors: [
                    Colors.pink.withOpacity(0.2),
                    Colors.purple.withOpacity(0.3),
                  ],
                  stops: [
                    0.0,
                    1.0
                  ])),
        )
        ],
      ),
    );
  }
}