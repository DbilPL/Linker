import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linker/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:linker/features/authentication/presentation/bloc/authentication_state.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) {
        if (state is Entered) {
          // to user page
        }
      },
      child: Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
        body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is InitialAuthenticationState) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              );
            }
            if (state is FailureAuthenticationState) {
              return Container(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.8,
                    color: Theme.of(context).primaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'Sign up',
                          style: TextStyle(
                            color: Theme.of(context).backgroundColor,
                            fontSize: 35,
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              'Name',
                              style: TextStyle(
                                color: Theme.of(context).backgroundColor,
                              ),
                            ),
                            TextFormField(),
                            Text(
                              'Email',
                              style: TextStyle(
                                color: Theme.of(context).backgroundColor,
                              ),
                            ),
                            TextFormField(),
                            Text(
                              'Password',
                              style: TextStyle(
                                color: Theme.of(context).backgroundColor,
                              ),
                            ),
                            TextFormField(),
                          ],
                        ),
                        RaisedButton(
                          onPressed: () {},
                          child: Text('Sign in'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else
              return Container();
          },
        ),
      ),
    );
  }
}
