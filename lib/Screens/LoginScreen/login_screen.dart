import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/CustomWidgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/citizen/Provider/Login/login_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/alumni/Constants/alumni_constants.dart';
import 'package:tcs_app/alumni/Services/alumni_login_service.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/app_themes.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/Utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Alumni Form State
  final _alumniFormKey = GlobalKey<FormState>();
  final TextEditingController _alumniEmailController = TextEditingController();
  final TextEditingController _alumniPasswordController =
      TextEditingController();
  final FocusNode _alumniEmailFocus = FocusNode();
  final FocusNode _alumniPasswordFocus = FocusNode();
  final FocusNode _citizenUserFocus = FocusNode();
  final FocusNode _citizenPasswordFocus = FocusNode();

  bool _alumniObscure = true;
  bool _isAlumniLoading = false;

  LoginProvider get provider => Provider.of<LoginProvider>(
        AppNavigation.currentContext!,
        listen: false,
      );

  @override
  void initState() {
    super.initState();
    provider.initializeData();
  }

  @override
  void dispose() {
    _alumniEmailController.dispose();
    _alumniPasswordController.dispose();
    _alumniEmailFocus.dispose();
    _alumniPasswordFocus.dispose();
    _citizenUserFocus.dispose();
    _citizenPasswordFocus.dispose();
    provider.disposeData();
    super.dispose();
  }

  void _showHideAlumniPassword() {
    setState(() {
      _alumniObscure = !_alumniObscure;
    });
  }

  Future<void> _handleAlumniLogin() async {
    if (!(_alumniFormKey.currentState?.validate() ?? false)) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isAlumniLoading = true;
    });
    DialogBuilder.showLoadingIndicator();

    try {
      final response = await AlumniLoginService.loginRequest(
        email: _alumniEmailController.text.trim(),
        password: _alumniPasswordController.text,
      );

      DialogBuilder.hideOpenDialog();

      if (response.isSuccessful) {
        showSnackBar(
          response.message ?? 'Login Successful! Welcome to TCS Alumni.',
          color: AppColors.green,
        );
        Future.delayed(const Duration(milliseconds: 300), () {
          AppNavigation.pushReplacementTo(
            AppNavRoutes.authWrapperRoute,
          );
        });
      } else {
        showSnackBar(
          response.message ?? 'Invalid email or password. Please try again.',
          color: AppColors.red,
        );
      }
    } catch (e) {
      DialogBuilder.hideOpenDialog();
      showSnackBar('Error: $e', color: AppColors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isAlumniLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      body: SafeArea(
        bottom: false,
        child: Consumer<LoginProvider>(
          builder: (context, loginProvider, _) {
            final String currentRole = loginProvider.userTypeController.text;
            final bool isAlumni =
                (currentRole == 'TCS Alumni' || currentRole == 'Alumni');

            return Column(
              children: [
                // Top Blue Header with TCS Crest
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 26),
                  child: Center(
                    child: Image.asset(
                      'assets/images/tcs_logo_white.png',
                      height: 90,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Overlapping White Sheet
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, -2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Titles
                          Text(
                            'Log in to Cityzens',
                            style: AppThemes.sora(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Choose who you are',
                            style: AppThemes.roboto(
                              fontSize: 13,
                              color: AppColors.muted,
                            ),
                          ),
                          const SizedBox(height: 18),

                          // 2x2 Role Sticker Cards
                          _buildRoleSelector(loginProvider, currentRole),
                          const SizedBox(height: 18),

                          // Login Form Fields
                          isAlumni
                              ? _buildAlumniForm(context)
                              : _buildCitizenForm(loginProvider, context),

                          const SizedBox(height: 12),

                          // Forgot Password Link
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: isAlumni
                                  ? () => HelperFunction.launchURL(
                                        AlumniConstants.forgotPasswordUrl,
                                      )
                                  : () => AppNavigation.navigateTo(
                                        AppNavRoutes.forgotPasswordRoute,
                                      ),
                              borderRadius: BorderRadius.circular(4),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                  horizontal: 2.0,
                                ),
                                child: Text(
                                  'Forgot password?',
                                  style: AppThemes.sora(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Yellow Log in Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: (isAlumni && _isAlumniLoading)
                                  ? null
                                  : () {
                                      if (isAlumni) {
                                        _handleAlumniLogin();
                                      } else {
                                        loginProvider.login();
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.yellow,
                                foregroundColor: AppColors.ink,
                                disabledBackgroundColor:
                                    AppColors.yellow.withValues(alpha: 0.6),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: (isAlumni && _isAlumniLoading)
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: AppColors.ink,
                                      ),
                                    )
                                  : Text(
                                      isAlumni
                                          ? 'Log in as Alumni'
                                          : 'Log in',
                                      style: AppThemes.sora(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Register Footer
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'New to Cityzens? ',
                                  style: AppThemes.roboto(
                                    fontSize: 13,
                                    color: AppColors.muted,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => AppNavigation.navigateTo(
                                    AppNavRoutes.introductionRoute,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    child: Text(
                                      'Register',
                                      style: AppThemes.sora(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Alumni Information Badge (when Alumni is selected)
                          if (isAlumni) ...[
                            const SizedBox(height: 18),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.blueTint,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.info_outline_rounded,
                                      size: 16,
                                      color: AppColors.blue,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'TCS Alumni Network & Portal Access',
                                      style: AppThemes.roboto(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 2x2 Raised Role Sticker Cards Grid
  Widget _buildRoleSelector(LoginProvider provider, String currentRole) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildRoleCard(
                title: 'Student',
                icon: Icons.person_rounded,
                isSelected: currentRole == 'Student',
                onTap: () => provider.selectRole('Student'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRoleCard(
                title: 'Parent',
                icon: Icons.visibility_outlined,
                isSelected: currentRole == 'Parent',
                onTap: () => provider.selectRole('Parent'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildRoleCard(
                title: 'Teacher',
                icon: Icons.co_present_rounded,
                isSelected: currentRole == 'Teacher',
                onTap: () => provider.selectRole('Teacher'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRoleCard(
                title: 'Alumni',
                icon: Icons.school_rounded,
                isSelected:
                    currentRole == 'TCS Alumni' || currentRole == 'Alumni',
                onTap: () => provider.selectRole('TCS Alumni'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Individual Raised Sticker Card with Tick Checkmark
  Widget _buildRoleCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.blueTint : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? AppColors.blue : const Color(0xFFDCDDDD),
                width: isSelected ? 2.5 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected ? AppColors.blue : const Color(0xFFDCDDDD),
                  offset: const Offset(0, 3.5),
                  blurRadius: 0,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isSelected ? AppColors.blue : AppColors.ink,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: AppThemes.sora(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? AppColors.blue : AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isSelected)
          Positioned(
            top: -7,
            right: -7,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.blue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    offset: const Offset(0, 1.5),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 13,
                color: AppColors.yellow,
              ),
            ),
          ),
      ],
    );
  }

  /// Citizen Form (Student / Parent / Teacher)
  Widget _buildCitizenForm(LoginProvider provider, BuildContext context) {
    final String currentRole = provider.userTypeController.text;
    String fieldLabel = 'Roll number';
    String hintText = 'e.g. 194820';
    IconData icon = Icons.person_outline_rounded;
    TextInputType keyboardType = TextInputType.number;

    if (currentRole == 'Parent') {
      fieldLabel = 'Father CNIC number';
      hintText = '42101-1234567-1';
      icon = Icons.badge_outlined;
      keyboardType = TextInputType.number;
    } else if (currentRole == 'Teacher') {
      fieldLabel = 'Employee number';
      hintText = 'e.g. 20417';
      icon = Icons.badge_outlined;
      keyboardType = TextInputType.number;
    }

    return Form(
      key: provider.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Identifier Field
          Text(
            fieldLabel,
            style: AppThemes.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: provider.userNameController,
            focusNode: _citizenUserFocus,
            keyboardType: keyboardType,
            textInputAction: TextInputAction.next,
            validator: provider.validator,
            style: AppThemes.roboto(
              fontSize: 14,
              color: AppColors.ink,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(icon, color: AppColors.blue, size: 20),
            ),
          ),
          const SizedBox(height: 14),

          // Password Field
          Text(
            'Password',
            style: AppThemes.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: provider.passwordController,
            focusNode: _citizenPasswordFocus,
            obscureText: provider.obscureText,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            validator: Validators.validator,
            onFieldSubmitted: (_) => provider.login(),
            style: AppThemes.roboto(
              fontSize: 14,
              color: AppColors.ink,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: '••••••••',
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.blue,
                size: 20,
              ),
              suffixIcon: IconButton(
                onPressed: () => provider.showHidePassword(),
                icon: Icon(
                  provider.obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.muted,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Alumni Login Form
  Widget _buildAlumniForm(BuildContext context) {
    return Form(
      key: _alumniFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Alumni Email Field
          Text(
            'Alumni Email',
            style: AppThemes.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _alumniEmailController,
            focusNode: _alumniEmailFocus,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Enter a valid email address';
              }
              return null;
            },
            style: AppThemes.roboto(
              fontSize: 14,
              color: AppColors.ink,
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration(
              hintText: 'Enter registered email',
              prefixIcon: Icon(
                Icons.mail_outline_rounded,
                color: AppColors.blue,
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Alumni Password Field
          Text(
            'Password',
            style: AppThemes.roboto(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _alumniPasswordController,
            focusNode: _alumniPasswordFocus,
            obscureText: _alumniObscure,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (value.length < 4) {
                return 'Password must be at least 4 characters';
              }
              return null;
            },
            onFieldSubmitted: (_) => _handleAlumniLogin(),
            style: AppThemes.roboto(
              fontSize: 14,
              color: AppColors.ink,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: '••••••••',
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.blue,
                size: 20,
              ),
              suffixIcon: IconButton(
                onPressed: _showHideAlumniPassword,
                icon: Icon(
                  _alumniObscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.muted,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
