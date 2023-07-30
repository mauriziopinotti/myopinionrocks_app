import 'package:easy_localization/easy_localization.dart';

import '../generated/locale_keys.g.dart';

List<({String title, String subtitle, String image})> get welcomeItems {
  return [
    (
      title: LocaleKeys.lbl_welcome_1_title.tr(),
      subtitle: LocaleKeys.lbl_welcome_1_subtitle.tr(),
      image: 'splash-1.png'
    ),
    (
      title: LocaleKeys.lbl_welcome_2_title.tr(),
      subtitle: LocaleKeys.lbl_welcome_2_subtitle.tr(),
      image: 'splash-2.png'
    ),
    (
      title: LocaleKeys.lbl_welcome_3_title.tr(),
      subtitle: LocaleKeys.lbl_welcome_3_subtitle.tr(),
      image: 'splash-3.png'
    ),
  ];
}
