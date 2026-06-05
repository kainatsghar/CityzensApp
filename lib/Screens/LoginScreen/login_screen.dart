import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomCard/custom_card.dart';
import 'package:tcs_app/custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/custom_widgets/UserTypeTabSelector/user_type_tab_selector.dart';
import 'package:tcs_app/gen/assets.gen.dart';
import 'package:tcs_app/provider/Login/login_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/routes/app_navigation_routes.dart';
import 'package:tcs_app/utils/app_colors.dart';
import 'package:tcs_app/utils/helper_function.dart';
import 'package:tcs_app/utils/validators.dart';

import '../../custom_widgets/CustomLogoCover/custom_logo_cover.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late LoginProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<LoginProvider>(
      AppNavigation.currentContext!,
      listen: false,
    );
    provider.initializeData();
  }

  @override
  void dispose() {
    provider.disposeData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
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
                          if (value.savedAccounts.isNotEmpty) ...[
                            SizedBox(height: size.height * 0.02),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Saved Accounts',
                                style: TextStyle(
                                  color: AppColors.primaryTitleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: value.savedAccounts.length,
                                itemBuilder: (context, index) {
                                  var account = value.savedAccounts[index];
                                  return GestureDetector(
                                    onTap: () =>
                                        value.loginWithSavedAccount(account),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 120,
                                          margin: const EdgeInsets.only(
                                            right: 12,
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.05,
                                                ),
                                                blurRadius: 5,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                            border: Border.all(
                                              color: AppColors.primaryBlue
                                                  .withValues(alpha: 0.2),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                account.userType == 'Teacher'
                                                    ? Icons.badge
                                                    : account.userType ==
                                                          'Parent'
                                                    ? Icons.family_restroom
                                                    : Icons.school,
                                                color: AppColors.primaryBlue,
                                                size: 24,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                account.username,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                  color: AppColors
                                                      .primaryTitleColor,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 12,
                                          child: GestureDetector(
                                            onTap: () => value
                                                .removeSavedAccount(account),
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Colors.red.withValues(
                                                  alpha: 0.1,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                size: 14,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                          ] else
                            SizedBox(height: size.height * 0.03),
                          CustomCard(
                            child: Form(
                              key: value.formKey,
                              child: Column(
                                children: <Widget>[
                                  UserTypeTabSelector(
                                    options: value.userTypeList,
                                    initialIndex: value.userTypeList.indexWhere(
                                      (t) => t.title == value.userType,
                                    ),
                                    onChanged: (index) =>
                                        provider.selectUserTypeInline(index),
                                    height: 48,
                                  ),
                                  const SizedBox(height: 12),
                                  CustomTextFormField(
                                    controller: value.userNameController,
                                    inputType: TextInputType.number,
                                    inputAction: TextInputAction.next,
                                    labelText: value.userNameLabel,
                                    hintText: value.userNameLabel,
                                    prefixIcon: Icons.person,
                                    validator: value.validator,
                                  ),
                                  const SizedBox(height: 16),
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
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () => value.toggleRememberMe(
                                          !value.rememberMe,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: Checkbox(
                                                value: value.rememberMe,
                                                onChanged: (val) =>
                                                    value.toggleRememberMe(
                                                      val ?? false,
                                                    ),
                                                activeColor:
                                                    AppColors.primaryBlue,
                                                checkColor:
                                                    AppColors.whiteColor,
                                                side: const BorderSide(
                                                  color: AppColors.primaryColor,
                                                  width: 2.0,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                                materialTapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text(
                                              'Remember Me',
                                              style: TextStyle(
                                                color:
                                                    AppColors.primaryTitleColor,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            AppNavigation.navigateTo(
                                              AppNavRoutes.forgotPasswordRoute,
                                            ),
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size.zero,
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: const Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                            color: AppColors.primaryTitleColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor:
                                                AppColors.primaryTitleColor,
                                            decorationThickness: 1.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  'New user? ',
                                  style: TextStyle(
                                    color: AppColors.softGreyText,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                InkWell(
                                  onTap: () => AppNavigation.navigateTo(
                                    AppNavRoutes.introductionRoute,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.goldenYellow,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.goldenYellow
                                              .withValues(alpha: 0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Text(
                                      "Register Now",
                                      style: TextStyle(
                                        color: AppColors.primaryDarkBlue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          FadeInUp(
                            duration: const Duration(milliseconds: 600),
                            delay: const Duration(milliseconds: 200),
                            child: InkWell(
                              onTap: () => HelperFunction.launchAlumniApp(),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: AppColors.primaryBlue.withValues(
                                      alpha: 0.15,
                                    ),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.05,
                                            ),
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: Image.asset(
                                        Assets.images.alumniAppLogo.path,
                                        width: size.width * 0.12,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Are you an Alumnus?',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 15,
                                              color: AppColors.primaryDarkBlue,
                                              letterSpacing: -0.2,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'Download the City School Alumni App',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.softGreyText,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryBlue.withValues(
                                          alpha: 0.05,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        color: AppColors.primaryBlue,
                                        size: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
}
