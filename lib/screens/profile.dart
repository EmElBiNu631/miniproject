import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miniproject/screens/leavedashboardview.dart';
import 'package:miniproject/screens/puchedout.dart';
import 'package:provider/provider.dart';
import '../viewmodel/ProfilepageModel.dart';
import '../viewmodel/homepageviewmodels.dart';
import '../wigets/commonwidgets.dart';
import '../wigets/dashboardlist.dart';
import '../wigets/overviewcard.dart';
import '../wigets/performancetab.dart';
import '../wigets/taskinfo.dart';
import 'faceverification.dart';
import 'homepage.dart';
import 'leaveapplicationview.dart';

class Profilepage extends StatelessWidget {
  const Profilepage({super.key});

  @override
  Widget build(BuildContext context) {
    final existingVm = Provider.of<ProfilepageViewModel>(context, listen: false);
    return ChangeNotifierProvider.value(
      value: existingVm,
      child: const ProfileContent(),
    );
  }
}

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    final profileVm = Provider.of<ProfilepageViewModel>(context);
    final homeVm = Provider.of<HomepageViewModel>(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildGreeting(profileVm),
              const SizedBox(height: 20),
              _buildCheckInCard(context, profileVm),
              const SizedBox(height: 20),
              const Text("Overview", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  OverviewCard(value: profileVm.presence.toString(), label: "Presence", color: Colors.green),
                  OverviewCard(value: profileVm.absence.toString(), label: "Absence", color: Colors.red),
                  OverviewCard(value: profileVm.leaves.toString(), label: "Leaves", color: Colors.orange),
                ],
              ),
              const SizedBox(height: 20),
              const Text("Performance Task List", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    PerformanceTab(label: "My Tasks", index: 0),
                    PerformanceTab(label: "Task Tracker", index: 1),
                    PerformanceTab(label: "Ongoing", index: 2),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildFilterChips(),
              const SizedBox(height: 16),
              Consumer<ProfilepageViewModel>(
                builder: (context, vm, _) {
                  if (vm.selectedTabIndex == 0) {
                    return Column(
                      children: [
                        TaskInfoCard(
                          title: "UI/UX Design Implementation",
                          description: "Translating design specifications into visually appealing UI using Flutter.",
                          onTap: () {},
                          titleColor: Colors.green,
                        ),
                        TaskInfoCard(
                          title: "Backend Integration",
                          description: "Integrating Firebase services with the app, including authentication and database.",
                          onTap: () {},
                          titleColor: Colors.teal,
                        ),
                        TaskInfoCard(
                          title: "Testing & Deployment",
                          description: "Final testing before publishing the app to Play Store and App Store.",
                          onTap: () {},
                          titleColor: Colors.indigo,
                        ),
                      ],
                    );
                  } else if (vm.selectedTabIndex == 1) {
                    return Column(
                      children: [
                        _buildSortRow(),
                        const SizedBox(height: 16),
                        _buildTaskTrackerList(), // custom UI for Task Tracker
                      ],
                    );
                  } else if (vm.selectedTabIndex == 2) {
                    return const Center(child: Text("No ongoing tasks."));
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),

              const SizedBox(height: 20),
              const Text("Dashboard", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildDashboardGrid(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildSortRow() {
    return Row(
      children: [
        const Text('Sort by:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 10),
        FilterChip(label: const Text('Deadline'), onSelected: (_) {}),
        const SizedBox(width: 8),
        FilterChip(label: const Text('Project'), onSelected: (_) {}),
        const Spacer(),
        const Icon(Icons.filter_list, color: Colors.grey),
      ],
    );
  }

  Widget _buildTaskTrackerList() {
    final List<Map<String, dynamic>> tasks = [
      {
        "title": "Responsive Design",
        "progress": 45,
        "priority": "Medium",
        "dueDate": "18-06-2025",
      },
      {
        "title": "UI/UX Design",
        "progress": 69,
        "priority": "High",
        "dueDate": "18-06-2025",
      },
      {
        "title": "Backend",
        "progress": 75,
        "priority": "Medium",
        "dueDate": "18-06-2025",
      },
    ];

    return Column(
      children: tasks.map((task) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 6),
                    Text("Due: ${task['dueDate']}"),
                    const Spacer(),
                    Text("Priority: ${task['priority']}"),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: task['progress'] / 100,
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                ),
                const SizedBox(height: 6),
                Text("Progress: ${task['progress']}%"),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }


  Widget _buildHeader() {
    return Row(
      children: const [
        CircleAvatar(radius: 24, backgroundImage: AssetImage("assets/images/profile.jpg")),
        SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Emel Binu", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Flutter Developer", style: TextStyle(color: Colors.grey)),
        ]),
        Spacer(),
        Icon(Icons.notifications_none, color: Colors.blueAccent),
      ],
    );
  }

  Widget _buildGreeting(ProfilepageViewModel vm) {
    return Text("Good Morning,\n${vm.userName}", style: const TextStyle(fontSize: 16));
  }

  Widget _buildCheckInCard(BuildContext context, ProfilepageViewModel vm) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
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
                  Icon(Icons.access_time, color: vm.hasPunchedOut ? Colors.redAccent : Colors.green),
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
            const Text("You haven't Checked-in yet", style: TextStyle(color: Colors.redAccent)),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.access_time, color: vm.isCheckedIn ? Colors.redAccent : Colors.green),
              Expanded(
                child: ElevatedButton(
                  onPressed: vm.isCheckedIn
                      ? null
                      : () {
                    showDialog(
                      context: context,
                      builder: (_) => PunchInDialog(
                        onSelect: (location) {
                          Navigator.pop(context);
                          vm.punchInWithLocation(location);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FaceVerificationView(isPunchingIn: true),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: vm.isCheckedIn ? Colors.grey[300] : Colors.green,
                    foregroundColor: vm.isCheckedIn ? Colors.black : Colors.white,
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
                      builder: (_) => Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Confirm Punch Out", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              const Text("Are you sure you want to punch out?", textAlign: TextAlign.center),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel", style: TextStyle(color: Colors.purple)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      vm.punchOut();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PunchedOutSuccessView(
                                            time: DateFormat('hh:mm a').format(DateTime.now()),
                                          ),
                                        ),
                                      );
                                      Future.delayed(const Duration(seconds: 2), () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (_) => const HomepageView()),
                                        );
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text("Punch Out"),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
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

  Widget _buildFilterChips() {
    return Row(
      children: [
        const Text("Sorted By:"),
        const SizedBox(width: 8),
        FilterChip(
          backgroundColor: Colors.grey.shade200,
          label: const Text("Deadline", style: TextStyle(color: Colors.redAccent)),
          onSelected: (_) {},
        ),
        const SizedBox(width: 8),
        FilterChip(
          backgroundColor: Colors.grey.shade200,
          label: const Text("Project", style: TextStyle(color: Colors.greenAccent)),
          onSelected: (_) {},
        ),
        const Spacer(),
        const Icon(Icons.filter_list, color: Colors.grey),
      ],
    );
  }

  Widget _buildDashboardGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        DashboardItem(icon: Icons.calendar_today, title: "Attendance", iconColor: Colors.green),
        DashboardItem(icon: Icons.logout, title: "Leaves", iconColor: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LeaveDashboardView()),
            );
          },
        ),
        DashboardItem(icon: Icons.info, title: "Leave Status", iconColor: Colors.purple),
        DashboardItem(icon: Icons.event_note, title: "Holiday List", iconColor: Colors.indigo),
        DashboardItem(icon: Icons.receipt_long, title: "Payslip", iconColor: Colors.green),
        DashboardItem(icon: Icons.bar_chart, title: "Reports", iconColor: Colors.red),

      ],
    );
  }
}
