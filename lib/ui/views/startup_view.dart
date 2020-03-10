import 'package:chat_app/ui/shared/ui_helpers.dart';
import 'package:chat_app/viewmodels/startup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class StartUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<StartUpViewModel>.withConsumer(
      viewModel: StartUpViewModel(),
      onModelReady: (model) => model.handleStartUpLogic(),
      builder: (context, model, child) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: 300,
                height: 300,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: CircleAvatar(
                      radius: 200,
                      backgroundImage: ExactAssetImage(
                        'assets/owl-2736707_1280.png',
                      ),
                    ),
                  ),
                ),
              ),
              verticalSpaceMedium,
              CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(Color(0xff19c7c1)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
