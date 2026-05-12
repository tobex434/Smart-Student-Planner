import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      body: _buildEmptyState(context),
    );
  }

  // ── AppBar: logo | bell | avatar ──
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
            'ScholarSync',
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
        // avatar
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
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

  // ── Empty state body ──
  Widget _buildEmptyState(BuildContext context) {
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
              children: const [
                TextSpan(text: 'Welcome back! '),
                TextSpan(
                  text: 'Tobi',
                  style: TextStyle(fontWeight: FontWeight.bold),
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

          // SVG illustration tinted to theme primary
          Center(
            child: SvgPicture.asset(
              'assets/images/dashboard-hero.svg',
              width: 90,
              height: 90,
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

          // empty body text
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

          // add task button — full width pill
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: navigate to NewTaskScreen
              },
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

  // ── Tip card: green icon | title | body ──
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
}
