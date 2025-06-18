import 'package:flutter/material.dart';

import '../screens/puchedout.dart';

class ProfilepageViewModel extends ChangeNotifier {
  bool hasPunchedOut = false;
  bool isPunchingIn = true;
  DateTime? punchOutTime;

  String userName = "Emel Binu";
  String role = "Employee";
  String worklocation = "Location";

  int presence = 18;
  int absence = 2;
  int leaves = 1;

  DateTime? checkInTime;

  bool _isCheckedIn = false;
  bool _isPunchedIn = false;
  int _selectedTabIndex = 0;

  int get selectedTabIndex => _selectedTabIndex;
  bool get isCheckedIn => _isCheckedIn; // ✅ Add this line
  bool get isUserCheckedIn => _isCheckedIn;
  bool get isPunchedIn => _isPunchedIn;

  set isPunchedIn(bool value) {
    _isPunchedIn = value;
    notifyListeners();
  }

  void setCheckIn(bool value) {
    _isCheckedIn = value;
    notifyListeners();
  }

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  void punchIn() {
    _isCheckedIn = true;
    _isPunchedIn = true;
    checkInTime = DateTime.now();
    presence += 1;
    hasPunchedOut = false;
    notifyListeners();
  }

  void punchOut() {
    _isCheckedIn = false;
    _isPunchedIn = false;
    hasPunchedOut = true;
    punchOutTime = DateTime.now();
    notifyListeners();
  }

  void punchInWithLocation(String location) {
    _isCheckedIn = true;
    _isPunchedIn = true;
    hasPunchedOut = false;
    checkInTime = DateTime.now();
    worklocation = location;
    notifyListeners();
  }

  // Future<void> handlePunchOut(BuildContext context) async {
  //   final shouldPunchOut = await showDialog<bool>(
  //     context: context,
  //     builder: (dialogContext) {
  //       return AlertDialog(
  //         title: const Text("Confirm Punch Out"),
  //         content: const Text("Are you sure you want to punch out?"),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(dialogContext, false),
  //             child: const Text("Cancel"),
  //           ),
  //           ElevatedButton(
  //             onPressed: () => Navigator.pop(dialogContext, true),
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.redAccent,
  //               foregroundColor: Colors.white,
  //             ),
  //             child: const Text("Punch Out"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  //
  //   if (shouldPunchOut == true) {
  //     punchOut();
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => const PunchedOutSuccessView(time: '05:20 PM'),
  //       ),
  //     );
  //   }
  // }
}
