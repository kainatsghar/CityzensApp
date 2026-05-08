import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/custom_widgets/CustomAppButton/custom_app_button.dart';
import 'package:tcs_app/custom_widgets/CustomAppBar/custom_app_bar.dart';
import 'package:tcs_app/custom_widgets/CustomCard/custom_card.dart';
import 'package:tcs_app/custom_widgets/CustomTextFormField/custom_text_form_field.dart';
import 'package:tcs_app/provider/Registration/registration_provider.dart';
import 'package:tcs_app/routes/app_navigation.dart';
import 'package:tcs_app/utils/validators.dart';

import 'package:tcs_app/custom_widgets/CustomNoteCard/custom_note_card.dart';
import '../../../custom_widgets/CustomLogoCover/custom_logo_cover.dart';

class RegPinCodeScreen extends StatefulWidget {
  const RegPinCodeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegPinCodeScreenState();
  }
}

class RegPinCodeScreenState extends State<RegPinCodeScreen> {
  RegistrationProvider provider = Provider.of<RegistrationProvider>(
    AppNavigation.currentContext!,
    listen: false,
  );

  @override
  void initState() {
    provider.initializePinCodeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: const CustomAppBar(title: 'SECURITY CHECK'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Consumer<RegistrationProvider>(
          builder: (context, value, _) {
            return Column(
              children: <Widget>[
                const CustomLogoCover(),
                SizedBox(height: size.height * 0.02),
                CustomCard(
                  child: Column(
                    children: <Widget>[
                      Form(
                        key: value.pinCodeFormKey,
                        child: Column(
                          children: <Widget>[
                            CustomTextFormField(
                              isEnable: false,
                              hintText: value.userNameController.text,
                              prefixIcon: Icons.person,
                            ),
                            SizedBox(height: size.height * 0.02),
                            CustomTextFormField(
                              inputType: TextInputType.number,
                              controller: value.pinCodeController,
                              hintText: 'PIN Code',
                              prefixIcon: Icons.security,
                              validator: Validators.validator,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                CustomAppButton(
                  buttonTitle: 'Next',
                  onTap: () => value.verifyPinCode(),
                ),
                SizedBox(height: size.height * 0.02),
                const CustomNoteCard(
                  notes: [
                    'TCS app will send you a message containing a PIN code you will use to verify your number.',
                    'Verification message might not reach you if promotional message are blocked from your service provider.',
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
