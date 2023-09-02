import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/api_services.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/payment_config.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:mobile_app_word_search/widget/navigator.dart';
import 'package:mobile_app_word_search/widget/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pay/pay.dart';
import '../providers/profile_provider.dart';
import '../widget/sahared_prefs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io' show Platform;

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

subscribe(String status){
  _SubscriptionPageState().subscribe(status);
}

var applePay = ApplePayButton(
  paymentConfiguration: PaymentConfiguration.fromJsonString(
      defaultApplePay),
  paymentItems: const [
    PaymentItem(
      label: '1 Month subcription',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    ) ],
  type: ApplePayButtonType.subscribe,
  style: ApplePayButtonStyle.white,
  height: 55,
  width:
  WidgetsBinding.instance.window.physicalSize.width - 10,
  onPaymentResult: (Map<String, dynamic> result) {
    print(result);
  },
  loadingIndicator: const Center(
    child: CircularProgressIndicator(),
  ),
);

var googlePay = GooglePayButton(
  paymentConfiguration: PaymentConfiguration.fromJsonString(
      defaultGooglePay),
  paymentItems: const [
    PaymentItem(
      label: '1 Month subcription',
      amount: '99.99',
      status: PaymentItemStatus.final_price,
    ) ],
  type: GooglePayButtonType.subscribe,
  margin: const EdgeInsets.only(top: 15.0),
  height: 55,
  width:
  WidgetsBinding.instance.window.physicalSize.width - 10,
  onPaymentResult: (Map<String, dynamic> result) {
    print(result);
    if(result.containsValue('success')) {
      subscribe('1month');
    }
    else {
      dialog(_SubscriptionPageState().context, 'Puchase Failed. Please try again', () {
        Nav.pop(_SubscriptionPageState().context);
      });
    }
  },
  loadingIndicator: const Center(
    child: CircularProgressIndicator(),
  ),
);

var applePay2 = ApplePayButton(
  paymentConfiguration: PaymentConfiguration.fromJsonString(
      defaultApplePay),
  paymentItems: const [
    PaymentItem(
      label: '1 Year subscription',
      amount: '1079.88',
      status: PaymentItemStatus.final_price,
    ) ],
  type: ApplePayButtonType.subscribe,
  style: ApplePayButtonStyle.white,
  height: 55,
  width:
  WidgetsBinding.instance.window.physicalSize.width - 10,
  onPaymentResult: (Map<String, dynamic> result) {
    print(result);
  },
  loadingIndicator: const Center(
    child: CircularProgressIndicator(),
  ),
);

var googlePay2 = GooglePayButton(
  paymentConfiguration: PaymentConfiguration.fromJsonString(
      defaultGooglePay),
  paymentItems: const [
    PaymentItem(
      label: '1 Year subscription',
      amount: '1079.88',
      status: PaymentItemStatus.final_price,
    ) ],
  type: GooglePayButtonType.subscribe,
  margin: const EdgeInsets.only(top: 15.0),
  height: 55,
  width:
  WidgetsBinding.instance.window.physicalSize.width - 10,
  onPaymentResult: (Map<String, dynamic> result) {
    print(result);
    if(result.containsValue('success')) {
      subscribe('1year');
    }
    else {
      dialog(_SubscriptionPageState().context, 'Puchase Failed. Please try again', () {
        Nav.pop(_SubscriptionPageState().context);
      });
    }
  },
  loadingIndicator: const Center(
    child: CircularProgressIndicator(),
  ),
);

class _SubscriptionPageState extends State<SubscriptionPage> {
  final ApiServices _apiServices = ApiServices();

  List<String>? benefits;


  Dialog buyDialog1 = Dialog(
    backgroundColor: AllColors.purple,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
    child: Container(
      height: 230.0,
      width: 340.0,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0)
          , child: Label(
        text: 'Subcribe for montly \$99/ month',
        fontWeight: FontWeight.bold,
        fontSize: 19)),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
          child:  Label(
            text: 'Pay via the given payment methods to continue.',
            fontWeight: FontWeight.normal,
            fontSize: 15,
            color: Colors.white60))
         ,
          Padding(padding: EdgeInsets.only(top: 15.0)),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center( child: Platform.isIOS ? applePay : googlePay))
        ],
      ),
    ),
  );

  Dialog buyDialog2 = Dialog(
    backgroundColor: AllColors.purple,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: 230.0,
        width: 340.0,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0)
                , child: Label(
                    text: 'Subcribe for annually \$89/ month',
                    fontWeight: FontWeight.bold,
                    fontSize: 19)),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Padding(padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                child:  Label(
                    text: 'Pay via the given payment methods to continue.',
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: Colors.white60))
            ,
            Padding(padding: EdgeInsets.only(top: 15.0)),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center( child: Platform.isIOS ? applePay2 : googlePay2))
          ],
        ),
      )
  );

  @override
  Widget build(BuildContext context) {
    benefits = [
      AppLocalizations.of(context)!.add_free,
      AppLocalizations.of(context)!.unlimited_match,
      AppLocalizations.of(context)!.many_more_topics,
      AppLocalizations.of(context)!.share_your,
      AppLocalizations.of(context)!.levels_available,
      AppLocalizations.of(context)!.create_dynamic,
      AppLocalizations.of(context)!.create_challenges,
      AppLocalizations.of(context)!.create_privet
    ];
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: CustomAppBar(isBack: true, isLang: true)),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                     Center(
                        child: Label(
                            text: AppLocalizations.of(context)!.premium_benifits,
                            fontWeight: FontWeight.bold,
                            fontSize: FontSize.p2)),
                    const SizedBox(height: 30),
                    Column(
                        children: benefits!
                            .map((e) => BenefitsItem(benefit: e))
                            .toList()),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
              gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ShadowButton(
                    fillColors: const [
                      AllColors.semiLiteGreen,
                      AllColors.shineGreen
                    ],
                    onPressed: () {

      showDialog(context: context, builder: (BuildContext context) => buyDialog1);
                      subscribe('1month');
                    },
                    title: AppLocalizations.of(context)!.monthly),
              ),
              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ShadowButton(
                    fillColors: const [
                      AllColors.semiLiteGreen,
                      AllColors.shineGreen
                    ],
                    onPressed: () {
                      showDialog(context: context, builder: (BuildContext context) => buyDialog2);
                      subscribe('1year');
                    },
                    title: AppLocalizations.of(context)!.annual),
              ),
            ],
          ),
        ));
  }

  subscribe(String subStatus) {


    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        _apiServices.post(
            context: context,
            endpoint: 'updateUserSubscriptionStatus',
            body: {
              "accessToken": token,
              "userId": loginId,
              "subStatus": subStatus,
            }).then((value) {
          dialog(context, value['message'], () {
            Nav.pop(context);
          });
          Prefs.setPrefs('subStatus', subStatus);
          _apiServices
              .post(
                  context: context,
                  endpoint: 'getUserInfo',
                  body: {"accessToken": token, "userId": loginId},
                  progressBar: false)
              .then((value) {
            final provider =
                Provider.of<ProfileProvider>(context, listen: false);
            provider.chnageProfile(value);
          });
        });
      });
    });
  }
}

class BenefitsItem extends StatelessWidget {
  const BenefitsItem({
    super.key,
    required this.benefit,
  });

  final String benefit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check, color: AllColors.superLightGreen, size: 36),
        const SizedBox(width: 20),
        Expanded(
            child: Label(
                text: benefit,
                fontSize: FontSize.p2,
                fontWeight: FontWeight.bold))
      ],
    );
  }
}
