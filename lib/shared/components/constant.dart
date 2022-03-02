
import '../../modules/login/login_screen.dart';
import '../network/cache_helper/cache_helper.dart';
import 'components.dart';

dynamic token = '';
void SignOut(context){
  CacheHelper.removeData(key: 'token',).then((value){
    if(value) {
      navigateAndFinish(context, ShopLoginScreen());
    }
  });

}

void printFullText(String text)
{
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}