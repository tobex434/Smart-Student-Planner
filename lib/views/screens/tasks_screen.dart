import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  // toggle to preview both states — TaskController replaces this later
  static const bool _hasTasks = true;

  //  this tracks which filter chip is selected
  int _selectedFilter = 0;

  //  filter options — hardcoded for now, modules come from TaskController later
  final List<String> _filters = ['All tasks (8)', 'Ethics', 'History'];

  // ── search controller ──
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    // always dispose controllers to free memory
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      body: _hasTasks ? _buildActiveState(context) : _buildEmptyState(context),
      floatingActionButton: _buildFAB(context),
    );
  }

  //  AppBat design
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
        // search icon
        IconButton(
          icon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {},
        ),
        // filter icon
        IconButton(
          icon: Icon(Icons.tune, color: Theme.of(context).colorScheme.primary),
          onPressed: () {},
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

  // EMPTY STATE

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // search bar
              _buildSearchBar(context),
              const SizedBox(height: 12),
              // filter chips
              _buildFilterChips(context),
            ],
          ),
        ),

        // centred empty content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SVG illustration
                SvgPicture.asset(
                  'lib/assets/images/tasks-hero.svg',
                  width: 189,
                  height: 189,
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),

                const SizedBox(height: 28),

                // headline
                Text(
                  'All good!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 10),

                // body
                Text(
                  'You have no tasks right now. Enjoy your free time '
                  'or start planning your next achievement.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 32),

                // add task button
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  
  // ACTIVE STATE
  

  Widget _buildActiveState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // tasks title + search/filter icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tasks',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // filter chips row
              _buildFilterChips(context),

              const SizedBox(height: 12),

              // deadline alert banner
              _buildDeadlineBanner(context),

              const SizedBox(height: 4),
            ],
          ),
        ),

        // scrollable task list
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            children: [
              const SizedBox(height: 12),

              // today's task cards
              _buildTaskCard(
                context,
                moduleTag: 'CS 301',
                moduleColour: const Color(0xFFEDE7F6),
                moduleTextColour: const Color(0xFF512DA8),
                time: '11:59 PM',
                title: 'Algorithm Complexity Report',
                subtitle:
                    'Submit final PDF to the student portal. Include Big O proofs.',
                progress: null,
              ),

              const SizedBox(height: 12),

              _buildTaskCard(
                context,
                moduleTag: 'CS 351',
                moduleColour: const Color(0xFFE8F5E9),
                moduleTextColour: const Color(0xFF2E7D32),
                time: '02:25 PM',
                title: 'Programming Test A',
                subtitle: 'Hall B, Room 204',
                progress: null,
                showLocation: true,
              ),

              const SizedBox(height: 12),

              _buildTaskCard(
                context,
                moduleTag: 'JS 101',
                moduleColour: const Color(0xFFFFEBEE),
                moduleTextColour: const Color(0xFFC62828),
                time: '04:15 PM',
                title: 'Javascript 101',
                subtitle: 'Hall C, Room 214',
                progress: null,
                showLocation: true,
              ),

              const SizedBox(height: 20),

              // upcoming section header
              Text(
                'Upcoming tasks',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 12),

              // upcoming task rows
              _buildUpcomingRow(
                context,
                month: 'MAY',
                day: '15',
                title: 'Modern History Essay',
                subtitle: 'Still in drafting stage',
                progress: 0.84,
              ),

              const SizedBox(height: 10),

              _buildUpcomingRow(
                context,
                month: 'MAY',
                day: '17',
                title: 'CSS Assignment',
                subtitle: 'Nothing much has been done',
                progress: 0.04,
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }

  //  Search bar 
  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search your tasks',
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontSize: 14,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }

  //  Filter chips row 
  Widget _buildFilterChips(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filters.length, (index) {
          final selected = _selectedFilter == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = index),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  // selected chip is primary filled, unselected is outlined
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Text(
                  _filters[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: selected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  //  Deadline alert banner 
  Widget _buildDeadlineBanner(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // warning text
        Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              'Deadline is today!',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
        ),
        // task count badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '8 Task left',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }

  //  Task card: module tag | time | title | subtitle | progress 
  Widget _buildTaskCard(
    BuildContext context, {
    required String moduleTag,
    required Color moduleColour,
    required Color moduleTextColour,
    required String time,
    required String title,
    required String subtitle,
    double? progress,
    bool showLocation = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top row: module chip + time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // module tag chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: moduleColour,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  moduleTag,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: moduleTextColour,
                  ),
                ),
              ),
              // time
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // task title
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 4),

          // subtitle with optional location icon
          Row(
            children: [
              if (showLocation) ...[
                Icon(
                  Icons.location_on_outlined,
                  size: 13,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 3),
              ],
              Expanded(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //  Upcoming task row: date badge | title | progress ring 
  Widget _buildUpcomingRow(
    BuildContext context, {
    required String month,
    required String day,
    required String title,
    required String subtitle,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          // date badge
          Container(
            width: 44,
            height: 48,
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
                    fontSize: 9,
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

          const SizedBox(width: 12),

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
                const SizedBox(height: 2),
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

          // progress ring
          SizedBox(
            width: 44,
            height: 44,
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
                    fontSize: 10,
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
      onPressed: () {
        // TODO: navigate to NewTaskScreen
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
