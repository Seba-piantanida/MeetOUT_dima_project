import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';
import 'package:tencent_cloud_chat_uikit/ui/utils/screen_utils.dart';
import 'package:tencent_cloud_chat_uikit/ui/views/TIMUIKitNewContact/tim_uikit_new_contact.dart';

class NewContact extends StatelessWidget {
  const NewContact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget newContactWidget() {
      return TIMUIKitNewContact(
        emptyBuilder: (c) {
          return Center(
            child: Text(TIM_t("暂无新联系人")),
          );
        },
      );
    }

    return TUIKitScreenUtils.getDeviceWidget(
        context: context,
        desktopWidget: newContactWidget(),
        defaultWidget: Scaffold(
          appBar: AppBar(
              title: Text(
                TIM_t("新的联系人"),
                style: const TextStyle(color: Colors.white, fontSize: 17),
              ),
              shadowColor: Colors.white,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    CommonColor.lightPrimaryColor,
                    CommonColor.primaryColor
                  ]),
                ),
              ),
              iconTheme: const IconThemeData(
                color: Colors.white,
              )),
          body: TIMUIKitNewContact(
            emptyBuilder: (c) {
              return Center(
                child: Text(TIM_t("暂无新联系人")),
              );
            },
          ),
        ));
  }
}