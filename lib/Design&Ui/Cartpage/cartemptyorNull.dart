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
                              child: Image.asset('images/plate1.png'),
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