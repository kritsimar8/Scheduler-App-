import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_/core/constants/utils.dart';
import 'package:frontend_/features/auth/cubit/auth_cubit.dart';
import 'package:frontend_/features/home/cubit/tasks_cubit.dart';
import 'package:frontend_/features/home/pages/add_new_task_page.dart';
import 'package:frontend_/features/home/widgets/dateSelector.dart';
import 'package:frontend_/features/home/widgets/task_card.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const HomePage());

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  @override 
  void initState() {
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    context.read<TasksCubit>().getAllTasks(token: user.user.token);
    Connectivity().onConnectivityChanged.listen((data) async {
      if (data.contains(ConnectivityResult.wifi)){
          await context.read<TasksCubit>().syncTasks(user.user.token);
        
      }
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context,AddNewTaskPage.route());
          }, icon: const Icon(
            CupertinoIcons.add,
          ))
        ],
      ),
      body: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if(state is TasksLoading){
            return const Center(child: CircularProgressIndicator(),);
          }
          if (state is TasksError){
            return Center(child: Text(state.error),);
          }
          if(state is GetTasksSuccess){
            final tasks = state.tasks.where((elem)=> DateFormat('d').format(elem.dueAt) ==
                          DateFormat('d').format(selectedDate) &&
                      selectedDate.month == elem.dueAt.month &&
                      selectedDate.year == elem.dueAt.year).toList();
             return Column(
              children: [
                Dateselector(
                  selectedDate:selectedDate,
                  onTap: (date){
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:tasks.length,
                    itemBuilder: (context,index){
                     final task = tasks[index];
                  
                      return  Row(
                      children: [
                        Expanded(
                          child:  TaskCard(
                          color: task.color ,
                          headerText: task.title,
                          descriptionText: task.description),
                        ),
                        Container(
                          height: 10,
                          width: 10,
                          decoration:  BoxDecoration(
                            color:  strenghtenolor(task.color, 0.69),
                            shape: BoxShape.circle
                          ),
                        ),
                       Padding(
                         padding:  EdgeInsets.all(12.0),
                         child:  Text(
                            DateFormat.jm().format(task.dueAt),
                            style: const TextStyle(
                              fontSize: 17
                            ),
                          ),
                       )
                      ],
                    );
                    },
                  ),
                )
              ],
            );
          }
          return const SizedBox();
         
        },
      )
    );
  }
}
