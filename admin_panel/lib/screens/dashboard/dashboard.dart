import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../login/login_screen.dart';
import 'package:admin_panel/screens/manage_bus_details/manage_bus_details.dart';
import 'package:admin_panel/screens/manage_driver_details/manage_driver_details.dart';
import 'package:admin_panel/screens/allocate_bus_to_student/allocate_bus_to_student.dart';
import 'package:admin_panel/screens/manage_student_details/manage_student_details.dart';
import 'package:admin_panel/screens/manage_student_fees/manage_student_fees.dart';
import 'package:admin_panel/screens/manage_notification/manage_notification.dart';
import 'package:admin_panel/screens/view_student_attendance/view_student_attendance.dart';
import 'package:admin_panel/screens/reports/reports.dart';

// Import other screens here
// Example: import 'manage_bus_details.dart';
// You can replace placeholders with actual screen imports.

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C5364),
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSummaryCards(),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(flex: 2, child: _buildFeesCollectedChart()),
                const SizedBox(width: 20),
                Expanded(flex: 2, child: _buildAttendanceOverview()),
              ],
            ),
            const SizedBox(height: 30),
            _buildNotificationsSummary(),
          ],
        ),
      ),
    );
  }

  // Drawer (Sidebar) with Navigation Options
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0F2027),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF203A43), Color(0xFF2C5364)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Text(
              'Campus Bus',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            Icons.directions_bus,
            "Manage Bus Details",
            const ManageBusDetailsScreen(),
          ),
          _buildDrawerItem(
            context,
            Icons.person,
            "Manage Bus Driver Details",
            const ManageBusDriverDetailsScreen(),
          ),
          _buildDrawerItem(
            context,
            Icons.swap_horiz,
            "Allocate Bus to Student",
            const AllocateBusScreen(),
          ),
          _buildDrawerItem(
            context,
            Icons.school,
            "Manage Student Details",
            const StudentManagementScreen(),
          ),
          _buildDrawerItem(
            context,
            Icons.payment,
            "Manage Student Fees Details",
            const ManageRouteBasedFeesScreen(),
          ),
          _buildDrawerItem(
            context,
            Icons.notifications,
            "Manage Notification",
            const ManageNotificationScreen(),
          ),
          _buildDrawerItem(
            context,
            Icons.assignment,
            "View Student Attendance",
            const ViewStudentAttendance(),
          ),
          _buildDrawerItem(
            context,
            Icons.bar_chart,
            "Reports",
            const ReportsScreen(),
          ),
          const Divider(color: Colors.white54),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  // Drawer Item Widget
  Widget _buildDrawerItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget screen,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }

  // Summary Cards for Buses, Drivers, Students
  Widget _buildSummaryCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statCard("Total Buses", 12),
        _statCard("Total Drivers", 5),
        _statCard("Total Students", 120),
      ],
    );
  }

  Widget _statCard(String title, int value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 10),
            AnimatedFlipCounter(
              duration: const Duration(seconds: 2),
              value: value,
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fees Collected Graph
  Widget _buildFeesCollectedChart() {
    return _graphContainer(
      title: "Fees Collected",
      child: LineChart(
        LineChartData(
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 10000,
                getTitlesWidget:
                    (value, _) => Text(
                      "${value ~/ 1000}k",
                      style: const TextStyle(color: Colors.white),
                    ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
                  return Text(
                    months[value.toInt()],
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              color: Colors.greenAccent,
              belowBarData: BarAreaData(
                show: true,
                // ignore: deprecated_member_use
                color: Colors.green.withOpacity(0.3),
              ),
              spots: const [
                FlSpot(0, 50000),
                FlSpot(1, 60000),
                FlSpot(2, 55000),
                FlSpot(3, 65000),
                FlSpot(4, 70000),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Attendance Overview Graph
  Widget _buildAttendanceOverview() {
    return _graphContainer(
      title: "Attendance Overview",
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: [
            _barGroup(0, 80),
            _barGroup(1, 75),
            _barGroup(2, 90),
            _barGroup(3, 70),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                getTitlesWidget: (value, _) {
                  return Text(
                    "${value.toInt()}%",
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const days = ['Mon', 'Tue', 'Wed', 'Thu'];
                  return Text(
                    days[value.toInt()],
                    style: const TextStyle(color: Colors.white),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  BarChartGroupData _barGroup(int x, double y) => BarChartGroupData(
    x: x,
    barRods: [BarChartRodData(toY: y, width: 20, color: Colors.blueAccent)],
  );

  // Notifications Summary
  Widget _buildNotificationsSummary() {
    return _graphContainer(
      title: "Notifications Summary",
      child: Column(
        children: const [
          ListTile(
            leading: Icon(Icons.warning, color: Colors.amber),
            title: Text(
              "Route Change for Bus #12",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              "2 hours ago",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          Divider(color: Colors.white24),
          ListTile(
            leading: Icon(Icons.error, color: Colors.redAccent),
            title: Text(
              "Emergency Stop - Bus #8",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              "5 hours ago",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _graphContainer({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(height: 250, child: child),
        ],
      ),
    );
  }
}
