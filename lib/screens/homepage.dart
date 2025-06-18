import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:miniproject/screens/puchedout.dart';
import 'package:provider/provider.dart';
import '../viewmodel/homepageviewmodels.dart';
import '../wigets/commonwidgets.dart';
import 'faceverification.dart';
import 'leaveapplicationview.dart';

class HomepageView extends StatelessWidget {
  const HomepageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomepageViewModel(),
      child: const HomepageContent(),
    );
  }
}

class HomepageContent extends StatefulWidget {
  const HomepageContent({super.key});

  @override
  State<HomepageContent> createState() => _HomepageContentState();
}

class _HomepageContentState extends State<HomepageContent> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomepageViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // Handle navigation
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Leave'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(vm),
              const SizedBox(height: 20),
              Text("Good Morning,\n${vm.userName}",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              if (vm.isCheckedIn && vm.checkInTime != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.blueAccent),
                      const SizedBox(width: 10),
                      Text(
                        'Punched in at ${DateFormat('hh:mm a').format(vm.checkInTime!)}',
                        style: const TextStyle(color: Colors.blueAccent, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              _buildCheckInCard(context, vm),
              const SizedBox(height: 16),
              _buildOverview(vm),
              const SizedBox(height: 16),
              _buildDashboard(vm),
            ],
          ),
        ),
      ),
    );
  }

  void showPunchInDialog(BuildContext context, HomepageViewModel vm) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text("Select Punch-In Type", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Are you working from home or on site today?", style: GoogleFonts.poppins(fontSize: 14)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Close dialog
                        vm.punchInWithLocation("On Site");
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>  FaceVerificationView(isPunchingIn: true,)));
                      },
                      child: Text("On Site", style: GoogleFonts.poppins()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Close dialog
                        vm.punchInWithLocation("Work From Home");
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>  FaceVerificationView(isPunchingIn: true,)));
                      },
                      child: Text("Work From Home", style: GoogleFonts.poppins(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(HomepageViewModel vm) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage("assets/images/profile.jpg"),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(vm.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(vm.role, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        const Spacer(),
        const Icon(Icons.notifications_none, color: Colors.blueAccent),
      ],
    );
  }

  Widget _buildCheckInCard(BuildContext context, HomepageViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (vm.checkInTime != null || vm.hasPunchedOut)
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: vm.hasPunchedOut ? Colors.red.shade50 : Colors.green.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: vm.hasPunchedOut ? Colors.redAccent : Colors.green,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    vm.hasPunchedOut
                        ? 'Punched out successfully'
                        : 'Checked-in at ${DateFormat('hh:mm a').format(vm.checkInTime!)}',
                    style: TextStyle(
                      color: vm.hasPunchedOut ? Colors.redAccent : Colors.green,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

          if (vm.checkInTime == null && !vm.hasPunchedOut)
            const Text(
              "You haven't Checked-in yet",
              style: TextStyle(color: Colors.redAccent),
            ),

          const SizedBox(height: 10),

          Row(
            children: [
              Icon(
                Icons.access_time,
                color: vm.hasPunchedOut ? Colors.redAccent : Colors.green,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: !vm.isCheckedIn
                      ? () {
                    showDialog(
                      context: context,
                      builder: (_) => PunchInDialog(
                        onSelect: (location) {
                          Navigator.pop(context); // Close dialog
                          vm.punchInWithLocation(location); // Update state
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) =>  FaceVerificationView(isPunchingIn: true,)),
                          );
                        },
                      ),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !vm.isCheckedIn ? Colors.green : Colors.grey[300],
                    foregroundColor: !vm.isCheckedIn ? Colors.white : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  child: const Text("Punch In"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: vm.isCheckedIn
                      ? () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Confirm Punch Out"),
                        content: const Text("Are you sure you want to punch out?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context), // Dismiss dialog
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close dialog first
                              vm.punchOut(); // Update ViewModel state
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PunchedOutSuccessView(
                                    time: DateFormat('hh:mm a').format(DateTime.now()),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Punch Out"),
                          ),
                        ],
                      ),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vm.isCheckedIn ? Colors.redAccent : Colors.grey[300],
                    foregroundColor: vm.isCheckedIn ? Colors.white : Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  child: const Text("Punch Out"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(HomepageViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Overview", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            _overviewBox("Presence", vm.presence.toString(), Colors.green),
            _overviewBox("Absence", vm.absence.toString(), Colors.red),
            _overviewBox("Leaves", vm.leaves.toString(), Colors.orange),
          ],
        ),
      ],
    );
  }

  Widget _overviewBox(String title, String count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(HomepageViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Dashboard", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _dashboardItem(Icons.calendar_today, "Attendance", () {}),
            _dashboardItem(Icons.logout, "Leaves", () => vm.navigateToLeaves(context)),
            _dashboardItem(Icons.info, "Leave Status", () {}),
            _dashboardItem(Icons.event_note, "Holiday List", () {}),
            _dashboardItem(Icons.receipt_long, "Payslip", () {}),
            _dashboardItem(Icons.bar_chart, "Reports", () {}),
          ],
        ),
      ],
    );
  }

  Widget _dashboardItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.blueAccent),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

}
