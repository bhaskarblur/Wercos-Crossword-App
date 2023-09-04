
import 'dart:io' show Platform;
class AdmobService {

  static String? get videoAdUnitID {
    if(Platform.isAndroid) {
      return 'ca-app-pub-3736420404472867/2311691422';
    }
    else  if(Platform.isIOS){
      return 'ca-app-pub-3736420404472867/4908076350';
    }
  }
}