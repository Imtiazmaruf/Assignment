class Urls{
  //  static String _baseUrl = 'https://task.teamrabbil.com/api/v1';
  // static const String registration = '$_baseUrl/registration';
  // static const String login = '$_baseUrl/login';
  // static const String createTask = '$_baseUrl/createTask';
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';

  static String registration = '$_baseUrl/registration';
  static String login = '$_baseUrl/login';
  static String createTask = '$_baseUrl/createTask';
  static String taskStatusCount = '$_baseUrl/taskStatusCount';
  static String newTaskList = '$_baseUrl/listTaskByStatus/New';
  static String deletTask(String id) => '$_baseUrl/deleteTask/$id';
  static String updateTaskStatus(String id, String status) =>
      '$_baseUrl/updateTaskStatus/$id/$status';

}