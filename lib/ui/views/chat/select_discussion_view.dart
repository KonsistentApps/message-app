import 'package:chat_app/viewmodels/select_discussion_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';

class SelectDiscussionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SelectDiscussionViewModel>.withConsumer(
      viewModel: SelectDiscussionViewModel(),
      onModelReady: (model) => model.fetchAllUsers(context),
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Users to chat with",
              ),
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => model.busy ? false : model.logout(),
                )
              ],
            ),
            backgroundColor: Colors.white,
            body: model.userList == null
                ? Center(child: Text("No available Users"))
                : ListView.builder(
                    itemCount: model.userList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(model.userList[index].fullName),
                        onTap: () =>
                            model.continueOrStartDiscussion(index, context),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
