
class ComplaintModel{
  String grievanceType,imageURL,description;
  int id;


  ComplaintModel(this.id,this.description,this.grievanceType,this.imageURL);


  ComplaintModel.fromDb (Map<String,dynamic> parsedJson){
    id=parsedJson['id'];
    grievanceType=parsedJson['grievanceType'];
    imageURL=parsedJson['imageURL'];
    description=parsedJson['description'];
  }

  Map<String,dynamic> toMap(){
    return <String,dynamic>{
      "id": id,
      "description":description,
      "imageURL":imageURL,
      "grievanceType":grievanceType
    };

  }

  String get getGrievanceType{
    return grievanceType;
  }
  String get getImageURL{
    return imageURL;
  }
  String get getDescription{
    return description;
  }
  int get getId{
    return id;
  }
}


