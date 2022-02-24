import 'package:flutter/material.dart';

class CarouselItms extends StatelessWidget {
  const CarouselItms({this.img,this.imgt});
  final img;
  final imgt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              //color: Colors.black,
              //padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(blurRadius: 5, color: Colors.black, spreadRadius: 0)
                ],
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                // image: DecorationImage(
            
                //   fit: BoxFit.fill,
                //   image:
                //   img
                // ),
              ),
            
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: FadeInImage(
                  fit: BoxFit.fill,
            
                  //fit: BoxFit.cover,
                  // imageErrorBuilder: (con, obj, stack) {
                  //   print('ers');
                  //   return Container(
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.all(Radius.circular(8)),
                  //         image: DecorationImage(
                  //           // invertColors: snapshot.data[
                  //           //       index]['isOpen'],
                  //           image: AssetImage(imgt),
                  //           fit: BoxFit.cover,
                  //         )),
                  //   );
                  // },
                  placeholder: AssetImage(
                    imgt,
                  ),
                  image: NetworkImage(img),
                ),
              ),
            
              // child: Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Image.network(
              //     imgurl,
              //     fit: BoxFit.fill,
              //   ),
              // ),
            ),
          ),
          //   Container(
          //   height: 350.0,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.all(Radius.circular(20)),
          //       color: Colors.white,
          //     ),
          // )
        ],
      ),
    );
  }
}

class nulCarasoul extends StatelessWidget {
  final img;
  const nulCarasoul({this.img});

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
                borderRadius: BorderRadius.all(Radius.circular(8)),
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
        //   Container(
        //   height: 350.0,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.all(Radius.circular(20)),
        //       color: Colors.white,
        //     ),
        // )
        ],
      ),
    );
  }
}
