import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0,

              child: ClipPath(
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(color: Colors.grey, width: 0))),
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(
                            flex: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[200]!,
              child: Card(
               // elevation: 15,
                child: ClipPath(
                  child: Container(
                    height: 20,
                    width:MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(color: Colors.grey, width: 4))),
                  ),
                  clipper: ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3))),
                ),
              ),
            ),
                            )),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 5.0, right: 5.0),
                                child: Container(child: Column(
                                  children: [
                                    Align(
          alignment: Alignment.topLeft,
          child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[200]!,
              child: Card(
               // elevation: 15,
                child: ClipPath(
                  child: Container(
                    height: 20,
                    width:180,
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(color: Colors.grey, width: 4))),
                  ),
                  clipper: ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3))),
                ),
              ),
            ),
        ),Align(
          alignment: Alignment.topLeft,
          child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[200]!,
              child: Card(
               // elevation: 15,
                child: ClipPath(
                  child: Container(
                    height: 20,
                    width:190,
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(color: Colors.grey, width: 4))),
                  ),
                  clipper: ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3))),
                ),
              ),
            ),
        )
                                  ],
                                ),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3))),
              ),
            );
          }),
    );
  }
}


class ShimmerGrid extends StatelessWidget {
  //const ShimmerGrid({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height:150,
        child: GridView.builder(
          itemCount: 5,
          scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
           gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1), itemBuilder: (con,ind){
                                      return Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Shimmer.fromColors(
                                           baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[200]!,
                                          child: Card(
                                            // height: 100,
                                            // width: 100,
                                          ),
                                        ),
                                      );

          }),
      ),
      
    );
  }
}

class ShimmerCircleAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      // snap: true,
      floating: true,
      expandedHeight: MediaQuery.of(context).size.height / 6.8,
      flexibleSpace: FlexibleSpaceBar(
        // titlePadding: EdgeInsets.only(top: 35),
        //centerTitle: true,

        background: ListView.builder(
            // physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            // shrinkWrap: true,
            itemCount: 5,
            itemBuilder: (ctx, index) {
              return Container(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Shimmer.fromColors(
                          baseColor: Colors.grey[400]!,
                          highlightColor: Colors.grey[300]!,
                          child: CircleAvatar(
                            radius: 36,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                            child: Shimmer.fromColors(
                                      baseColor: Colors.grey[300]!,
                                      highlightColor: Colors.grey[200]!,
                                      child: Card(
                                       // elevation: 15,
                                        child: ClipPath(
                                          child: Container(
                        height: 20,
                        width:55,
                        decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(color: Colors.grey, width: 4))),
                                          ),
                                          clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3))),
                                        )))
                                ),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class ShimmerAccountText extends StatelessWidget {
  const ShimmerAccountText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(padding: EdgeInsets.all(20.0),
        child: Container(child: Column(children: [
  Align(
    alignment: Alignment.topLeft,
    child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[200]!,
                child: Card(
                 // elevation: 15,
                  child: ClipPath(
                    child: Container(
                      height: 20,
                      width:110,
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(color: Colors.grey, width: 4))),
                    ),
                    clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3))),
                  ),
                ),
              ),
  ),
        SizedBox(
          height: 2,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[200]!,
                child: Card(
                 // elevation: 15,
                  child: ClipPath(
                    child: Container(
                      height: 20,
                      width:170,
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(color: Colors.grey, width: 4))),
                    ),
                    clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3))),
                  ),
                ),
              ),
        ),
         SizedBox(
          height: 2,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[200]!,
                child: Card(
                 // elevation: 15,
                  child: ClipPath(
                    child: Container(
                      height: 20,
                      width:180,
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(color: Colors.grey, width: 4))),
                    ),
                    clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3))),
                  ),
                ),
              ),
        )
        ],),),)
       
      ],
    );
  }
}
