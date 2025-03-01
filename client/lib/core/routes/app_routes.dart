import 'package:get/get.dart';
import 'package:xchange/core/routes/routes.dart';
import 'package:xchange/presentation/home/home_page.dart';
import 'package:xchange/presentation/signin/sign_in.dart';
import 'package:xchange/presentation/signup/sign_up.dart';
import 'package:xchange/presentation/splash/splash_screen.dart';

import '../../presentation/barter/barter_list.dart';
import '../../presentation/chat/chat_list.dart';
import '../../presentation/wallet/wallet_screen.dart';

class AppRoutes{
  static List<GetPage> routes(){
    return [
      GetPage(name: Routes.splashScreen, page: ()=>const SplashScreen()),
      GetPage(name: Routes.signUpScreen, page: ()=>const SignUp()),
      GetPage(name: Routes.signInScreen, page: ()=>const SignIn()),
      GetPage(name: Routes.homePage, page: ()=> HomePage()),
      GetPage(name: Routes.barterListScreen, page: ()=> BarterListScreen()),
      GetPage(name: Routes.walletScreen, page: ()=>const WalletScreen()),
      GetPage(name: Routes.chatListScreen, page: ()=> ChatListScreen()),
    ];
  }
}