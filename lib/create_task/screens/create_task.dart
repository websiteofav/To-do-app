import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:to_do_list/db/bloc/task_bloc.dart';
import 'package:to_do_list/to_do_list/screens/widgets/button_widget.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({Key? key}) : super(key: key);

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  TextEditingController titleContnroller = TextEditingController();
  TextEditingController descriptionContnroller = TextEditingController();
  TextEditingController durationContnroller = TextEditingController();
  String? minutes, seconds;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ButtonWidget(
        width: MediaQuery.of(context).size.width,
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.w500, color: Colors.white),
        title: 'Add new Task',
        omTap: () {
          if (_formKey.currentState!.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.

            BlocProvider.of<TaskBloc>(context).add(
              AddTaskEvent(
                title: titleContnroller.text,
                duration: '$minutes:$seconds',
                status: 'TODO',
                description: descriptionContnroller.text,
              ),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          "Add Task",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              backgroundColor: Colors.transparent),
        ),
      ),
      backgroundColor: Colors.teal[200],
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is GetTaskSuccessState) {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              text: "Your Task is Added",
            );
          } else if (state is TaskPopUpfailureState) {
            CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text: state.errorMessage,
            );
          }
          // TODO: implement listener
        },
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Title(*)',
                          style: TextStyle(
                              color: Colors.purple[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              backgroundColor: Colors.transparent),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          // keyboardType: TextInputType.,
                          textInputAction: TextInputAction.next,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp("[0-9a-zA-Z]")),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Title is required';
                            } else {
                              return null;
                            }
                          },

                          controller: titleContnroller,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              backgroundColor: Colors.transparent),
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Colors.blue), //<-- SEE HERE
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Colors.purple), //<-- SEE HERE
                            ),
                            hintText: 'Enter Title of the task',
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Description',
                          style: TextStyle(
                              color: Colors.purple[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              backgroundColor: Colors.transparent),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          // keyboardType: TextInputType.,
                          textInputAction: TextInputAction.next,
                          controller: descriptionContnroller,

                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              backgroundColor: Colors.transparent),
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Colors.blue), //<-- SEE HERE
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Colors.purple), //<-- SEE HERE
                            ),
                            hintText: 'Enter Description of the task',
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Duration(Min-1 minute; Max - 10 minutes *)',
                          style: TextStyle(
                              color: Colors.purple[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              backgroundColor: Colors.transparent),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          // enabled: false,
                          readOnly: true,
                          onTap: onTap,
                          validator: (value) {
                            if (value!.isEmpty ||
                                (minutes == '0' && seconds == '0')) {
                              return 'Duration is required';
                            } else {
                              return null;
                            }
                          },
                          textInputAction: TextInputAction.next,
                          // keyboardType: TextInputType.,
                          // keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],

                          controller: durationContnroller,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              backgroundColor: Colors.transparent),
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Colors.blue), //<-- SEE HERE
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Colors.blue), //<-- SEE HERE
                            ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //       width: 3, color: Colors.purple), //<-- SEE HERE
                            // ),
                            hintText: 'Enter Duration of the task. ',
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  void onTap() {
    Picker(
      adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
        const NumberPickerColumn(begin: 0, end: 10, suffix: Text(' minutes')),
        const NumberPickerColumn(
          begin: 0,
          end: 60,
          suffix: Text(' seconds'),
        ),
      ]),
      delimiter: <PickerDelimiter>[
        PickerDelimiter(
          child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ),
        )
      ],
      hideHeader: true,
      confirmText: 'OK',
      confirmTextStyle:
          const TextStyle(inherit: false, color: Colors.red, fontSize: 22),
      title: const Text('Select duration'),
      selectedTextStyle: const TextStyle(color: Colors.blue),
      onConfirm: (Picker picker, List<int> value) {
        if (picker.getSelectedValues()[0] == 10) {
          picker.getSelectedValues()[1] = 0;
        }
        // You get your duration here

        minutes = picker.getSelectedValues()[0].toString();
        seconds = picker.getSelectedValues()[1].toString();

        durationContnroller.text =
            '${picker.getSelectedValues()[0].toString()} minutes and ${picker.getSelectedValues()[1].toString()} seconds';
      },
    ).showDialog(context);
  }
}
