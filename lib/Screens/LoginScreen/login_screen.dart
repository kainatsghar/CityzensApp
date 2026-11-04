import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/CustomWidgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/CustomWidgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/CustomWidgets/CustomDialogBoxes/loading_dialog_box.dart';
import 'package:tcs_app/CustomWidgets/CustomSnackbar/custom_snackbar.dart';
import 'package:tcs_app/CustomWidgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/citizen/Provider/Login/login_provider.dart';
import 'package:tcs_app/Routes/app_navigation.dart';
import 'package:tcs_app/Routes/app_navigation_routes.dart';
import 'package:tcs_app/alumni/Constants/alumni_constants.dart';
import 'package:tcs_app/alumni/Services/alumni_login_service.dart';
import 'package:tcs_app/Utils/app_colors.dart';
import 'package:tcs_app/Utils/helper_function.dart';
import 'package:tcs_app/Utils/validators.dart';

import 'package:tcs_app/CustomWidgets/CustomLogoCover/custom_logo_cover.dart';

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
          color: AppColors.successGreenColor,
        );
        Future.delayed(const Duration(milliseconds: 300), () {
          AppNavigation.pushReplacementTo(
            AppNavRoutes.authWrapperRoute,
          );
        });
      } else {
        showSnackBar(
          response.message ?? 'Invalid email or password. Please try again.',
          color: AppColors.errorRed,
        );
      }
    } catch (e) {
      DialogBuilder.hideOpenDialog();
      showSnackBar('Error: $e', color: AppColors.errorRed);
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
    final Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'LOGIN'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Consumer<LoginProvider>(
                  builder: (context, value, _) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        children: <Widget>[
                          const CustomLogoCover(),
                          SizedBox(height: size.height * 0.03),

                          // Switch between Citizen & Alumni form based on selected User Type
                          value.userTypeController.text == 'TCS Alumni'
                              ? _buildAlumniLoginForm(value, size)
                              : _buildCitizenLoginForm(value, size),

                          Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Citizen (Student/Teacher/Parent) Login Form
  Widget _buildCitizenLoginForm(LoginProvider value, Size size) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 25.0,
          ),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Form(
            key: value.formKey,
            child: Column(
              children: <Widget>[
                CustomTextFormField(
                  controller: value.userTypeController,
                  hintText: 'User Type',
                  readOnly: true,
                  onTap: () => value.userTypeBottomSheet(),
                  suffixWidget: const ImageIcon(
                    AssetImage('assets/images/dropdown_icon.png'),
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: value.userNameController,
                  inputType: TextInputType.number,
                  inputAction: TextInputAction.next,
                  labelText: value.userNameLabel,
                  hintText: value.userNameLabel,
                  prefixIcon: Icons.person,
                  validator: value.validator,
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  controller: value.passwordController,
                  obscureText: value.obscureText,
                  inputType: TextInputType.text,
                  hintText: 'Password',
                  prefixIcon: Icons.lock,
                  inputAction: TextInputAction.done,
                  suffixWidget: GestureDetector(
                    onTap: () => value.showHidePassword(),
                    child: Icon(
                      value.obscureText
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  validator: Validators.validator,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              child: const Text(
                'Forgot your password?',
                style: TextStyle(
                  color: AppColors.primaryTitleColor,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primaryTitleColor,
                ),
              ),
              onTap: () => AppNavigation.navigateTo(
                AppNavRoutes.forgotPasswordRoute,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        CustomAppButton(
          buttonTitle: 'Login',
          onTap: () => value.login(),
        ),
        const SizedBox(height: 16),
        Row(
          children: const [
            Expanded(
              child: Divider(
                color: Colors.black26,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("OR"),
            ),
            Expanded(
              child: Divider(
                color: Colors.black26,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('New user? '),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => AppNavigation.navigateTo(
                AppNavRoutes.introductionRoute,
              ),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.paleYellow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Register here",
                  style: TextStyle(
                    color: AppColors.primaryTitleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// TCS Alumni Login Form
  Widget _buildAlumniLoginForm(LoginProvider value, Size size) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 25.0,
          ),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Form(
            key: _alumniFormKey,
            child: Column(
              children: <Widget>[
                CustomTextFormField(
                  controller: value.userTypeController,
                  hintText: 'User Type',
                  readOnly: true,
                  onTap: () => value.userTypeBottomSheet(),
                  suffixWidget: const ImageIcon(
                    AssetImage('assets/images/dropdown_icon.png'),
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: _alumniEmailController,
                  inputType: TextInputType.emailAddress,
                  inputAction: TextInputAction.next,
                  labelText: 'Alumni Email',
                  hintText: 'Enter your registered email',
                  prefixIcon: Icons.email_rounded,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  controller: _alumniPasswordController,
                  obscureText: _alumniObscure,
                  inputType: TextInputType.text,
                  hintText: 'Password',
                  prefixIcon: Icons.lock_rounded,
                  inputAction: TextInputAction.done,
                  suffixWidget: GestureDetector(
                    onTap: _showHideAlumniPassword,
                    child: Icon(
                      _alumniObscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 4) {
                      return 'Password must be at least 4 characters';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              child: const Text(
                'Forgot Alumni Password?',
                style: TextStyle(
                  color: AppColors.primaryTitleColor,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primaryTitleColor,
                ),
              ),
              onTap: () {
                HelperFunction.launchURL(
                  AlumniConstants.forgotPasswordUrl,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        CustomAppButton(
          buttonTitle: _isAlumniLoading ? 'Signing in...' : 'Login as Alumni',
          onTap: _isAlumniLoading ? () {} : _handleAlumniLogin,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.primaryLightBlue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.info_outline, size: 16, color: AppColors.primaryTitleColor),
              SizedBox(width: 8),
              Text(
                'TCS Alumni Network & Portal Access',
                style: TextStyle(
                  color: AppColors.primaryTitleColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
