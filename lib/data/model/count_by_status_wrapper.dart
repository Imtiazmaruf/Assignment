import 'package:task_manager/data/model/task_count_by_status_data.dart';

class CountByStatusWrapper {
  String? status;
  List<TaskCountByStatusData>? listOfTaskByStatusData;

  CountByStatusWrapper({this.status, this.listOfTaskByStatusData});

  CountByStatusWrapper.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      listOfTaskByStatusData = <TaskCountByStatusData>[];
      json['data'].forEach((v) {
        listOfTaskByStatusData!.add( TaskCountByStatusData.fromJson(v));
      });
    }
  }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['status'] = this.status;
  //   if (this.data != null) {
  //     data['data'] = this.data!.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}


