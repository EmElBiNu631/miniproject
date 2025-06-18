import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../services/leaveformfirebase.dart';

class LeaveFormViewModel extends ChangeNotifier {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final reasonController = TextEditingController();

  DateTime? fromDate;
  DateTime? toDate;
  String leaveType = '';
  String? attachmentPath;

  final _firestoreService = FirestoreService();

  void setFromDate(DateTime date) {
    fromDate = date;
    notifyListeners();
  }

  void setToDate(DateTime date) {
    toDate = date;
    notifyListeners();
  }

  void setLeaveType(String? type) {
    leaveType = type ?? '';
    notifyListeners();
  }

  void setAttachmentPath(String? path) {
    attachmentPath = path;
    notifyListeners();
  }

  Future<void> pickAttachment() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setAttachmentPath(result.files.single.name); // This updates the view
    }
  }
  Future<void> submitForm() async {
    if (fromDate == null || toDate == null || leaveType.isEmpty || reasonController.text.isEmpty) {
      debugPrint('All fields must be filled');
      return;
    }

    await _firestoreService.submitLeaveApplication(
      employeeName: nameController.text,
      employeeId: idController.text,
      fromDate: fromDate!,
      toDate: toDate!,
      leaveType: leaveType,
      reason: reasonController.text,
      attachment: attachmentPath,
    );

    debugPrint("Leave Submitted Successfully");
    clearForm();
  }

  void clearForm() {
    fromDate = null;
    toDate = null;
    leaveType = '';
    reasonController.clear();
    attachmentPath = null;
    notifyListeners();
  }
}
