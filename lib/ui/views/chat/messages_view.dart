import 'package:chat_app/ui/widgets/busy_button.dart';
import 'package:chat_app/ui/widgets/message_tile.dart';
import 'package:chat_app/viewmodels/messages_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class MessagesView extends StatefulWidget {
  final arguments;

  const MessagesView({Key key, this.arguments}) : super(key: key);
  @override
  _MessagesViewState createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    return ViewModelProvider.withConsumer(
      viewModel: MessagesViewModel(),
      onModelReady: (model) => model.initializeData( arguments: widget.arguments
      ),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            leading: Hero(
                tag: 'logo',
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: ExactAssetImage(
                      'assets/owl-2736707_1280.png',
                    ),
                  ),
                )),
            title: (model.userNameConversation == null)
                ? Text("Admin Chat")
                : Text(model.userNameConversation),
          ),
          body: SafeArea(
            child: model.busy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : model.messages == null
                    ? Center(
                        child: Text('There are no messages..'),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: (model.messages.length == 0)
                                ? Center(child: CircularProgressIndicator())
                                : messagesListView(model),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: TextField(
                                        onSubmitted: (value) =>
                                            model.addMessage(
                                                messageText: value,
                                                messageController:
                                                    messageController,
                                                scrollController:
                                                    scrollController),
                                        controller: messageController,
                                        decoration: InputDecoration(
                                          hintText: "Enter a Message...",
                                          border: const OutlineInputBorder(),
                                        ))),
                                BusyButton(
                                  title: "Send",
                                  busy: model.busy,
                                  onPressed: () => model.addMessage(
                                      messageText: messageController.text,
                                      messageController: messageController,
                                      scrollController: scrollController),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
          ),
        );
      },
    );
  }

  ListView messagesListView(model) {
    return ListView.builder(
      itemCount: model.messages.length,
      reverse: true,
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) {
        return MessageTile(
          text: model.messages[index].text,
          from: model.messages[index].from,
          me: model.currentUser.fullName == model.messages[index].from,
        );
      },
    );
  }

}

