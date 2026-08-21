import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_flow/core/constants/app_colors.dart';
import 'package:task_flow/features/auth/data/model/user_model.dart';
import 'package:task_flow/features/auth/presentation/cubit/user_cubit.dart';
import 'package:task_flow/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  bool _isEditing = false;

  // ============================================================
  // DARK MODE COLORS
  // ============================================================

  Color _backgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);
  }

  Color _surfaceColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1E293B)
        : Colors.white;
  }

  Color _borderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF334155)
        : const Color(0xFFE2E8F0);
  }

  Color _primaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF0F172A);
  }

  Color _secondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFCBD5E1)
        : const Color(0xFF64748B);
  }

  Color _mutedTextColor(BuildContext context) {
    return const Color(0xFF94A3B8);
  }

  Color _inputDisabledColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF1F5F9);
  }

  Color _avatarBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF312E81)
        : const Color(0xFFEEF2FF);
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    final user = context.read<UserCubit>().state;

    _nameController = TextEditingController(
      text: user?.name ?? '',
    );

    _emailController = TextEditingController(
      text: user?.email ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // ============================================================
  // EDIT
  // ============================================================

  void _toggleEdit() {
    final user = context.read<UserCubit>().state;

    if (_isEditing) {
      _nameController.text = user?.name ?? '';
      _emailController.text = user?.email ?? '';
    }

    setState(() {
      _isEditing = !_isEditing;
    });
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> _saveChanges() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    final user = context.read<UserCubit>().state;

    if (user == null) {
      return;
    }

    final String newName = _nameController.text.trim();

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.nameCannotBeEmpty),
        ),
      );

      return;
    }

    final updatedUser = user.copyWith(
      name: newName,
    );

    await context.read<UserCubit>().updateUser(updatedUser);

    if (!mounted) {
      return;
    }

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.profileUpdatedSuccessfully),
      ),
    );
  }

  // ============================================================
  // CHANGE PHOTO
  // ============================================================

  void _changePhoto() {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.profilePhotoPickerWillBeAddedLater,
        ),
      ),
    );
  }

  // ============================================================
  // CHANGE PASSWORD
  // ============================================================

  void _changePassword() {
    // Change password functionality will be added later.
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return BlocBuilder<UserCubit, UserModel?>(
      builder: (context, user) {
        if (user == null) {
          return Scaffold(
            backgroundColor: _backgroundColor(context),

            appBar: AppBar(
              backgroundColor: _backgroundColor(context),
              elevation: 0,
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,

              title: Text(
                l10n.profile,
                style: TextStyle(
                  color: _primaryTextColor(context),
                ),
              ),
            ),

            body: Center(
              child: Text(
                l10n.noUserDataFound,
                style: TextStyle(
                  color: _secondaryTextColor(context),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: _backgroundColor(context),

          // ======================================================
          // APP BAR
          // ======================================================

          appBar: AppBar(
            backgroundColor: _backgroundColor(context),
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,

            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },

              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: _primaryTextColor(context),
              ),
            ),

            title: Text(
              l10n.profile,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: _primaryTextColor(context),
              ),
            ),

            actions: [
              IconButton(
                onPressed: _toggleEdit,

                icon: Icon(
                  _isEditing
                      ? Icons.close_rounded
                      : Icons.edit_outlined,

                  color: _primaryTextColor(context),
                  size: 21,
                ),
              ),
            ],
          ),

          // ======================================================
          // BODY
          // ======================================================

          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                30,
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // PROFILE HEADER
                  // ==================================================

                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.fromLTRB(
                      20,
                      24,
                      20,
                      24,
                    ),

                    decoration: BoxDecoration(
                      color: _surfaceColor(context),

                      borderRadius: BorderRadius.circular(18),

                      border: Border.all(
                        color: _borderColor(context),
                        width: 0.7,
                      ),
                    ),

                    child: Column(
                      children: [
                        // ==================================================
                        // PROFILE PHOTO
                        // ==================================================

                        Stack(
                          alignment: Alignment.bottomRight,

                          children: [
                            Container(
                              width: 104,
                              height: 104,

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                color: _avatarBackground(context),

                                border: Border.all(
                                  color: _borderColor(context),
                                  width: 1,
                                ),
                              ),

                              child:
                                  user.photoUrl != null &&
                                      user.photoUrl!.isNotEmpty
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        user.photoUrl!,
                                      ),
                                    )
                                  : Icon(
                                      Icons.person_outline_rounded,
                                      size: 52,
                                      color: _secondaryTextColor(
                                        context,
                                      ),
                                    ),
                            ),

                            // ==================================================
                            // CAMERA BUTTON
                            // ==================================================

                            Material(
                              color: AppColors.needthis,
                              shape: const CircleBorder(),

                              child: InkWell(
                                onTap: _changePhoto,
                                customBorder: const CircleBorder(),

                                child: const SizedBox(
                                  width: 34,
                                  height: 34,

                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // ==================================================
                        // NAME
                        // ==================================================

                        Text(
                          user.name,

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: _primaryTextColor(context),
                          ),
                        ),

                        const SizedBox(height: 5),

                        // ==================================================
                        // EMAIL
                        // ==================================================

                        Text(
                          user.email,

                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: _mutedTextColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ==================================================
                  // PERSONAL INFORMATION
                  // ==================================================

                  Text(
                    l10n.personalInformation,

                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _primaryTextColor(context),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // FULL NAME
                  // ==================================================

                  _buildTextField(
                    context: context,
                    label: l10n.fullName,
                    controller: _nameController,
                    icon: Icons.person_outline_rounded,
                    enabled: _isEditing,
                  ),

                  const SizedBox(height: 13),

                  // ==================================================
                  // EMAIL
                  // ==================================================

                  _buildTextField(
                    context: context,
                    label: l10n.email,
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    enabled: false,
                  ),

                  const SizedBox(height: 24),

                  // ==================================================
                  // SAVE BUTTON
                  // ==================================================

                  if (_isEditing)
                    SizedBox(
                      width: double.infinity,
                      height: 52,

                      child: ElevatedButton(
                        onPressed: _saveChanges,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.needthis,
                          foregroundColor: Colors.white,
                          elevation: 0,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        child: Text(
                          l10n.saveChanges,

                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                  if (_isEditing)
                    const SizedBox(height: 24),

                  // ==================================================
                  // SECURITY
                  // ==================================================

                  Text(
                    l10n.security,

                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _primaryTextColor(context),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // CHANGE PASSWORD
                  // ==================================================

                  _buildActionCard(
                    context: context,
                    icon: Icons.lock_outline_rounded,
                    title: l10n.changePassword,
                    subtitle: l10n.updateYourAccountPassword,
                    onTap: _changePassword,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
  }) {
    final Color primaryText = _primaryTextColor(context);
    final Color secondaryText = _secondaryTextColor(context);
    final Color border = _borderColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          label,

          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: secondaryText,
          ),
        ),

        const SizedBox(height: 7),

        TextField(
          controller: controller,
          enabled: enabled,

          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: primaryText,
          ),

          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              size: 19,

              color: enabled
                  ? AppColors.needthis
                  : _mutedTextColor(context),
            ),

            filled: true,

            fillColor: enabled
                ? _surfaceColor(context)
                : _inputDisabledColor(context),

            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(
                color: border,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(
                color: border,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(
                color: AppColors.needthis,
                width: 1,
              ),
            ),

            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(
                color: border,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ACTION CARD
  // ============================================================

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: _surfaceColor(context),

      borderRadius: BorderRadius.circular(14),

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(14),

        child: Container(
          padding: const EdgeInsets.all(14),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),

            border: Border.all(
              color: _borderColor(context),
              width: 0.7,
            ),
          ),

          child: Row(
            children: [
              // ==================================================
              // ICON
              // ==================================================

              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color: AppColors.needthis.withValues(
                    alpha: 0.08,
                  ),

                  borderRadius: BorderRadius.circular(11),
                ),

                child: Icon(
                  icon,
                  size: 20,
                  color: AppColors.needthis,
                ),
              ),

              const SizedBox(width: 12),

              // ==================================================
              // TEXT
              // ==================================================

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      title,

                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _primaryTextColor(context),
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,

                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: _mutedTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),

              // ==================================================
              // ARROW
              // ==================================================

              Icon(
                Icons.chevron_right_rounded,
                size: 20,

                color:
                    Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF475569)
                    : const Color(0xFFCBD5E1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}