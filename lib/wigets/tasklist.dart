import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  final int tabIndex;

  const TaskList({
    super.key,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Placeholder logic: show different lists based on tabIndex
    List<String> tasks = [];

    if (tabIndex == 0) {
      tasks = ["Fix UI bug", "Update API", "Review code"];
    } else if (tabIndex == 1) {
      tasks = ["Check deadlines", "Client feedback"];
    } else if (tabIndex == 2) {
      tasks = ["Integrate database", "Testing app"];
    }

    return Column(
      children: tasks.map((task) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline, color: Colors.blueAccent),
              const SizedBox(width: 10),
              Expanded(child: Text(task)),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        );
      }).toList(),
    );
  }
}
