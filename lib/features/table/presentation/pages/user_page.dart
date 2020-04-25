import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linker/core/presentation/bloc/bloc.dart';
import 'package:linker/features/table/presentation/bloc/bloc.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<DynamicLinkBloc, DynamicLinkState>(
      listener: (BuildContext context, DynamicLinkState state){

      },
      child: Scaffold(
        appBar:AppBar(backgroundColor: Theme.of(context).cardColor,actions: <Widget>[],) ,

        body: BlocBuilder<DynamicLinkBloc, DynamicLinkState>(
          builder: (context, state){
            if(state is InitialDynamicLinkState){
              return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromRGBO(186, 228, 229, 1),
                ),
              ),
            );}
            if (state is LoadLinkHandlerSuccess){
              return Center(
                child: Container(width: 200,
                height: 200,
                color: Colors.red,),
              );
            }
           return Center(child: Container(width: 200.0,
           height: 200.0,
           color: Colors.pink,),);
          },
        ),
      ),
    );
  }
}
