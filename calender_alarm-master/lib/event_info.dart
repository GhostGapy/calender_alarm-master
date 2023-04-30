import 'package:flutter/material.dart';

class Event {
  final String title;
  final String description;
  final DateTime from;
  final Color backgroundColor;

  const Event({
    required this.title,
    required this.description,
    required this.from,
    required this.backgroundColor,
  });
}
