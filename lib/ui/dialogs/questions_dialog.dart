import 'package:conciergego/bloc/events/user_request_event.dart';
import 'package:conciergego/bloc/user_request_bloc.dart';
import 'package:conciergego/ui/widgets/elevated_icon_button.dart';
import 'package:conciergego/ui/widgets/textfield_decorated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<String?> showQuestionsListDialog(
  BuildContext context,
  List<String> questions,
) async {
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
          child: _QuestionsListDialogContent(questions: questions),
        ),
      );
    },
  );
}

class _QuestionsListDialogContent extends StatefulWidget {
  final List<String> questions;

  const _QuestionsListDialogContent({required this.questions});

  @override
  _QuestionsListDialogContentState createState() =>
      _QuestionsListDialogContentState();
}

class _QuestionsListDialogContentState
    extends State<_QuestionsListDialogContent> {
  final List<TextEditingController> _questionControllers = [];

  @override
  void initState() {
    super.initState();

    for (String _ in widget.questions) {
      _questionControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    debugPrint("QuestionsListDialog.dispose()");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 300,
          maxWidth: MediaQuery.of(context).size.width - 40,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Container(
          padding: const EdgeInsets.all(15),
          width: MediaQuery.of(context).size.width * 0.6,
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
              Text(
                "Please clarify the following questions",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 15),
              Flexible(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      children:
                          widget.questions
                              .asMap()
                              .entries
                              .map<Widget>(
                                (entry) => Column(
                                  children: [
                                    TextFieldDecorated(
                                      hintText: entry.value,
                                      labelText: entry.value,
                                      maxLines: 2,
                                      controller:
                                          _questionControllers[entry.key],
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedIconButton(
                    onPressed: () {
                      BlocProvider.of<UserRequestBloc>(
                        context,
                      ).add(UserRequestCancelledEvent());

                      Navigator.pop(context);
                    },
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor.withValues(red: 150, alpha: 0.3),
                    child: Text(
                      "Cancel request",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(width: 25),
                  ElevatedIconButton(
                    onPressed: () {},
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor.withValues(green: 150, alpha: 0.4),
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
