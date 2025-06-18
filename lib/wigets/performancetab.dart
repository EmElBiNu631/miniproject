import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/ProfilepageModel.dart';

class PerformanceTab extends StatelessWidget {
  final String label;
  final int index;

  const PerformanceTab({
    super.key,
    required this.label,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfilepageViewModel>(context);
    final bool isSelected = vm.selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        vm.setTabIndex(index);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
