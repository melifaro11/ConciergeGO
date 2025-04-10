import 'package:conciergego/ui/widgets/elevated_icon_button.dart';
import 'package:conciergego/ui/widgets/textfield_decorated.dart';
import 'package:flutter/material.dart';

Future<String?> showUserRequestDialog(BuildContext context) async {
  return await showGeneralDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    transitionDuration: const Duration(milliseconds: 700),
    pageBuilder: (context, animation1, animation2) {
      return Container();
    },
    transitionBuilder: (context, animation1, animation2, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation1, curve: Curves.easeOutBack),
        child: FadeTransition(
          opacity: animation1,
          child: _FloatingDialogContent(),
        ),
      );
    },
  );
}

class _FloatingDialogContent extends StatefulWidget {
  @override
  __FloatingDialogContentState createState() => __FloatingDialogContentState();
}

class __FloatingDialogContentState extends State<_FloatingDialogContent> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),
            TextFieldDecorated(
              controller: _textController,
              hintText: "Describe your request...",
              maxLines: 8,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedIconButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                const SizedBox(width: 10),
                ElevatedIconButton(
                  onPressed: () => Navigator.pop(context, _textController.text),
                  width: 200,
                  backgroundColor: Theme.of(context).primaryColor.withGreen(40),
                  child: const Text("Create request"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
