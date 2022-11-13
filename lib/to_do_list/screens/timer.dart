import 'dart:async';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/db/bloc/task_bloc.dart';
import 'package:to_do_list/db/model/task_model.dart';
import 'package:to_do_list/to_do_list/screens/widgets/button_widget.dart';

class TaskTimer extends StatefulWidget {
  TaskModel model;
  TaskTimer({Key? key, required this.model}) : super(key: key);

  @override
  State<TaskTimer> createState() => _TaskTimerState();
}

class _TaskTimerState extends State<TaskTimer> {
  Duration _duration = const Duration();
  Duration countdownDuration = const Duration();

  Timer? _timer;
  final int _subtractSeconds = 1;
  List arrayTime = [];

  @override
  void initState() {
    arrayTime = widget.model.duration.split(':');

    countdownDuration = Duration(
      minutes: int.parse(
        arrayTime[0],
      ),
      seconds: int.parse(
        arrayTime[1],
      ),
    );
    reset();

    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.dispose();
  }

  void subtractTime() {
    setState(() {
      final seconds = _duration.inSeconds - _subtractSeconds;
      if (seconds < 0) {
        _timer!.cancel();
      }
      // else if (seconds == 0) {
      //   CoolAlert.show(
      //     context: context,
      //     type: CoolAlertType.success,
      //     text: "Your Task is complete",
      //   );
      // }
      else {
        if (seconds == 0) {
          TaskModel tempModel = TaskModel(
              duration: widget.model.duration,
              title: widget.model.title,
              status: 'DONE',
              description: widget.model.description,
              id: widget.model.id);
          BlocProvider.of<TaskBloc>(context)
              .add(UpdateTaskEvent(model: tempModel));
        }
        _duration = Duration(seconds: seconds);
      }
    });
  }

  void reset() {
    setState(() {
      _duration = countdownDuration;
    });
  }

  void startTimer({bool resetTimer = false}) {
    if (resetTimer) {
      reset();
    }

    _timer = Timer.periodic(
        Duration(seconds: _subtractSeconds), (timer) => subtractTime());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_timer == null) {
          Navigator.of(context).pop();
          return true;
        } else if (!_timer!.isActive) {
          Navigator.of(context).pop();
          return true;
        } else {
          CoolAlert.show(
            // onConfirmBtnTap: ,

            context: context,
            type: CoolAlertType.info,
            text: "Please reset or pause your timer",
          );
          return false;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.teal[200],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: Text(
            widget.model.title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                backgroundColor: Colors.transparent),
          ),
        ),
        body: BlocListener<TaskBloc, TaskState>(
          listener: (context, state) {
            if (state is UpdateTaskSuccessState) {
              if (state.status) {
                CoolAlert.show(
                  // onConfirmBtnTap: ,
                  onConfirmBtnTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  context: context,
                  type: CoolAlertType.success,
                  text: "Your Task is complete",
                );
              }
            } else if (state is TaskPopUpfailureState) {
              CoolAlert.show(
                // onConfirmBtnTap: ,

                context: context,
                type: CoolAlertType.error,
                text: state.errorMessage,
              );
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Current Status',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 5,
              ),
              if (widget.model.description!.isNotEmpty)
                Text(widget.model.status,
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 5,
              ),
              if (widget.model.status == 'DONE')
                const Text(
                  '(Task is currently done. By starting timer you will re-do the task)',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(
                height: 15,
              ),
              const Text('Description',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 5,
              ),
              if (widget.model.description!.isNotEmpty)
                Text(widget.model.description.toString(),
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 15,
              ),
              timerWidget(),
              const SizedBox(
                height: 15,
              ),
              pauseWidget()
            ],
          ),
        ),
      ),
    );
  }

  String twoDigits(int n) => n.toString().padLeft(2, '0');

  Widget timerWidget() {
    final minutes = twoDigits(_duration.inMinutes.remainder(60));
    final seconds = twoDigits(_duration.inSeconds.remainder(60));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        durationWidget(minutes, 'MINUTES'),
        const SizedBox(
          width: 15,
        ),
        durationWidget(seconds, 'SECONDS'),
      ],
    );
    // return Text(
    //   '$minutes: $seconds',
    //   style: const TextStyle(
    //       color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
    // );
  }

  Widget durationWidget(time, title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            decoration: BoxDecoration(
                color: Colors.white60, borderRadius: BorderRadius.circular(20)),
            alignment: Alignment.center,
            // height: 50,
            height: (MediaQuery.of(context).size.width * 0.4) - 30,
            padding: const EdgeInsets.all(15),
            // width: (MediaQuery.of(context).size.width * 0.4) - 30,
            child: Text(
              time,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
            )),
        const SizedBox(height: 15),
        Text(
          title,
          style: const TextStyle(
              color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void resetTimer() {
    setState(() {
      _duration = countdownDuration;
    });

    _timer!.cancel();
  }

  void pauseTimer() {
    setState(() {
      _timer!.cancel();
    });
  }

  void stopTimer() {
    setState(() {
      _duration = countdownDuration;
    });
    _timer!.cancel();
  }

  Widget pauseWidget() {
    bool isRunning = _timer == null ? false : _timer!.isActive;
    bool isCompleted = _duration.inSeconds == 0;
    bool reset = _duration.inSeconds == countdownDuration.inSeconds;

    return isRunning || (!isCompleted && !reset)
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  width: 100,
                  title: isRunning ? 'Pause' : 'Resume',
                  omTap: () {
                    if (isRunning) {
                      final minutes =
                          twoDigits(_duration.inMinutes.remainder(60));
                      final seconds =
                          twoDigits(_duration.inSeconds.remainder(60));
                      widget.model = TaskModel(
                          id: widget.model.id,
                          duration: '$minutes:$seconds',
                          title: widget.model.title,
                          status: 'IN-PROGRESS',
                          description: widget.model.description);

                      BlocProvider.of<TaskBloc>(context)
                          .add(UpdateTaskEvent(model: widget.model));

                      pauseTimer();
                    } else {
                      startTimer();
                    }
                  }),
              ButtonWidget(
                  width: 100,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                  title: 'Reset',
                  omTap: () {
                    final minutes =
                        twoDigits(_duration.inMinutes.remainder(60));
                    final seconds =
                        twoDigits(_duration.inSeconds.remainder(60));
                    widget.model = TaskModel(
                        id: widget.model.id,
                        duration: '$minutes:$seconds',
                        title: widget.model.title,
                        status: 'TODO',
                        description: widget.model.description);

                    BlocProvider.of<TaskBloc>(context)
                        .add(UpdateTaskEvent(model: widget.model));
                    setState(() {
                      resetTimer();
                    });
                  }),
            ],
          )
        : ButtonWidget(
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
            width: 200,
            title: 'Start',
            omTap: () {
              if (widget.model.status == 'DONE') {
                widget.model = TaskModel(
                    duration: widget.model.duration,
                    title: widget.model.title,
                    status: 'TODO',
                    description: widget.model.description,
                    id: widget.model.id);
                BlocProvider.of<TaskBloc>(context)
                    .add(UpdateTaskEvent(model: widget.model));
              }
              // paused = false;
              startTimer(resetTimer: true);
            });
  }
}
