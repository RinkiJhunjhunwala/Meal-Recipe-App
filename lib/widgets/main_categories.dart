import 'package:flutter/material.dart';

class MainCategories extends StatelessWidget {
  final String imageAsset;
  final String text;
  final VoidCallback onPressed;

  MainCategories({
    required this.imageAsset,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imageAsset),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12.0)
          ),
          child: Center(
            child: Container(
              color: Colors.black54,
              padding:const EdgeInsets.all(8.0),
              child: Text(
                text,
                style:const TextStyle(fontSize: 28, color: Colors.white),
              ),
              
            ),
          ),
        ),
      ),
    );
  }
}