import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linker/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:linker/features/authentication/presentation/bloc/authentication_event.dart';
import 'package:linker/features/authentication/presentation/bloc/authentication_state.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');
  TextEditingController _nameController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) {
        if (state is FailureAuthenticationState) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
              ),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
        }
        if (state is Entered) {
          // to user page
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(186, 228, 229, 1),
        ),
        body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is InitialAuthenticationState) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(186, 228, 229, 1),
                  ),
                ),
              );
            }
            if (state is FailureAuthenticationState) {
              return Container(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.height * 0.75,
                    color: Color.fromRGBO(186, 228, 229, 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'Sign up',
                          style: Theme.of(context).textTheme.title,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                ),
                                controller: _nameController,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'E-mail',
                                ),
                                controller: _emailController,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                ),
                                controller: _passwordController,
                              ),
                            ],
                          ),
                        ),
                        RaisedButton(
                          onPressed: () {
                            BlocProvider.of<AuthenticationBloc>(context).add(
                              RegisterEvent(
                                _nameController.text,
                                _emailController.text,
                                _passwordController.text,
                              ),
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: Theme.of(context).textTheme.button,
                          ),
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
