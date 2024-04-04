import 'package:flutter/material.dart';
import 'package:task_manager/data/model/task_item.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utility/urls.dart';
import 'package:task_manager/presentation/widget/snacbar_message.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskItem,
    required this.refreshList,
  });

  final TaskItem taskItem;
  final VoidCallback refreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _updateTaskStatusInProgress = false;
  bool _deletTaskListInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskItem.title ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(widget.taskItem.description ?? ''),
            Text('Date ${widget.taskItem.createdDate}'),
            Row(
              children: [
                Chip(label: Text(widget.taskItem.status ?? '')),
                const Spacer(),
                Visibility(
                  visible: _updateTaskStatusInProgress == false,
                  replacement: const CircularProgressIndicator(),
                  child: IconButton(
                      onPressed: () {
                        _showUpdateStatusDialog(widget.taskItem.sId!);
                      },
                      icon:  Icon(Icons.edit)),
                ),
                Visibility(
                  visible: _deletTaskListInProgress == false,
                  replacement: const CircularProgressIndicator(),
                  child: IconButton(
                      onPressed: () {
                        _deletTaskById(widget.taskItem.sId!);
                      },
                      icon: Icon(Icons.delete)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showUpdateStatusDialog(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Select status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('New'),
                  trailing: _isCurrentStatus('new') ? Icon(Icons.check) : null,
                  onTap: (){
                    if(_isCurrentStatus('new')){
                      return;
                    }
                    _updateTaskByTd(id, 'New');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Completed'),
                  trailing: _isCurrentStatus('Completed') ? Icon(Icons.check) : null,
                  onTap: (){
                    if(_isCurrentStatus('Completed')){
                      return;
                    }
                    _updateTaskByTd(id, 'Completed');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Progress'),
                  trailing: _isCurrentStatus('Progress') ? Icon(Icons.check) : null,
                  onTap: (){
                    if(_isCurrentStatus('Progress')){
                      return;
                    }
                    _updateTaskByTd(id, 'Progress');
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Cancelled'),
                  trailing: _isCurrentStatus('Cancelled') ? Icon(Icons.check) : null,
                  onTap: (){
                    if(_isCurrentStatus('Cancelled')){
                      return;
                    }
                    _updateTaskByTd(id, 'Cancelled');
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  bool _isCurrentStatus(String status){
    return widget.taskItem.status! == status;
  }

  Future<void> _updateTaskByTd(String id, String status) async {
    _updateTaskStatusInProgress = true;
    setState(() {});
    final response =
        await NetworkCaller.getRequest(Urls.updateTaskStatus(id, status));
    _updateTaskStatusInProgress = false;
    if (response.isSuccess) {
      _updateTaskStatusInProgress = false;
      widget.refreshList();
    } else {
      setState(() {});
      if (mounted) {
        showSnacbarMessage(context,
            response.errorMessage ?? 'Update task status has been failed');
      }
    }
  }

  Future<void> _deletTaskById(String id) async {
    _deletTaskListInProgress = true;
    setState(() {});
    final response = await NetworkCaller.getRequest(Urls.deletTask(id));
    _deletTaskListInProgress = false;
    if (response.isSuccess) {
      widget.refreshList();
    } else {
      _deletTaskListInProgress = false;
      setState(() {});
      if (mounted) {
        showSnacbarMessage(context,
            response.errorMessage ?? 'Delet task list has been failed');
      }
    }
  }
}
