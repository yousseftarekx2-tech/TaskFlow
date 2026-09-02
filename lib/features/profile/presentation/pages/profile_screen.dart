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

  @override
  void initState() {
    super.initState();

    final user = context.read<UserCubit>().state;

    _nameController = TextEditingController(text: user?.name ?? '');

    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

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

  Future<void> _saveChanges() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final user = context.read<UserCubit>().state;

    if (user == null) {
      return;
    }

    final String newName = _nameController.text.trim();

    if (newName.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.nameCannotBeEmpty)));

      return;
    }

    final updatedUser = user.copyWith(name: newName);

    await context.read<UserCubit>().updateUser(updatedUser);

    if (!mounted) {
      return;
    }

    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.profileUpdatedSuccessfully)));
  }

  void _changePhoto() {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.profilePhotoPickerWillBeAddedLater)),
    );
  }

  void _changePassword() {}

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Size screenSize = MediaQuery.sizeOf(context);

    final bool isSmallWidth = screenSize.width < 360;
    final bool isShortScreen = screenSize.height < 700;

    final double horizontalPadding = isSmallWidth ? 16 : 20;
    final double bodyTopPadding = isShortScreen ? 8 : 12;
    final double bodyBottomPadding = isShortScreen ? 20 : 30;

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
                style: TextStyle(color: _primaryTextColor(context)),
              ),
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  l10n.noUserDataFound,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _secondaryTextColor(context)),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: _backgroundColor(context),
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
                size: isSmallWidth ? 17 : 18,
                color: _primaryTextColor(context),
              ),
            ),
            title: Text(
              l10n.profile,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isSmallWidth ? 18 : 19,
                fontWeight: FontWeight.w700,
                color: _primaryTextColor(context),
              ),
            ),
            actions: [
              IconButton(
                onPressed: _toggleEdit,
                icon: Icon(
                  _isEditing ? Icons.close_rounded : Icons.edit_outlined,
                  color: _primaryTextColor(context),
                  size: isSmallWidth ? 20 : 21,
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                bodyTopPadding,
                horizontalPadding,
                bodyBottomPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      isSmallWidth ? 16 : 20,
                      isShortScreen ? 20 : 24,
                      isSmallWidth ? 16 : 20,
                      isShortScreen ? 20 : 24,
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
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: isSmallWidth ? 92 : 104,
                              height: isSmallWidth ? 92 : 104,
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
                                  ? ClipOval(
                                      child: Image.network(
                                        user.photoUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Icon(
                                                Icons.person_outline_rounded,
                                                size: isSmallWidth ? 46 : 52,
                                                color: _secondaryTextColor(
                                                  context,
                                                ),
                                              );
                                            },
                                      ),
                                    )
                                  : Icon(
                                      Icons.person_outline_rounded,
                                      size: isSmallWidth ? 46 : 52,
                                      color: _secondaryTextColor(context),
                                    ),
                            ),
                            Material(
                              color: AppColors.needthis,
                              shape: const CircleBorder(),
                              child: InkWell(
                                onTap: _changePhoto,
                                customBorder: const CircleBorder(),
                                child: SizedBox(
                                  width: isSmallWidth ? 31 : 34,
                                  height: isSmallWidth ? 31 : 34,
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: isSmallWidth ? 16 : 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isShortScreen ? 11 : 14),
                        Text(
                          user.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isSmallWidth ? 18 : 20,
                            fontWeight: FontWeight.w800,
                            color: _primaryTextColor(context),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          user.email,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isSmallWidth ? 11 : 12,
                            fontWeight: FontWeight.w500,
                            color: _mutedTextColor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: isShortScreen ? 20 : 24),
                  Text(
                    l10n.personalInformation,
                    style: TextStyle(
                      fontSize: isSmallWidth ? 13 : 14,
                      fontWeight: FontWeight.w700,
                      color: _primaryTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    context: context,
                    label: l10n.fullName,
                    controller: _nameController,
                    icon: Icons.person_outline_rounded,
                    enabled: _isEditing,
                    isSmallWidth: isSmallWidth,
                  ),
                  const SizedBox(height: 13),
                  _buildTextField(
                    context: context,
                    label: l10n.email,
                    controller: _emailController,
                    icon: Icons.email_outlined,
                    enabled: false,
                    isSmallWidth: isSmallWidth,
                  ),
                  SizedBox(height: isShortScreen ? 20 : 24),
                  if (_isEditing) ...[
                    SizedBox(
                      width: double.infinity,
                      height: isSmallWidth ? 48 : 52,
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isSmallWidth ? 13 : 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isShortScreen ? 20 : 24),
                  ],
                  Text(
                    l10n.security,
                    style: TextStyle(
                      fontSize: isSmallWidth ? 13 : 14,
                      fontWeight: FontWeight.w700,
                      color: _primaryTextColor(context),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildActionCard(
                    context: context,
                    icon: Icons.lock_outline_rounded,
                    title: l10n.changePassword,
                    subtitle: l10n.updateYourAccountPassword,
                    onTap: _changePassword,
                    isSmallWidth: isSmallWidth,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool enabled,
    required bool isSmallWidth,
  }) {
    final Color primaryText = _primaryTextColor(context);
    final Color secondaryText = _secondaryTextColor(context);
    final Color border = _borderColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: isSmallWidth ? 11 : 12,
            fontWeight: FontWeight.w700,
            color: secondaryText,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          enabled: enabled,
          maxLines: 1,
          style: TextStyle(
            fontSize: isSmallWidth ? 12 : 13,
            fontWeight: FontWeight.w500,
            color: primaryText,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              size: isSmallWidth ? 18 : 19,
              color: enabled ? AppColors.needthis : _mutedTextColor(context),
            ),
            filled: true,
            fillColor: enabled
                ? _surfaceColor(context)
                : _inputDisabledColor(context),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isSmallWidth ? 12 : 14,
              vertical: isSmallWidth ? 13 : 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.needthis, width: 1),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: border),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isSmallWidth,
  }) {
    return Material(
      color: _surfaceColor(context),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: EdgeInsets.all(isSmallWidth ? 12 : 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _borderColor(context), width: 0.7),
          ),
          child: Row(
            children: [
              Container(
                width: isSmallWidth ? 38 : 42,
                height: isSmallWidth ? 38 : 42,
                decoration: BoxDecoration(
                  color: AppColors.needthis.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  size: isSmallWidth ? 18 : 20,
                  color: AppColors.needthis,
                ),
              ),
              SizedBox(width: isSmallWidth ? 10 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isSmallWidth ? 12 : 13,
                        fontWeight: FontWeight.w700,
                        color: _primaryTextColor(context),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isSmallWidth ? 9 : 10,
                        fontWeight: FontWeight.w500,
                        color: _mutedTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right_rounded,
                size: isSmallWidth ? 19 : 20,
                color: Theme.of(context).brightness == Brightness.dark
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
