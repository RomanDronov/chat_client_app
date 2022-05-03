import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/chat_user.dart';
import '../scoped_models/app_model.dart';
import 'chat_page.dart';

class AllChatsPage extends StatefulWidget {
  @override
  _AllChatsPageState createState() => _AllChatsPageState();
}

class _AllChatsPageState extends State<AllChatsPage> {
  @override
  void initState() {
    super.initState();
    ScopedModel.of<AppModel>(context, rebuildOnChange: false).init();
  }

  void friendClicked(ChatUser friend) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ChatPage(friend: friend);
        },
      ),
    );
  }

  Widget buildAllChatList() {
    return ScopedModelDescendant<AppModel>(
      builder: (BuildContext context, Widget? child, AppModel model) {
        return model.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: model.friendList.length,
                itemBuilder: (BuildContext context, int index) {
                  ChatUser friend = model.friendList[index];
                  return ListTile(
                    title: Text(friend.name),
                    onTap: () => friendClicked(friend),
                  );
                },
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Chats'),
        automaticallyImplyLeading: false,
      ),
      body: buildAllChatList(),
    );
  }
}
