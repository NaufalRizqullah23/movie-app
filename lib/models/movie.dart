class Movie{
  static const tblMovie = 'movies';
  static const colId = 'id';
  static const colTitle = 'title';
  static const colDesc = 'desc';
  static const colStock = 'stock';

  Movie({
    this.id = 0,
    this.title ='',
    this.desc = '',
    this.stock = ''
    });

  Movie.fromMap(Map<String,dynamic> map){
    id=map[colId];
    title=map[colTitle];
    desc=map[colDesc];
    stock=map[colStock];
  }

  int id = 0;
  String title ='';
  String desc = '';
  String stock = '';
  
  Map<String,dynamic> toMap(){
    var map = <String,dynamic>{colTitle:title,colDesc:desc,colStock:stock};
    if(id != null){
      map[colId] = id;
      }
    return map;
  }
}