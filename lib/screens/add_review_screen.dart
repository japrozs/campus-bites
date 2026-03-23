import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/review.dart';

class AddReviewScreen extends StatefulWidget {
  final int restaurantId;

  const AddReviewScreen({super.key, required this.restaurantId});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}