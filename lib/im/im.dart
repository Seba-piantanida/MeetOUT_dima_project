import 'package:dima_project/im/GenerateUserSig.dart';
import 'package:dima_project/im/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services_implements.dart';
import 'package:tencent_cloud_chat_uikit/tencent_cloud_chat_uikit.dart';

class im {
  final CoreServicesImpl _coreInstance = TIMUIKitCore.getInstance();

  void initIMSDK() {
    _coreInstance.init(sdkAppID: 1721000593, language: LanguageEnum.en, loglevel: LogLevelEnum.V2TIM_LOG_DEBUG, onTUIKitCallbackListener: (TIMCallback callbackValue){
      print(callbackValue);
      switch(callbackValue.type) {
        case TIMCallbackType.INFO:
        // Shows the recommend text for info callback directly
          ToastUtils.toast(callbackValue.infoRecommendText ?? "");
          break;
        case TIMCallbackType.API_ERROR:
        //Prints the API error to console, and shows the error message.
          print("Error from TUIKit: ${callbackValue.errorMsg}, Code: ${callbackValue.errorCode}");
          // if (callbackValue.errorCode == 10004 && callbackValue.errorMsg!.contains("not support @all")) {
          //   ToastUtils.toast("当前群组不支持@全体成员");
          // }else{
          //   ToastUtils.toast(callbackValue.errorMsg ?? callbackValue.errorCode.toString());
          // }
          break;
        case TIMCallbackType.FLUTTER_ERROR:
        default:
        // prints the stack trace to console or shows the catch error
          if(callbackValue.catchError != null){
            ToastUtils.toast(callbackValue.catchError.toString());
          }else{
            print(1);
            print(callbackValue.stackTrace);
          }
      }
    }, listener: V2TimSDKListener());
    var userID = FirebaseAuth.instance.currentUser?.uid ?? "";
    var userSig = GenerateTestUserSig(key: "7feb3cb883685ac7d572c91e3f1c1532ca477608046bc42963db3c9051c69aa6", sdkappid: 1721000593).genSig(identifier: userID, expire: 3600 * 24 * 1000);
    TIMUIKitCore.getInstance().login(userID: userID, userSig: userSig);
  }
}