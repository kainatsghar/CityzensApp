import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tcs_app/components/OSRegistrationComponents/guardian_info_form.dart';
import 'package:tcs_app/components/OSRegistrationComponents/previous_school_form.dart';
import 'package:tcs_app/components/OSRegistrationComponents/student_admission_form.dart';
import 'package:tcs_app/components/OSRegistrationComponents/student_info_form.dart';
import 'package:tcs_app/Provider/OSRegistration/os_registration_provider.dart';

class OSRegistrationComponent extends StatelessWidget {
  const OSRegistrationComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<OSRegistrationProvider>(
        builder: (context, value, _) {
          return Stepper(
            currentStep: value.currentStep,
            steps: [
              Step(
                title: const Text('Student', style: TextStyle(fontSize: 20.0)),
                content: const StudentInfoForm(),
                state: value.getState(0),
                isActive: value.currentStep >= 0,
              ),
              Step(
                title: const Text(
                  'Admission',
                  style: TextStyle(fontSize: 20.0),
                ),
                content: const StudentAdmissionForm(),
                state: value.getState(1),
                isActive: value.currentStep >= 1,
              ),
              Step(
                title: const Text(
                  'Previous School',
                  style: TextStyle(fontSize: 20.0),
                ),
                content: const PreviousSchoolFrom(),
                state: value.getState(2),
                isActive: value.currentStep >= 2,
              ),
              Step(
                title: const Text('Guardian', style: TextStyle(fontSize: 20.0)),
                content: const GuardianInfoForm(),
                state: value.getState(3),
                isActive: value.currentStep >= 3,
              ),
            ],
            type: StepperType.vertical,
            onStepCancel: () => value.cancelled(),
            onStepTapped: (v) => value.tapped(v),
            onStepContinue: () => value.continued(),
          );
        },
      ),
    );
  }
}
