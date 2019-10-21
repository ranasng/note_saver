class note{
  int _id;
  String _title;
  String _description;
  int _priority;
  String _date;
  note(this._title,this._date,this._priority,[this._description]);
  note.withId(this._id,this._title,this._date,this._priority,[this._description]);

  int get id => _id;
  String get title => _title;
  String get description => _description;
  int get priority => _priority;
  String get date => _date;
  set title(String newTitle){
    if(newTitle.length<=255){
      this._title=newTitle;
    }
  }
  set decription(String newDesc){
    if(newDesc.length<=255){
      this._description=newDesc;
    }
  }
  set priority(int newPriority){
    if(newPriority >= 1 && newPriority <=2){
      this._priority=newPriority;
    }
  }
  set date(String newDate){
    this._date=newDate;
  }
  //Convert a Note into a Map object
   Map<String,dynamic> toMap(){
    var map= Map<String, dynamic>();
    if(id!=null) {
      map['id'] = _id;
    }
    map['title']=_title;
    map['description']=_description;
    map['priority']=_priority;
    map['date']=_date;
    return map;
   }

   note.fromMapObject(Map<String,dynamic> map){
    this._id=map['id'];
    this._title=map['title'];
    this._description=map['description'];
    this._priority=map['priority'];
    this._date=map['date'];
   }
}