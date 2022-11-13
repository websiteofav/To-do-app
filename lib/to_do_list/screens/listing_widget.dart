import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:to_do_list/db/bloc/task_bloc.dart';
import 'package:to_do_list/db/model/task_model.dart';
import 'package:to_do_list/to_do_list/screens/timer.dart';

class ListingWidget extends StatelessWidget {
  bool gridView;
  TaskModel model;
  ListingWidget({Key? key, this.gridView = false, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final duration, durationArray;

    durationArray = model.duration.split(':');
    if (durationArray[0] == '0') {
      duration = '${durationArray[1]} seconds';
    } else {
      duration = '${durationArray[0]} minutes and ${durationArray[1]} seconds';
    }

    return InkWell(
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskTimer(
                model: model,
              ),
            )

            /// selectedDate //selectedIndex.month.toString()
            );
        BlocProvider.of<TaskBloc>(context).add(GetAllTaskEvent());
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.purple[100],
          border: Border.all(
            color: Colors.black54,
            width: 10,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              model.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              duration,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              model.status,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            // gridView
            // ?
            Shimmer.fromColors(
              baseColor: Colors.brown,
              highlightColor: Colors.yellow,
              child: const Text(
                'Click to start Task',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // :
            // Center(
            //     child: SliderButton(
            //     baseColor: Colors.red,
            //     // buttonColor: Colors.orange,

            //     alignLabel: Alignment.center,
            //     width: MediaQuery.of(context).size.width - 40,
            //     height: 60,
            //     backgroundColor: Colors.orange,

            //     action: () async {
            //       await Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => TaskTimer(model: model),
            //           )

            //           /// selectedDate //selectedIndex.month.toString()
            //           );
            //       BlocProvider.of<TaskBloc>(context).add(GetAllTaskEvent());
            //     },
            //     label: const Text(
            //       "Slide to start Task",
            //       style: TextStyle(
            //         fontWeight: FontWeight.w500,
            //         fontSize: 20,
            //       ),
            //       textAlign: TextAlign.center,
            //     ),
            //   )),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
