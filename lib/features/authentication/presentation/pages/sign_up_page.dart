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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(186, 228, 229, 1),
      ),
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is FailureAuthenticationState) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).errorColor,
                content: Text(
                  state.message,
                ),
              ),
            );
          }
          if (state is Entered) {
            Navigator.pushReplacementNamed(context, '/user');
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is InitialAuthenticationState ||
                state is LoadingAuthenticationState) {
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
                          style: Theme.of(context).textTheme.headline3,
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
                                keyboardType: TextInputType.emailAddress,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                ),
                                keyboardType: TextInputType.visiblePassword,
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
