import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:to_do_list/create_task/screens/create_task.dart';
import 'package:to_do_list/db/bloc/task_bloc.dart';
import 'package:to_do_list/to_do_list/screens/listing_widget.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ListingTask extends StatefulWidget {
  const ListingTask({Key? key}) : super(key: key);

  @override
  State<ListingTask> createState() => _ListingTaskState();
}

class _ListingTaskState extends State<ListingTask> {
  String? date;
  bool gridView = false;
  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MMMM-dd');
    List splittedDate = formatter.format(now).toString().split('-');

    date = splittedDate[1] + '  ' + splittedDate[2];
    BlocProvider.of<TaskBloc>(context).add(GetAllTaskEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Card(
        color: Colors.transparent,
        elevation: 30,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ToggleSwitch(
                  // doubleTapDisable: true,

                  changeOnTap: true,
                  minWidth: 90.0,
                  initialLabelIndex: gridView ? 1 : 0,
                  cornerRadius: 20.0,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.black54,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  labels: const ['List', 'Grid'],
                  // icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
                  activeBgColors: const [
                    [Colors.green],
                    [Colors.green]
                  ],
                  onToggle: (index) {
                    if (index == 0) {
                      setState(() {
                        gridView = false;
                      });
                    } else if (index == 1) {
                      setState(() {
                        gridView = true;
                      });
                    }
                  }),
              InkWell(
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateTask(),
                      )

                      /// selectedDate //selectedIndex.month.toString()
                      );
                  BlocProvider.of<TaskBloc>(context).add(GetAllTaskEvent());
                },
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.blue[900], shape: BoxShape.circle),
                  child: const Icon(
                    Icons.add,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.teal[200],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          "Your Task's",
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              backgroundColor: Colors.transparent),
        ),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoadingState) {
            return SingleChildScrollView(
              child: Shimmer.fromColors(
                  period: const Duration(milliseconds: 1500),
                  direction: ShimmerDirection.ltr,
                  baseColor: Colors.grey,
                  highlightColor: Colors.green,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 6,
                      itemBuilder: (ctx, index) {
                        return Container(color: Colors.black);
                      })),
            );
          } else if (state is TaskfailureState) {
            return Text(
              state.errorMessage,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            );
          } else if (state is GetAllTaskSuccessState) {
            return SingleChildScrollView(
              child: Container(
                // height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.fromLTRB(15, 15, 20, 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.blue[700],

                            // color: Colors.grey[700],
                            border: Border.all(color: Colors.blue, width: 15)),
                        child: Text(
                          "Task's Pending as on $date",
                          style: const TextStyle(
                              // decoration: TextDecoration.underline,
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // ListView.(
                      //   builder: (context) {
                      //     return ListingWidget();
                      //   }
                      // )
                      gridView
                          ? GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.model.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 4.0,
                                      mainAxisExtent: 215),
                              itemBuilder: (BuildContext context, int index) {
                                return ListingWidget(
                                  gridView: gridView,
                                  model: state.model[index],
                                );
                              },
                            )
                          : ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.model.length,
                              itemBuilder: (ctx, index) {
                                return ListingWidget(
                                  model: state.model[index],
                                  gridView: gridView,
                                );
                              })
                    ]),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
