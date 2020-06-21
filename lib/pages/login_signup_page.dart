import 'package:flutter/material.dart';
import '../services/authentication.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import '../services/facebook.dart' as fb;

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.auth, this.onSignedIn});

  final BaseAuth auth;
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _LoginSignUpPageState();
}

enum FormMode { LOGIN, SIGNUP }

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  // Initial form is login form
  FormMode _formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(_email, _password);
          widget.auth.sendEmailVerification();
          _showVerifyEmailSentDialog();
          print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 &&
            userId != null &&
            _formMode == FormMode.LOGIN) {
          widget.onSignedIn();
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('SOFAIO Solution'),
        ),
        body: Stack(
          children: <Widget>[
            _showBody(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Verify your account"),
          content:
              new Text("Link to verify account has been sent to your email"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Dismiss"),
              onPressed: () {
                _changeFormToLogin();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //show all body
  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _showEmailInput(),
              _showPasswordInput(),
              _showForgetPassword(),
              _showPrimaryButton(),
              _showSpc(),
              _showFacebookLogin(),
              _showSecondaryButton(),
              _showErrorMessage(),
            ],
          ),
        ));
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showLogo() {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 40.0, 0.0, 0.0),
            child: Text('SOFAIO',
                style: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(16.0, 105.0, 0.0, 0.0),
            child: Text('Solution',
                style: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(310.0, 105.0, 0.0, 0.0),
            child: Text('.',
                style: TextStyle(
                    fontSize: 80.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
          )
        ],
      ),
    );

    /*return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 40.0,
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );*/
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            //hintText: 'Email',
            labelText: 'EMAIL',
            labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green)),
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            //hintText: 'Password',
            labelText: 'PASSWORD',
            labelStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Colors.grey),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green)),
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
    );
  }

  Widget _showForgetPassword() {
    return Container(
      alignment: Alignment(1.0, 0.0),
      padding: EdgeInsets.only(top: 15.0, left: 20.0),
      child: InkWell(
        child: Text(
          'Forgot Password',
          style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
              decoration: TextDecoration.underline),
        ),
      ),
    );
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: _formMode == FormMode.LOGIN
          ? new Text('New to SOFAIO ? Create an account',
              style: new TextStyle(
                  color: Colors.green,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline))
          : new Text('Have an account? Sign in',
              style: new TextStyle(
                  color: Colors.green,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline)),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: _formMode == FormMode.LOGIN
                ? new Text('Login',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white))
                : new Text('Create account',
                    style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }

  Widget _showFacebookLogin() {
    return Container(
      height: 40.0,
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black, style: BorderStyle.solid, width: 1.0),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: ImageIcon(AssetImage('assets/facebook.png')),
            ),
            SizedBox(width: 10.0),
            Center(
                child: isLoggedIn
                    ? Text("Logged In")
                    : Text("Login with Facebook",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat')),
                        /*onPressed: () => onLoginWithFacebook(),*/
            )
          ],
        ),
      ),
    );
  }

  Widget _showSpc() {
    return SizedBox(height: 20.0);
  }

  /*void initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        onLoginStatusChanged(true);
        break;
    }
  }*/

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  Future<Null> onLoginWithFacebook() async {
    String facebookAppId = "your-id";
    String facebookAppSecret = "secret-id";

    fb.Token token;
    fb.FacebookGraph graph;
    fb.PublicProfile profile;

    final fb.Token _token = await fb.getToken(facebookAppId, facebookAppSecret);
    fb.FacebookGraph _graph = new fb.FacebookGraph(_token);
    fb.PublicProfile _profile = await _graph.me(["name", "email"]);

    ///print(_profile);

    ///
    /// If a Facebook ProfileId is returned, the authentication went OK
    ///
    if (_profile.id != null){
      ///
      /// Proceed with further activities linked to the _profile.id
      ///
    }
  }

}

