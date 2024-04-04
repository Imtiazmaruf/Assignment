class Urls{

  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';

  static String registration = '$_baseUrl/registration';
  static String login = '$_baseUrl/login';
  static String createTask = '$_baseUrl/createTask';
  static String taskStatusCount = '$_baseUrl/taskStatusCount';
  static String newTaskList = '$_baseUrl/listTaskByStatus/New';
  static String completedTaskList = '$_baseUrl/listTaskByStatus/Completed';
  static String deletTask(String id) => '$_baseUrl/deleteTask/$id';
  static String updateProfle = '$_baseUrl/profileUpdate';
  static String recoverResetPass = '$_baseUrl/RecoverResetPass';
  static String recoverVerifyEmail(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static String recoverVerifyOTP(String email, String otp) => '$_baseUrl/RecoverVerifyOTP/$email/$otp';

  static String updateTaskStatus(String id, String status) =>
      '$_baseUrl/updateTaskStatus/$id/$status';

}