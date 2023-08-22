
import 'dart:io' show Platform;
class AdmobService {

  static String? get videoAdUnitID {
    if(Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544~3347511713';
    }
    else  if(Platform.isIOS){
      return 'ca-app-pub-3940256099942544~3347511713';
    }
  }
}