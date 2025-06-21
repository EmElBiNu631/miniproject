import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screens/puchedout.dart';

class ProfilepageViewModel extends ChangeNotifier {
  String userName = "Emel Binu";
  String role = "Employee";
  String worklocation = "Location";
  int presence = 18;
  int absence = 2;
  int leaves = 1;

  bool hasPunchedOut = false;
  bool _isCheckedIn = false;
  bool _isPunchedIn = false;
  String checkinMessage = "Checked in at ${DateFormat('hh:mm a').format(DateTime.now())}";
  String checkoutMessage = "Checked out at ${DateFormat('hh:mm a').format(DateTime.now())}";


  DateTime? checkInTime;
  DateTime? punchOutTime;

  // UI state
  int _selectedTabIndex = 0;

  // Getters
  bool get isCheckedIn => _isCheckedIn;
  bool get isPunchedIn => _isPunchedIn;
  int get selectedTabIndex => _selectedTabIndex;

  // Setters
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

  // Punch actions
  void punchIn() {
    _isCheckedIn = true;
    _isPunchedIn = true;
    hasPunchedOut = false;
    checkInTime = DateTime.now();
    presence += 1;
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
  List<Map<String, String>> getMetrics() {
    return [
      {"title": "Tasks Completed", "value": "8"},
      {"title": "Pending Tasks", "value": "3"},
      {"title": "Overdue Tasks", "value": "1"},
      {"title": "Working Days", "value": "$presence"},
      {"title": "Leaves Taken", "value": "$leaves"},
    ];
  }

}
