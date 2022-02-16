import 'package:flutter/material.dart';
import 'package:foodorder_userapp/Screens/firstpage.dart';
import 'package:google_fonts/google_fonts.dart';

Center CartemptyOrnull(function) {
    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Container(
                              child: Image.network('https://firebasestorage.googleapis.com/v0/b/mealtime-7fd6c.appspot.com/o/app%20asets%2Fplate1.png?alt=media&token=0d61471d-4012-4f5c-8546-ab35f4dec16e'),
                            ),
                          ),
                          Text(
                            'Your plate is empty add something...',
                            style: GoogleFonts.poppins(fontSize: 17),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text('See nearby restraunts.',
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black.withOpacity(.5))),
                          Container(
                            width: 150,
                            child: OutlineButton(
                              child: new Text(
                                "FIND FOOD",
                                style: GoogleFonts.poppins(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w500),
                              ),
                              borderSide:
                                  BorderSide(color: Colors.orange, width: 2),
                              onPressed: function
                            ),
                          ),
                        ],
                      ),
                    );
  }