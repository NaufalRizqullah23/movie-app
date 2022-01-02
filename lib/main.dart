import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/utils/database_helper.dart';

const yellowColor = Color(0xFFFFEB3B);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primaryColor: yellowColor,
      ),
      home: const MyHomePage(title: 'Movie App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Movie _movie = Movie();
  List<Movie> _movies = [];
  late DatabaseHelper _dbHelper ;
  final _formKey = GlobalKey<FormState>();
  final _ctrlTitle = TextEditingController();
  final _ctrlDesc = TextEditingController();
  final _ctrlStock = TextEditingController();
  
  @override
  void initState(){
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshMovieList();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Center(
          child: Text(widget.title,
          style: TextStyle(color: Colors.black),),
          ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _form(),_list()
          ],
        ),
      ),
    );
  }
  _form() =>Container(
    color:Colors.white,
    padding: EdgeInsets.symmetric(vertical:15,horizontal: 30),
    child: Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _ctrlTitle,
            decoration: InputDecoration(labelText: 'Movie Title'),
            onSaved: (val) => setState(() => _movie.title = val! ),
            validator: (val)=>(val?.length==0 ?'This field is reqired' :null),
          ),
          TextFormField(
            controller: _ctrlDesc,
            decoration: InputDecoration(labelText: 'Movie Description'),
            onSaved: (val) => setState(()=> _movie.desc = val!),
            validator: (val)=> (val?.length==0 ?'This field is required' :null),
          ),
          TextFormField(
            controller: _ctrlStock,
            decoration: InputDecoration(labelText: 'Stock'),
            onSaved: (val) => setState(()=> _movie.stock = val!),
            validator: (val)=> (val==0 ?'Need at least 1' :null),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
            onPressed:() =>_onSubmit(),
            child: Text('Submit'),
            color: yellowColor,
            textColor: Colors.black,
            ),
          )
        ],
      ),
    )
  );

  _refreshMovieList() async{
    List<Movie> x = await _dbHelper.fetchMovies();
    setState(() {
      _movies = x;
    });
  }

  _onSubmit() async{
    var form = _formKey.currentState;
    if(form!.validate()){
    form.save();
    if(_movie.id == null) await _dbHelper.insertMovie(_movie);
    else await _dbHelper.updateMovie(_movie);
    _refreshMovieList();
    _resetForm();
    }

  }

  _resetForm(){
    setState(() {
      _formKey.currentState?.reset();
      _ctrlTitle.clear();
      _ctrlDesc.clear();
      _ctrlStock.clear();
    });
  }
 
  _list() => Expanded(
    child: Card(
      margin:EdgeInsets.fromLTRB(20, 30, 20, 0),
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemBuilder: (context,index){
          return Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.account_circle,
                color: yellowColor,
                size: 40.0),
                title: Text(_movies[index].title,
                style: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(_movies[index].desc),
                trailing: IconButton(
                  icon: Icon(Icons.delete_sweep,color: yellowColor),
                  onPressed: () async{
                    await _dbHelper.deleteMovie(_movies[index].id);
                    _resetForm();
                    _refreshMovieList();
                  }),
                onTap: (){
                  setState(() {
                    _movie = _movies[index];
                    _ctrlTitle.text = _movies[index].title;
                    _ctrlDesc.text = _movies[index].desc;
                    _ctrlStock.text = _movies[index].stock;
                  });
                },
              ),
              Divider(
                height: 5.0,
              )
            ]
            );
        },
        itemCount: _movies.length,
      ),
    )
    );
}
