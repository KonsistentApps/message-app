import 'package:chat_app/ui/shared/ui_helpers.dart';
import 'package:chat_app/ui/widgets/busy_button.dart';
import 'package:chat_app/ui/widgets/input_field.dart';
import 'package:chat_app/ui/widgets/text_link.dart';
import 'package:chat_app/viewmodels/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LoginViewModel>.withConsumer(
      viewModel: LoginViewModel(),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Chat App",
              ),
              automaticallyImplyLeading: false,
            ),
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: ExactAssetImage(
                        'assets/owl-2736707_1280.png',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  InputField(
                    placeholder: 'Email',
                    controller: emailController,
                    enterPressed: () {
                      model.login(
                        email: emailController.text,
                        password: passwordController.text,
                        context: context,
                      );
                    },
                  ),
                  verticalSpaceSmall,
                  InputField(
                    enterPressed: () {
                      model.login(
                        email: emailController.text,
                        password: passwordController.text,
                        context: context,
                      );
                    },
                    placeholder: 'Password',
                    password: true,
                    controller: passwordController,
                  ),
                  verticalSpaceMedium,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BusyButton(
                        title: 'Login',
                        busy: model.busy,
                        onPressed: () {
                          model.login(
                            email: emailController.text,
                            password: passwordController.text,
                            context: context,
                          );
                        },
                      )
                    ],
                  ),
                  verticalSpaceMedium,
                  TextLink(
                    'Create an Account if you\'re new.',
                    onPressed: () {
                      model.navigateToSignUp();
                    },
                  )
                ],
              ),
            )),
      ),
    );
  }
}
