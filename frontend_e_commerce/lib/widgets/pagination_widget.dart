import 'package:flutter/material.dart';

class PaginationWidget extends StatefulWidget {
  final dynamic controller;
  const PaginationWidget({super.key , required this.controller});

  @override
  State<PaginationWidget> createState() => _PaginationWidgetState();
}

class _PaginationWidgetState extends State<PaginationWidget> {
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.controller.previousPage,
          ),
          Text("Page ${widget.controller.currentPage} of ${widget.controller.totalPages}"),
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: widget.controller.nextPage,
          ),
        ],
      ),
    );
  }
}
