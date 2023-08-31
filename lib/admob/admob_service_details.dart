
import 'dart:io' show Platform;
class AdmobService {

  static String? get videoAdUnitID {
    if(Platform.isAndroid) {
      return 'ca-app-pub-3286914600053930/9378197617';
    }
    else  if(Platform.isIOS){
      return 'ca-app-pub-3286914600053930/3623308053';
    }
  }
}