import 'package:flutter/material.dart';

/// Opens a modal bottom sheet that never grows past ~3/4 of the screen, so the
/// page behind it always peeks at the top. Content taller than the cap scrolls
/// inside the sheet. Use this instead of [showModalBottomSheet] directly for a
/// consistent, non-fullscreen "drop-up".
Future<T?> showAppSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  final maxHeight = MediaQuery.of(context).size.height * 0.75;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(maxHeight: maxHeight),
    builder: builder,
  );
}
