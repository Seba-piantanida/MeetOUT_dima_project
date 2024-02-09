import 'package:dima_project/im/add_group.dart';
import 'package:dima_project/im/new_contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/controller/tim_uikit_conversation_controller.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/platform.dart';
import 'package:tencent_super_tooltip/tencent_super_tooltip.dart';

import 'add_friend.dart';
import 'chat.dart';
import 'jh_pop_menus.dart';

class Conversation extends StatefulWidget {
  final TIMUIKitConversationController conversationController;
  final ValueChanged<V2TimConversation?>? onConversationChanged;
  final VoidCallback? onClickSearch;
  final ValueChanged<Offset?>? onClickPlus;

  /// Used for specify the current conversation, usually used for showing the conversation indicator background color on wide screen.
  final V2TimConversation? selectedConversation;

  const Conversation(
      {Key? key,
      required this.conversationController,
      this.onConversationChanged,
      this.onClickSearch,
      this.onClickPlus,
      this.selectedConversation})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  late TIMUIKitConversationController _controller;
  List<String> jumpedConversations = [];
  V2TimConversation? selectedConversation;

  @override
  void initState() {
    super.initState();
    _controller = widget.conversationController;
  }

  @override
  void didUpdateWidget(Conversation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedConversation != oldWidget.selectedConversation) {
      Future.delayed(const Duration(milliseconds: 1), () {
        _controller.selectedConversation = widget.selectedConversation;
      });
    }
  }

  scrollToNextUnreadConversation() {
    final conversationList = _controller.conversationList;
    for (var element in conversationList) {
      if ((element?.unreadCount ?? 0) > 0 && !jumpedConversations.contains(element!.conversationID)) {
        _controller.scrollToConversation(element.conversationID);
        jumpedConversations.add(element.conversationID);
        return;
      }
    }
    jumpedConversations.clear();
    try {
      _controller.scrollToConversation(conversationList[0]!.conversationID);
    } catch (e) {}
  }

  void _handleOnConvItemTaped(V2TimConversation? selectedConv) async {
    if (widget.onConversationChanged != null) {
      widget.onConversationChanged!(selectedConv);
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chat(
              selectedConversation: selectedConv!,
            ),
          ));
    }
  }

  _clearHistory(V2TimConversation conversationItem) {
    _controller.clearHistoryMessage(conversation: conversationItem);
  }

  _pinConversation(V2TimConversation conversation) {
    _controller.pinConversation(conversationID: conversation.conversationID, isPinned: !conversation.isPinned!);
  }

  _deleteConversation(V2TimConversation conversation) {
    _controller.deleteConversation(conversationID: conversation.conversationID);
  }

  List<ConversationItemSlidePanel> _itemSlidableBuilder(V2TimConversation conversationItem) {
    return [
      if (!PlatformUtils().isWeb)
        ConversationItemSlidePanel(
          onPressed: (context) {
            _clearHistory(conversationItem);
          },
          backgroundColor: hexToColor("006EFF"),
          foregroundColor: Colors.white,
          label: TIM_t("清除聊天"),
          autoClose: true,
        ),
      ConversationItemSlidePanel(
        onPressed: (context) {
          _pinConversation(conversationItem);
        },
        backgroundColor: hexToColor("FF9C19"),
        foregroundColor: Colors.white,
        label: conversationItem.isPinned! ? TIM_t("取消置顶") : TIM_t("置顶"),
      ),
      ConversationItemSlidePanel(
        onPressed: (context) {
          _deleteConversation(conversationItem);
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        label: TIM_t("删除"),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    // final LocalSetting localSetting = Provider.of<LocalSetting>(context);
    // judgeGuide('conversation', context);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Chat",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                Expanded(
                  child: TIMUIKitConversation(
                    onTapItem: _handleOnConvItemTaped,
                    isShowOnlineStatus: true,
                    lastMessageBuilder: (lastMsg, groupAtInfoList) {
                      return null;
                    },
                    controller: _controller,
                    emptyBuilder: () {
                      return Container(
                        padding: const EdgeInsets.only(top: 100),
                        child: Center(
                          child: Text(TIM_t("暂无会话")),
                        ),
                      );
                    },
                  ),
                )
              ],
            )));
  }
}
