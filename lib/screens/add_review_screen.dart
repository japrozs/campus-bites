import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/review.dart';

class AddReviewScreen extends StatefulWidget {
  final int restaurantId;

  const AddReviewScreen({super.key, required this.restaurantId});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}
class _AddReviewScreenState extends State<AddReviewScreen> {
  int _rating = 3;
  final _commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;