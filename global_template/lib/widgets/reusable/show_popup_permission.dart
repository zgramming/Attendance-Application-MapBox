import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';

class PopupPermission extends StatelessWidget {
  const PopupPermission({
    @required this.typePermission,
    this.buttonTitleAccept = 'Setuju',
    this.iconClose = Icons.close,
    this.iconPermission = Icons.location_city,
    this.onClose,
    this.onAccept,
    this.closeOnBackButton = false,
    this.showCloseButton = true,
  });
  final String buttonTitleAccept;
  final String typePermission;
  final IconData iconClose;
  final IconData iconPermission;
  final Function onClose;
  final Function onAccept;
  final bool closeOnBackButton;
  final bool showCloseButton;
  @override
  Widget build(BuildContext context) {
    return GSlideTransition(
      child: WillPopScope(
        onWillPop: () async => closeOnBackButton,
        child: AlertDialog(
          title: Container(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 1))),
            padding: const EdgeInsets.only(bottom: 10),
            child: Selector<GlobalProvider, String>(
              selector: (_, provider) => provider.appNamePackageInfo,
              builder: (_, value, __) => FittedBox(
                child: Text(
                  value.toUpperCase(),
                  // style: appTheme.headline6(context).copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconPermission, size: sizes.width(context) / 6),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(children: [
                  const TextSpan(text: 'Aplikasi Membutuhkan Akses '),
                  TextSpan(
                      text: '$typePermission ',
                      style: appTheme
                          .headline6(context)
                          .copyWith(fontWeight: FontWeight.bold, color: colorPallete.accentColor)),
                  const TextSpan(text: 'Untuk Dapat Berjalan Dengan Lancar')
                ], style: appTheme.caption(context)),
              ),
              const SizedBox(height: 10),
            ],
          ),
          actions: [
            ButtonCustom(
              onPressed: onAccept,
              buttonTitle: buttonTitleAccept,
            ),
          ],
        ),
      ),
    );
  }
}
