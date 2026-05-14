import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';

class NewTaskScreen extends StatefulWidget {
  // null = add mode, not null = edit mode
  final Task? existingTask;
  const NewTaskScreen({super.key, this.existingTask});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  // ── form controllers ──
  late TextEditingController _titleController;
  late TextEditingController _descController;

  // ── priority: 0=Low, 1=Medium, 2=High ──
  int _selectedPriority = 1;

  // ── deadline and time — DatePicker and TimePicker wire up later ──
  DateTime _selectedDate = DateTime(2026, 5, 11);
  TimeOfDay _selectedTime = const TimeOfDay(hour: 23, minute: 59);

  // ── module chips — dynamic list, TaskController replaces later ──
  List<String> _modules = ['History', 'Thesis', 'Calculus', 'Python'];

  // ── reminders toggle ──
  bool _remindersOn = true;

  @override
  void initState() {
    super.initState();
    final task = widget.existingTask;
    if (task != null) {
      // edit mode — pre-fill all fields
      _titleController = TextEditingController(text: task.title);
      _descController = TextEditingController(text: task.description);
      _selectedPriority = ['Low', 'Medium', 'High'].indexOf(task.priority);
      _selectedDate = task.deadline ?? DateTime.now();
      _selectedTime = task.deadline != null
          ? TimeOfDay.fromDateTime(task.deadline!)
          : const TimeOfDay(hour: 23, minute: 59);
      _modules = List.from(task.modules);
      _remindersOn = task.reminders;
    } else {
      // add mode — empty fields
      _titleController = TextEditingController();
      _descController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // custom header — no AppBar
            _buildHeader(context),

            Divider(
              height: 1,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),

            // scrollable form body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // create a new task label
                    Text(
                      'Create a new task',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // hero banner illustration
                    _buildHeroBanner(context),

                    const SizedBox(height: 20),

                    // task title field
                    _buildTextField(
                      context,
                      label: 'Task Title',
                      hint: 'example "My project"',
                      controller: _titleController,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 20),

                    // description field — tall multiline
                    _buildTextField(
                      context,
                      label: 'Description',
                      hint: 'Add specific details or notes...',
                      controller: _descController,
                      maxLines: 4,
                    ),

                    const SizedBox(height: 24),

                    // priority level section
                    _buildSectionLabel(context, 'Priority Level'),
                    const SizedBox(height: 10),
                    _buildPrioritySelector(context),

                    const SizedBox(height: 20),

                    // deadline + time row
                    _buildDeadlineRow(context),

                    const SizedBox(height: 24),

                    // category / modules section
                    _buildSectionLabel(context, 'Category/ Modules'),
                    const SizedBox(height: 10),
                    _buildModuleChips(context),

                    const SizedBox(height: 24),

                    // reminders toggle
                    _buildRemindersRow(context),

                    const SizedBox(height: 28),

                    // bottom actions: delete | save
                    _buildBottomActions(context),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Custom header: ✕ | New Task | Save ✓ ──
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // close button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.error,
              size: 24,
            ),
          ),

          // title
          Text(
            widget.existingTask != null ? 'Edit Task' : 'New Task',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),

          // save text button
          GestureDetector(
            onTap: () {
              if (_titleController.text.trim().isEmpty) return;
              final taskCtrl = context.read<TaskController>();

              if (widget.existingTask != null) {
                // edit mode
                taskCtrl.updateTask(
                  id: widget.existingTask!.id!,
                  title: _titleController.text.trim(),
                  description: _descController.text.trim(),
                  priority: ['Low', 'Medium', 'High'][_selectedPriority],
                  deadline: DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  ),
                  modules: _modules,
                  reminders: _remindersOn,
                  isComplete: widget.existingTask!.isComplete,
                  createdAt: widget.existingTask!.createdAt,
                );
              } else {
                // add mode
                taskCtrl.addTask(
                  title: _titleController.text.trim(),
                  description: _descController.text.trim(),
                  priority: ['Low', 'Medium', 'High'][_selectedPriority],
                  deadline: DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  ),
                  modules: _modules,
                  reminders: _remindersOn,
                );
              }
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.primary,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Light blue hero banner with bullseye illustration placeholder ──
  Widget _buildHeroBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(
        // light primary tint — adapts to dark mode
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(
          // replace with Image.asset('assets/images/new-task-hero.svg') later
          Icons.track_changes_outlined,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  // ── Blue section label ──
  Widget _buildSectionLabel(BuildContext context, String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  // ── Underline text field ──
  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required String hint,
    required TextEditingController controller,
    required int maxLines,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 14,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.primary,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 13,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
      ),
    );
  }

  // ── Low | Medium | High priority segmented selector ──
  Widget _buildPrioritySelector(BuildContext context) {
    final priorities = ['Low', 'Medium', 'High'];
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: List.generate(priorities.length, (index) {
          final selected = _selectedPriority == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPriority = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  // selected = green to match design, unselected = transparent
                  color: selected
                      ? const Color(0xFF4CAF50)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(26),
                ),
                alignment: Alignment.center,
                child: Text(
                  priorities[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Deadline + Time pill dropdowns side by side ──
  Widget _buildDeadlineRow(BuildContext context) {
    return Row(
      children: [
        // deadline label + picker
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deadline',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              // deadline pill
              GestureDetector(
                onTap: () async {
                  // date picker
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${_monthName(_selectedDate.month)} '
                        '${_selectedDate.day}, '
                        '${_selectedDate.year}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        // time label + picker
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Time',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              // time pill
              GestureDetector(
                onTap: () async {
                  // time picker
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (picked != null) {
                    setState(() => _selectedTime = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _selectedTime.format(context),
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Module chips: blue outline with ✕ + dashed add button ──
  Widget _buildModuleChips(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        // existing module chips
        ..._modules.map((module) => _buildModuleChip(context, module)),

        // dashed add new module button
        GestureDetector(
          onTap: () => _showAddModuleDialog(context),
          child: DashedBorderChip(context: context),
        ),
      ],
    );
  }

  // ── Single module chip with ✕ remove ──
  Widget _buildModuleChip(BuildContext context, String module) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            module,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          // remove chip
          GestureDetector(
            onTap: () => setState(() => _modules.remove(module)),
            child: Icon(
              Icons.close,
              size: 14,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Add module dialog ──
  void _showAddModuleDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Add module',
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'e.g. Mathematics',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => _modules.add(controller.text.trim()));
              }
              Navigator.pop(context);
            },
            child: Text(
              'Add',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Reminders toggle row ──
  Widget _buildRemindersRow(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // green bell icon
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // label + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reminders',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  '1 day before deadline',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // toggle
          Switch(
            value: _remindersOn,
            onChanged: (val) => setState(() => _remindersOn = val),
            activeThumbColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  // Bottom actions: Delete Task 
  Widget _buildBottomActions(BuildContext context) {
    return Row(
      children: [
        // delete task — red text
        GestureDetector(
          onTap: () {
            if (widget.existingTask != null) {
              context.read<TaskController>().deleteTask(
                widget.existingTask!.id!,
              );
            }
            Navigator.pop(context);
          },
          child: Text(
            'Delete Task',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),

        const Spacer(),

        // save button blue pill
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              if (_titleController.text.trim().isEmpty) return;
              final taskCtrl = context.read<TaskController>();

              if (widget.existingTask != null) {
                // edit mode
                taskCtrl.updateTask(
                  id: widget.existingTask!.id!,
                  title: _titleController.text.trim(),
                  description: _descController.text.trim(),
                  priority: ['Low', 'Medium', 'High'][_selectedPriority],
                  deadline: DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  ),
                  modules: _modules,
                  reminders: _remindersOn,
                  isComplete: widget.existingTask!.isComplete,
                  createdAt: widget.existingTask!.createdAt,
                );
              } else {
                // add mode
                taskCtrl.addTask(
                  title: _titleController.text.trim(),
                  description: _descController.text.trim(),
                  priority: ['Low', 'Medium', 'High'][_selectedPriority],
                  deadline: DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  ),
                  modules: _modules,
                  reminders: _remindersOn,
                );
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 36),
              elevation: 0,
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // helper: month name from int 
  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

// Dashed border chip for the add module button 
class DashedBorderChip extends StatelessWidget {
  final BuildContext context;
  const DashedBorderChip({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.add,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}