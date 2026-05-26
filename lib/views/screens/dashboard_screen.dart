import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_student_planner/views/screens/profile_screen.dart';
import '../../controllers/task_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../models/task.dart';
import 'new_task_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // watch means rebuild whenever TaskController changes 
    final taskCtrl = context.watch<TaskController>();
    final tasks = taskCtrl.tasks;
    final authCtrl = context.watch<AuthController>();
    final name = authCtrl.userName.isNotEmpty
        ? authCtrl.userName.split(' ').first
        : 'Student';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: tasks.isEmpty
            ? _buildEmptyState(context, name)
            : _buildActiveState(context, taskCtrl, name),
      ),
      floatingActionButton: tasks.isEmpty ? null : _buildFAB(context),
    );
  }

  // AppBar: logo
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Row(
        children: [
          // brand logo
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.bookmark, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          // app name
          Text(
            'SmartStudentPlanner',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: [
        // notification bell
        IconButton(
          icon: Icon(
            Icons.notifications_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {},
        ),
        // avatar — taps navigate to ProfileScreen
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
      ],
      // bottom divider
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }

  // empty state
  // Shown when user has no tasks
  Widget _buildEmptyState(BuildContext context, String name) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // greeting
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              children: [
                const TextSpan(text: 'Welcome back! '),
                TextSpan(
                  text: name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          // subtitle
          Text(
            "Here's your academic snapshot for today.",
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 56),

          // SVG illustration tinted to primary
          Center(
            child: SvgPicture.asset(
              'lib/assets/images/dashboard-hero.svg',
              width: 189,
              height: 189,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
          ),

          const SizedBox(height: 36),

          // empty headline
          Center(
            child: Text(
              'No Tasks Yet!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // empty body
          Center(
            child: Text(
              'Your productivity canvas is clear. Start by '
              'adding your first task to stay ahead of your schedule.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 36),

          // add task button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NewTaskScreen()),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Add task',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
            ),
          ),

          const SizedBox(height: 28),

          // tip card
          _buildTipCard(context),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ACTIVE STATE
  // Shown when user has tasks

  Widget _buildActiveState(
    BuildContext context,
    TaskController taskCtrl,
    String name,
  ) {
    // Priority Focus first high priority incomplete task 
    // replaces hardcoded cards
    final highPriority = taskCtrl.tasks
        .where((t) => t.priority == 'High' && !t.isComplete)
        .toList();

    final smallTasks = taskCtrl.tasks
      .where((t) => t.priority != 'High' && !t.isComplete)
      .take(2)
      .toList();

    final upcoming = taskCtrl.tasks
        .where(
          (t) =>
              t.deadline != null &&
              t.deadline!.isAfter(DateTime.now()) &&
              !t.isComplete,
        )
        .take(2)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // greeting
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              children: [
                const TextSpan(text: 'Welcome back! '),
                TextSpan(
                  text: name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // subtitle
          Text(
            "Here's your academic snapshot for today.",
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 20),

          // progress banner card
          _buildProgressCard(context, taskCtrl),

          const SizedBox(height: 24),

          _buildSectionHeader(context, 'Priority Focus'),

          const SizedBox(height: 12),

          highPriority.isEmpty
              ? Text(
                  'No urgent tasks right now.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
              : _buildUrgentTaskCard(context, highPriority.first),

          const SizedBox(height: 24),

          // if (smallTasks.isNotEmpty)
          //   Row(
          //     children: smallTasks.asMap().entries.map((entry) {
          //       final t = entry.value;
          //       return Expanded(
          //         child: Padding(
          //           padding: EdgeInsets.only(
          //             right: entry.key == 0 && smallTasks.length > 1 ? 12 : 0,
          //           ),
          //           child: _buildSmallTaskCard(
          //             context,
          //             icon: Icons.book_outlined,
          //             iconBg: Theme.of(context).colorScheme.primaryContainer,
          //             iconColor: Theme.of(context).colorScheme.primary,
          //             title: t.title,
          //             subtitle: t.description,
          //           ),
          //         ),
          //       );
          //     }).toList(),
          //   ),

          // if (smallTasks.isNotEmpty) const SizedBox(height: 24),

          _buildSectionHeader(context, 'Upcoming tasks'),

          const SizedBox(height: 12),

          upcoming.isEmpty
              ? Text(
                  'No upcoming tasks.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
              : Column(
                  children: upcoming
                      .map(
                        (t) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildUpcomingTaskCard(
                            context,
                            month: _monthName(t.deadline!.month),
                            day: t.deadline!.day.toString(),
                            title: t.title,
                            subtitle: t.description,
                            progress: taskCtrl.totalCount == 0
                                ? 0.0
                                : taskCtrl.completedCount / taskCtrl.totalCount,
                          ),
                        ),
                      )
                      .toList(),
                ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // Section header: title 
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'View all',
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // progress card real completion percentage 
  Widget _buildProgressCard(BuildContext context, TaskController taskCtrl) {
    // avoid dividing by zero if no tasks
    final total = taskCtrl.totalCount;
    final completed = taskCtrl.completedCount;
    final percent = total == 0 ? 0.0 : completed / total;
    final percentInt = (percent * 100).toInt();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // left: headline + subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                percentInt >= 80
                    ? 'You are killing it'
                    : percentInt >= 50
                    ? 'Keep it up!'
                    : 'Let\'s get started!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$percentInt% of weekly goals met.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          // right: circular progress ring with % text
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // background ring
                CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 5,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                // progress ring
                CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 5,
                  color: Colors.white,
                  backgroundColor: Colors.transparent,
                ),
                Text(
                  '$percentInt%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentTaskCard(BuildContext context, Task task) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // red warning icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.priority_high,
              color: Theme.of(context).colorScheme.error,
              size: 18,
            ),
          ),

          const SizedBox(width: 12),

          // title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  task.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // due badge
          if (task.deadline != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Due',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  TimeOfDay.fromDateTime(task.deadline!).format(context),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  //  Small task card: icon title  subtitle
  Widget _buildSmallTaskCard(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // icon with coloured background
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 12),
          // task title
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          // task subtitle
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // Upcoming task card: date | title | progress ring
  Widget _buildUpcomingTaskCard(
    BuildContext context, {
    required String month,
    required String day,
    required String title,
    required String subtitle,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          // date badge
          Container(
            width: 48,
            height: 52,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  month,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  day,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          // title + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // circular progress ring
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 4,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //  FAB: add new task
  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NewTaskScreen()),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  //  Tip card: green icon | title | body
  Widget _buildTipCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // green lightbulb circle
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          // title + body
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Productivity Tip',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Break large projects into smaller '
                  '15-minute tasks to reduce mental load.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // month name helper 
  String _monthName(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    return months[month - 1];
  }
}
