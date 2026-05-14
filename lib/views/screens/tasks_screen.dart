import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import 'new_task_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  //  selected filter index matches controller filter strings
  int _selectedFilter = 0;
  final List<String> _filterLabels = ['All tasks', 'Today', 'Completed'];
  final List<String> _filterKeys = ['all', 'today', 'completed'];

  // search controller
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // load all tasks when screen first opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskController>().loadTasks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // watch rebuilds whenever TaskController notifies
    final taskCtrl = context.watch<TaskController>();
    final tasks = taskCtrl.tasks;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      body: tasks.isEmpty
          ? _buildEmptyState(context, taskCtrl)
          : _buildActiveState(context, taskCtrl, tasks),
      floatingActionButton: _buildFAB(context),
    );
  }

  //  AppBar design
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

  Widget _buildEmptyState(BuildContext context, TaskController taskCtrl) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // search bar
              _buildSearchBar(context, taskCtrl),
              const SizedBox(height: 12),
              // filter chips
              _buildFilterChips(context, taskCtrl),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ACTIVE STATE

  Widget _buildActiveState(
    BuildContext context,
    TaskController taskCtrl,
    List<Task> tasks,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // tasks title
              Text(
                'Tasks',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 12),

              // search bar  calls controller on change
              _buildSearchBar(context, taskCtrl),

              const SizedBox(height: 12),

              // filter chips calls controller setFilter
              _buildFilterChips(context, taskCtrl),

              const SizedBox(height: 12),

              // deadline banner shows if any task due today
              if (taskCtrl.dueTodayCount > 0)
                _buildDeadlineBanner(context, taskCtrl),

              const SizedBox(height: 4),
            ],
          ),
        ),

        // scrollable real task list
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: ListView.separated(
              key: ValueKey(tasks.length),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: tasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return _buildTaskCard(context, task, taskCtrl);
              },
            ),
          ),
        ),
      ],
    );
  }

  //  Search bar
  Widget _buildSearchBar(BuildContext context, TaskController taskCtrl) {
    return TextField(
      controller: _searchController,
      onChanged: (value) => taskCtrl.setSearch(value),
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
        // clear button when search is active
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  _searchController.clear();
                  taskCtrl.clearSearch();
                },
              )
            : null,
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
  Widget _buildFilterChips(BuildContext context, TaskController taskCtrl) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filterLabels.length, (index) {
          final selected = _selectedFilter == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedFilter = index);
                // call controller with the filter key
                taskCtrl.setFilter(_filterKeys[index]);
              },
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
                  // show count on All tasks chip
                  index == 0
                      ? 'All tasks (${taskCtrl.totalCount})'
                      : _filterLabels[index],
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
  Widget _buildDeadlineBanner(BuildContext context, TaskController taskCtrl) {
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
            '${taskCtrl.dueTodayCount} task left',
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

  Widget _buildTaskCard(
    BuildContext context,
    Task task,
    TaskController taskCtrl,
  ) {
    return Dismissible(
      // unique key per task
      key: Key(task.id.toString()),
      direction: DismissDirection.endToStart,
      // red delete background on swipe
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => taskCtrl.deleteTask(task.id!),
      child: GestureDetector(
        // tap to edit
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NewTaskScreen(existingTask: task)),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // top row: module chip + time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // first module tag or empty
                  task.modules.isNotEmpty
                      ? _buildModuleTag(context, task.modules.first)
                      : const SizedBox(),
                  // deadline time
                  if (task.deadline != null)
                    Text(
                      TimeOfDay.fromDateTime(task.deadline!).format(context),
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
                task.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  // strike through if complete
                  decoration: task.isComplete
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: task.isComplete
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Theme.of(context).colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 4),

              // description
              Text(
                task.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 10),

              // bottom row: complete toggle + priority badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // complete toggle
                  GestureDetector(
                    onTap: () => taskCtrl.toggleComplete(task),
                    child: Row(
                      children: [
                        Icon(
                          task.isComplete
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          size: 18,
                          color: task.isComplete
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          task.isComplete ? 'Completed' : 'Mark complete',
                          style: TextStyle(
                            fontSize: 12,
                            color: task.isComplete
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // priority badge
                  _buildPriorityBadge(context, task.priority),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // module tag chip
  Widget _buildModuleTag(BuildContext context, String module) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        module,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  // priority badge
  Widget _buildPriorityBadge(BuildContext context, String priority) {
    Color bg;
    Color fg;

    switch (priority) {
      case 'High':
        bg = Theme.of(context).colorScheme.errorContainer;
        fg = Theme.of(context).colorScheme.error;
        break;
      case 'Low':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        break;
      case 'Medium':
      default:
        bg = const Color(0xFFFFF3E0);
        fg = const Color(0xFFE65100);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }

  //  Upcoming task row: date badge
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
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NewTaskScreen()),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
