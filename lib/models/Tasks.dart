
class Tasks {

  int _id;
  String _title;
  String _date;
  String _completed;

  Tasks(this._title, this._date, this._completed);
  Tasks.withId(this._id, this._title, this._date, this._completed);

  int get id => _id;
  String get title => _title;
  String get date => _date;
  String get completed => _completed;

  set title(String value){
    if(value.length > 2){
      _title = value;
    }
  }

  set date(String value){
    if(value.length > 2){
      _date = value;
    }
  }

  set completed(String value){
    if(value.length > 2){
      _completed = value;
    }
  }

  Map<String,dynamic> toMap(){
    var map = new Map<String,dynamic>();
    map["title"] = _title;
    map["date"] = _date;
    map["completed"] = _completed;
    if (_id != null) {
      map["id"] = _id;
    }
    return map;
  }

  Tasks.fromObject(dynamic o){
    this._id = o["Id"];
    this._title = o["Title"];
    this._date = o["Date"];
    this.completed = o["Completed"];
  }

}