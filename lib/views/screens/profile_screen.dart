import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ── hardcoded for now — AuthController replaces in Phase 3 ──
  final _nameController =
      TextEditingController(text: 'Bankole Tobi Odumosu');
  final _emailController =
      TextEditingController(text: 'banky.Odumobi@panatlantic.edu');
  final _courseController =
      TextEditingController(text: 'Botany & Fisheries');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            const SizedBox(height: 24),

            // avatar section
            _buildAvatar(context),

            const SizedBox(height: 32),

            // form fields
            _buildFormFields(context),

            const SizedBox(height: 28),

            // save changes button
            _buildSaveButton(context),

            const SizedBox(height: 12),

            // change password button
            _buildChangePasswordButton(context),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── AppBar: back arrow | Profile title | search ──
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Profile',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
          ),
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

  // Avatar: circle 
  Widget _buildAvatar(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            // blue ring border
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                // placeholder swap later with real image when auth added
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.person,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),

            // edit pencil badge
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // edit photo link
        GestureDetector(
          onTap: () {
            // TODO: image picker
          },
          child: Text(
            'Edit photo',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // Three underline text fields
  Widget _buildFormFields(BuildContext context) {
    return Column(
      children: [
        // full name
        _buildTextField(
          context,
          label: 'Full name',
          controller: _nameController,
          readOnly: false,
        ),

        const SizedBox(height: 20),

        // university email  locked
        _buildTextField(
          context,
          label: 'University email',
          controller: _emailController,
          readOnly: true,
          suffixIcon: Icon(
            Icons.lock_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),

        const SizedBox(height: 20),

        // course / major
        _buildTextField(
          context,
          label: 'Course/ Major',
          controller: _courseController,
          readOnly: false,
        ),
      ],
    );
  }

  //  Underline style text field 
  Widget _buildTextField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required bool readOnly,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      style: TextStyle(
        fontSize: 15,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.primary,
        ),
        suffixIcon: suffixIcon,
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
        filled: readOnly,
        fillColor: readOnly
            ? Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.3)
            : null,
      ),
    );
  }

  //  Save changes — full width primary pill
  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: AuthController.saveProfile()
        },
        icon: const Icon(Icons.save_outlined, color: Colors.white),
        label: const Text(
          'Save changes',
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

  //  Change password — ghost pill
  Widget _buildChangePasswordButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: navigate to change password screen
        },
        icon: Icon(
          Icons.lock_reset_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
        label: Text(
          'Change password',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}