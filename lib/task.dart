class Task {
  String? _taskid;
  String _userid;
  String _title;
  String? _description;
  String _status;

  Task(
    this._userid,
    this._title, [
    this._description,
    this._status = 'incomplete',
    this._taskid,
  ]);

  String get status => _status;
  String? get taskid => _taskid;

  String get userid => _userid;
  String get title => _title;
  String get description => _description ?? '';
  set status(String value) {
    _status = value;
  }

  set userid(String userid) {
    _userid = userid;
  }

  set title(String title) {
    _title = title;
  }

  set description(String description) {
    _description = description;
  }

  static List<Task> getDummyTask() {
    return List.generate(20, (index) {
      return Task(
        'user$index',
        'title$index',
        'description$index', // _description
        'incomplete', // _status (explicitly set to default)
        'taskid$index', // _taskid
      );
    });
  }
}
