import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linker/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:linker/features/authentication/presentation/bloc/authentication_event.dart';
import 'package:linker/features/authentication/presentation/bloc/authentication_state.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _emailController = TextEditingController(text: '');
  TextEditingController _passwordController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (BuildContext context, AuthenticationState state) {
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
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  SvgPicture.asset(
                    'assets/images/auth_bg.svg',
                    fit: BoxFit.fill,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    height: MediaQuery.of(context).size.height * 0.75,
                    color: Color.fromRGBO(186, 228, 229, 0.9),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'Sign in',
                          style: Theme.of(context).textTheme.headline3,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
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
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Haven't account yet? ",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Sign up.',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .color,
                                      fontSize: 16,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.of(context)
                                          .pushNamed('/sign-up'),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RaisedButton(
                              onPressed: () {
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(
                                  SignInEvent(
                                    _emailController.text,
                                    _passwordController.text,
                                  ),
                                );
                              },
                              child: Text(
                                'Sign in',
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else
              return Container();
          },
        ),
      ),
    );
  }
}
