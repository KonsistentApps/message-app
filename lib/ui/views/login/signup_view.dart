import 'package:chat_app/ui/shared/ui_helpers.dart';
import 'package:chat_app/ui/widgets/busy_button.dart';
import 'package:chat_app/ui/widgets/expansion_list.dart';
import 'package:chat_app/ui/widgets/input_field.dart';
import 'package:chat_app/viewmodels/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class SignUpView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SignUpViewModel>.withConsumer(
      viewModel: SignUpViewModel(),
      builder: (context, model, child) => Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          children: <Widget>[
            verticalSpaceLarge,
            Center(
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 38,
                ),
              ),
            ),
            verticalSpaceLarge,
            InputField(
              placeholder: 'Full Name',
              controller: fullNameController,
            ),
            verticalSpaceSmall,
            InputField(
              placeholder: 'Email',
              controller: emailController,
            ),
            verticalSpaceSmall,
            InputField(
              placeholder: 'Password',
              password: true,
              controller: passwordController,
              additionalNote: 'Password has to be a minimum of 6 characters.',
            ),
            verticalSpaceSmall,
            ExpansionList<String>(
                items: ['Admin', 'User'],
                title: model.selectedRole,
                onItemSelected: model.setSelectedRole),
            verticalSpaceMedium,
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BusyButton(
                  title: 'Sign Up',
                  busy: model.busy,
                  onPressed: () {
                    model.signUp(
                        email: emailController.text,
                        password: passwordController.text,
                        fullName: fullNameController.text,
                        context: context);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
