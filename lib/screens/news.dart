import 'dart:ui';
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(111, 167, 51, 51).withOpacity(0.2),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
        ),
        title: const Center(
          child: Image(
            image: AssetImage('assets/images/Logo_tr_cerna.png'),
            height: 50,
            width: 45,
          ),
        ),
      ),

      body: const Center(
        child: Text(
          "NEWS SCREEN",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}