import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:smart_student_planner/views/screens/profile_screen.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  //tswitches between focus and break option  0 = Focus, 1 = Break  TimerController replaces this later
  int _selectedMode = 0;

  //  hardcoded for now, set up TimerController later
  final int _totalSeconds = 25 * 60;
  final int _remainingSeconds = 4 * 60 + 45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // screen title
            Text(
              'Pomodoro Timer',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 20),

            // focus | break toggle
            _buildModeToggle(context),

            const SizedBox(height: 40),

            // clock dial
            Center(child: _buildDial(context)),

            const SizedBox(height: 40),

            // start button
            _buildStartButton(context),

            const SizedBox(height: 12),

            // rest button
            _buildRestButton(context),

            const SizedBox(height: 28),

            // tip card
            _buildTipCard(context),

            const SizedBox(height: 20),
          ],
        ),
      ),
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
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
    );
  }

  //  Focus | Break segmented toggle
  Widget _buildModeToggle(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        // pill container background
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          // Focus option
          _buildToggleOption(context, label: 'Focus', index: 0),
          // Break option
          _buildToggleOption(context, label: 'Break', index: 1),
        ],
      ),
    );
  }

  // the Single toggle option once selected gets primary pill, unselected is plain
  Widget _buildToggleOption(
    BuildContext context, {
    required String label,
    required int index,
  }) {
    final selected = _selectedMode == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedMode = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              // selected text white, unselected uses surface variant colour
              color: selected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }

  // Clock dial with tick marks and time display
  Widget _buildDial(BuildContext context) {
    // progress = how much time has elapsed
    final progress = 1 - (_remainingSeconds / _totalSeconds);

    return SizedBox(
      width: 260,
      height: 260,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // tick mark painter draws the clock-style lines around the edge
          CustomPaint(
            size: const Size(260, 260),
            painter: _DialPainter(
              progress: progress,
              activeColour: Theme.of(context).colorScheme.primary,
              inactiveColour: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),

          // centre content: time + label
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // countdown time
              Text(
                _formatTime(_remainingSeconds),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              // minutes label
              Text(
                'Minutes',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //  conversts seconds into MM:SS string format for display in the centre of the clock dial
  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // Start button full width primary pill
  Widget _buildStartButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: timerController.start()
        },
        icon: const Icon(Icons.play_arrow, color: Colors.white),
        label: const Text(
          'Start',
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
    );
  }

  // Rest button full width light grey pill
  Widget _buildRestButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: timerController.reset()
        },
        icon: Icon(
          Icons.restart_alt,
          color: Theme.of(context).colorScheme.primary,
        ),
        label: Text(
          'Rest',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          // light container colour gives the grey pill look
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  // Tip card:
  Widget _buildTipCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                  'Stay Sharp',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Focus for 25 minutes to complete '
                  'your current study module.',
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

// DIAL PAINTER
// CustomPainter that draws tick marks around the clock edge
// Active ticks (elapsed) = primary colour
// Inactive ticks (remaining) = outlineVariant
class _DialPainter extends CustomPainter {
  final double progress;
  final Color activeColour;
  final Color inactiveColour;

  _DialPainter({
    required this.progress,
    required this.activeColour,
    required this.inactiveColour,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centre = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // total number of tick marks around the dial
    const totalTicks = 48;

    for (int i = 0; i < totalTicks; i++) {
      // angle for each tick starts from top (negative pi/2)
      final angle = (2 * math.pi / totalTicks) * i - math.pi / 2;

      // tick is active if it falls within the elapsed progress arc
      final isActive = i / totalTicks < progress;

      final paint = Paint()
        ..color = isActive ? activeColour : inactiveColour
        ..strokeWidth = isActive ? 2.5 : 1.5
        ..strokeCap = StrokeCap.round;

      // longer ticks every 4 marks (like a clock face)
      final tickLength = (i % 4 == 0) ? 14.0 : 9.0;

      // calculate start and end points for each tick
      final outerPoint = Offset(
        centre.dx + radius * math.cos(angle),
        centre.dy + radius * math.sin(angle),
      );
      final innerPoint = Offset(
        centre.dx + (radius - tickLength) * math.cos(angle),
        centre.dy + (radius - tickLength) * math.sin(angle),
      );

      canvas.drawLine(innerPoint, outerPoint, paint);
    }
  }

  @override
  bool shouldRepaint(_DialPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
