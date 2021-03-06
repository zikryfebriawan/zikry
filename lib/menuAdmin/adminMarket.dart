import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydroponic/dataBase/admin/brand.dart';
import 'package:hydroponic/dataBase/admin/category.dart';
import 'package:hydroponic/menuAdmin/addProduct.dart';
import 'package:hydroponic/menuMarket/horizontalListView.dart';


enum Page{dashboard, manage}
class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  Page _selectedPage = Page.dashboard;
  MaterialColor active =Colors.green;
  MaterialColor notActive=Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _brandFormKey = GlobalKey();
  BrandService _brandService = BrandService();
  CategoryService _categoriesService = CategoryService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Expanded(
              child: FlatButton.icon(onPressed: (){
                setState(() => _selectedPage = Page.dashboard);
              }, icon: Icon(
                Icons.dashboard,
                color: _selectedPage==Page.dashboard ? active : notActive,
              ),label: Text("Dashboard"),),
            ),
            Expanded(
              child: FlatButton.icon(onPressed: (){
                setState(() {
                  _selectedPage = Page.manage;
                });
              }, icon: Icon(
                Icons.sort,
                color: _selectedPage==Page.manage ? active : notActive,
              ), label: Text("Manage")),
            )
          ],
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: _loadScreen(),
    );
  }

  Widget _loadScreen(){
    switch(_selectedPage){
      case Page.dashboard:
      return Column(
        children: <Widget>[
          ListTile(subtitle: FlatButton.icon(onPressed: null, icon: Icon(Icons.attach_money, size: 30.0,color: Colors.amber,),
              label: Text("12,000", textAlign: TextAlign.center, style: TextStyle(fontSize: 30.0, color:Colors.amber),),
          ),
          title: Text("Revenue", textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0,color: Colors.grey),),
          ),
          Expanded(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2
              ),children: <Widget>[
                Padding(padding: const EdgeInsets.all(18.0),
                child: Card(
                  child: ListTile(
                    title: FlatButton.icon(onPressed: null, icon: Icon(Icons.people_outline), label: Text("Users")),
                    subtitle: Text("7", textAlign: TextAlign.center,style: TextStyle(color: active, fontSize: 60.0),),
                  ),
                ),
                ),
              Padding(padding: const EdgeInsets.all(18.0),
                child: Card(
                  child: ListTile(
                    title: FlatButton.icon(onPressed: null, icon: Icon(Icons.people_outline), label: Text("Categories")),
                    subtitle: Text("23", textAlign: TextAlign.center,style: TextStyle(color: active, fontSize: 60.0),),
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.all(22.0),
                child: Card(
                  child: ListTile(
                    title: FlatButton.icon(onPressed: null, icon: Icon(Icons.people_outline), label: Text("Product")),
                    subtitle: Text("120", textAlign: TextAlign.center,style: TextStyle(color: active, fontSize: 60.0),),
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.all(22.0),
                child: Card(
                  child: ListTile(
                    title: FlatButton.icon(onPressed: null, icon: Icon(Icons.people_outline), label: Text("Sold")),
                    subtitle: Text("13", textAlign: TextAlign.center,style: TextStyle(color: active, fontSize: 60.0),),
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.all(22.0),
                child: Card(
                  child: ListTile(
                    title: FlatButton.icon(onPressed: null, icon: Icon(Icons.people_outline), label: Text("Oders")),
                    subtitle: Text("7", textAlign: TextAlign.center,style: TextStyle(color: active, fontSize: 60.0),),
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.all(18.0),
                child: Card(
                  child: ListTile(
                    title: FlatButton.icon(onPressed: null, icon: Icon(Icons.people_outline), label: Text("Return")),
                    subtitle: Text("0", textAlign: TextAlign.center,style: TextStyle(color: active, fontSize: 60.0),),
                  ),
                ),
              ),

            ],
            ),
          )
        ],
      );
      break;
      case Page.manage:
        return ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add product"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>AddProduct()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Product list"),
              onTap: (){},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text("Add category"),
              onTap: (){
                _categoryAlret();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.category),
              title: Text("Category list"),
              onTap: (){},
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text("Add brand"),
              onTap: (){
                _brandAlret();
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text("Brand list"),
              onTap: (){},
            ),
            Divider(),


          ],
        );
        break;
      default:
        return Container();
    }
  }

  void _categoryAlret() {
    var alret = new AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          controller: categoryController,
          validator: (value){
            if(value.isEmpty){
              return "category cannot be empty";
            }
          },
          decoration: InputDecoration(
            hintText: "add category"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton.icon(onPressed: (){
          if(categoryController.text != null){
            _categoriesService.createCategory(categoryController.text);
          }
          Fluttertoast.showToast(msg: "category created");
          Navigator.pop(context);
        }, icon: Icon(Icons.add), label: Text("add")),
        FlatButton.icon(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.close), label: Text("close")),


      ],
    );
    showDialog(context: context, builder: (_)=> alret);
  }
  void _brandAlret() {
    var alret = new AlertDialog(
      content: Form(
        key: _brandFormKey,
        child: TextFormField(
          controller: brandController,
          validator: (value){
            if(value.isEmpty){
              return "brand cannot be empty";
            }
          },
          decoration: InputDecoration(
              hintText: "add brand"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton.icon(onPressed: (){
          if(brandController.text != null){
            _brandService.createBrand(brandController.text);
          }
          Fluttertoast.showToast(msg: "brand added");
          Navigator.pop(context);
        }, icon: Icon(Icons.add), label: Text("add")),
        FlatButton.icon(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.close), label: Text("close")),


      ],
    );
    showDialog(context: context, builder: (_)=> alret);
  }

}


