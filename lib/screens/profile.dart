import 'package:flutter/material.dart';
import 'package:miniproject/viewmodel/ProfilepageModel.dart';
import 'package:provider/provider.dart';

import '../wigets/dashboard.dart';
import '../screens/leavedashboardview.dart';

class ProfilePageView extends StatelessWidget {
  final String checkinMessage;
  final String checkoutMessage;

  const ProfilePageView({
    Key? key,
    required this.checkinMessage,
    required this.checkoutMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfilepageViewModel(),
      child: ProfilePageContent(
        checkinMessage: checkinMessage,
        checkoutMessage: checkoutMessage,
      ),
    );
  }
}

class ProfilePageContent extends StatefulWidget {
  final String checkinMessage;
  final String checkoutMessage;

  const ProfilePageContent({
    Key? key,
    required this.checkinMessage,
    required this.checkoutMessage,
  }) : super(key: key);

  @override
  State<ProfilePageContent> createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent> {
  int selectedIndex = 3;
  int? _selectedTaskTab = 0;
  String _selectedSort = "Deadline";
  String selectedStatus = "start";

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfilepageViewModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            flexibleSpace: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                userNameFutureBuilder(
                  builder: (userName) => boxwithnameandrole(userName, viewModel.role),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              userNameonlyFutureBuilder(),
              const SizedBox(height: 15),
              checkinandoutwidget(
                widget.checkinMessage,
                widget.checkoutMessage,
                viewModel.checkInTime?.toString() ?? "Not checked in",
                viewModel.worklocation,
                context,
                "Punch in",
                "Punch out",
              ),
              const SizedBox(height: 25),
              sectionTitle("Overview"),
              leaveDetails(
                "Presence",
                viewModel.presence.toString(),
                "Absence",
                viewModel.absence.toString(),
                "Leaves",
                viewModel.leaves.toString(),
              ),
              const SizedBox(height: 5),
              customscrollingbuttons(
                titles: ['My tasks', 'Task tracker', 'Ongoing & pending', 'Work summary'],
                selectedIndex: _selectedTaskTab,
                onButtonTap: (index) {
                  setState(() => _selectedTaskTab = index);
                },
              ),
              customRadioButtons(
                title: "Sort By",
                title1: "Deadline",
                title2: "Project",
                selectedButton: _selectedSort,
                onChanged: (val) => setState(() => _selectedSort = val!),
              ),
              const SizedBox(height: 10),
              if (_selectedTaskTab == 0) _buildMyTasks(),
              if (_selectedTaskTab == 1) _buildTaskTracker(),
              if (_selectedTaskTab == 2) _buildOngoingTasks(),
              if (_selectedTaskTab == 3) _buildWorkSummary(viewModel),
              const SizedBox(height: 10),
              sectionTitle("Dashboard"),
              dashboard(
                "Attendance",
                'assets/10.jpg',
                    () {},
                "Leaves",
                "assets/11.jpg",
                    () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveDashboardView())),
                "Leave Status",
                "assets/12.jpeg",
                    () {},
              ),
              dashboard(
                "Holiday List",
                'assets/5.png',
                    () {},
                "Payslips",
                'assets/7.jpeg',
                    () {},
                "Reports",
                'assets/images.png',
                    () {},
              ),
            ],
          ),
        ),
        bottomNavigationBar: custombottomnavigation("Home", "History", "Leaves", "Profile", selectedIndex, (index) => setState(() => selectedIndex = index)),
      ),
    );
  }

  Widget sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );

  Widget _buildMyTasks() => Column(
    children: [
      custommytasks("UI/UX Design Implementation", "Translating design specifications into UI."),
      custommytasks("Responsive Design", "Ensuring seamless adaptation to devices."),
      custommytasks("Back-end Development", "Managing database and APIs."),
      custommytasks("Server-Side Login", "Handling logic on the server side."),
    ],
  );

  Widget _buildTaskTracker() => Column(
    children: [
      trackerItem(title: "Responsive Design", dueDate: "18-06-2025", progress: 25, remaining: "2 days", priority: "High", status: "In progress", onSelectionChanged: (val) => setState(() => selectedStatus = val!)),
      trackerItem(title: "UI/UX Design", dueDate: "18-06-2025", progress: 69, remaining: "2 days", priority: "High", status: "Completed", onSelectionChanged: (val) => setState(() => selectedStatus = val!)),
    ],
  );

  Widget _buildOngoingTasks() => Column(
    children: [
      ongoingItemSimple(startDate: "12-06-2025", title: "UI/UX Design", status: "in progress", completion: "70%", completionDate: "12-05-2025", priority: "High"),
      ongoingItemSimple(startDate: "12-06-2025", title: "Responsive Design", status: "in progress", completion: "70%", completionDate: "12-05-2025", priority: "High"),
    ],
  );

  Widget _buildWorkSummary(ProfilepageViewModel vm) => Padding(
    padding: const EdgeInsets.all(12),
    child: metricGrid(vm.getMetrics()),
  );
}
