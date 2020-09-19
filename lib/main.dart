import 'package:flutter/material.dart';
import 'package:flutter_login_aheichanka/second_screen.dart';
import 'package:flutter_login_aheichanka/validators.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white60, width: 2.0),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white60, width: 2.0),
            ),
            hintStyle: TextStyle(color: Colors.white60)),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final _loginFormKey = GlobalKey<FormState>();
  final LayerLink _layerLink = LayerLink();

  static const buttonSignInNormal = Text(
    'Sign In',
    style: TextStyle(color: Colors.white),
  );

  static const buttonSignInInProgress = CircularProgressIndicator(
    strokeWidth: 2,
    backgroundColor: Colors.transparent,
    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  );

  Widget _buttonSignInChild = buttonSignInNormal;

  final _buttonSignInKey = GlobalKey();

  AnimationController _controller;
  Animation _curvedController;

  AnimationController _buttonExpandController;

  double logInBtnOpacity = 1;

  static const kSignInButtonHeight = 56.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
    _controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    _curvedController =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo);
    _buttonExpandController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    _buttonExpandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/pine.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.blue[900].withOpacity(0.4), BlendMode.srcATop)),
        ),
        child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyTextFormField(
                iconData: Icons.perm_identity,
                hintText: 'Username',
                validator: (value) {
                  return MyFormValidator.validateIfEmpty(value, 'Username');
                },
              ),
              SizedBox(
                height: 30,
              ),
              MyTextFormField(
                iconData: Icons.lock_outline,
                obscureText: true,
                hintText: 'Password',
                validator: (value) {
                  return MyFormValidator.validateIfEmpty(value, 'Username');
                },
              ),
              SizedBox(
                height: 50,
              ),
              GestureDetector(
                onTap: _createAnimatingButton,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    key: _buttonSignInKey,
                    height: 56,
                    child: CompositedTransformTarget(
                      link: _layerLink,
                      child: Opacity(
                        opacity: logInBtnOpacity,
                        child: _createSignInButton(true),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(color: Colors.white60),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _createAnimatingButton() {
    setState(() {
      _buttonSignInChild = buttonSignInInProgress;
      logInBtnOpacity = 0;
      Future.delayed(Duration(seconds: 6), () {
        setState(() {
          _buttonSignInChild = buttonSignInNormal;
          //_overlayEntry.remove();
        });
      });
    });

    final buttonWidth = _getSignInButtonWidth();
    final widthAnimation =
        Tween(begin: _getSignInButtonWidth(), end: kSignInButtonHeight)
            .animate(_curvedController);
    final positionAnimation = Tween(begin: 0.0, end: (buttonWidth / 2) * 0.83)
        .animate(_curvedController);

    OverlayEntry _overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        top: 0.0,
        left: 0.0,
        child: AnimatedBuilder(
          animation: _curvedController,
          builder: (context, child) {
            return SizedBox(
              width: widthAnimation.value.toDouble(),
              height: kSignInButtonHeight,
              child: CompositedTransformFollower(
                link: _layerLink,
                offset: Offset(positionAnimation.value, 0.0),
                child: _createSignInButton(false),
              ),
            );
          },
          child: CompositedTransformFollower(
            link: _layerLink,
            //offset: Offset(0, -50),
            child: _createSignInButton(false),
          ),
        ),
      );
    });

    Overlay.of(context).insert(_overlayEntry);

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _overlayEntry.remove();

        _animateFromSmallCircleToLarge();
      }
    });
  }

  void _animateFromSmallCircleToLarge() {
    final height = MediaQuery.of(context).size.height;
    final buttonWidth = _getSignInButtonWidth();

    final curvedAnimation = CurvedAnimation(
        parent: _buttonExpandController, curve: Curves.easeOutExpo);
    final expandAnimation = Tween(begin: kSignInButtonHeight, end: height * 1.8)
        .animate(curvedAnimation);

    final expandingOverlay = OverlayEntry(builder: (context) {
      return Positioned(
        top: 0,
        left: 0,
        child: AnimatedBuilder(
          animation: _buttonExpandController,
          builder: (context, child) {
            final animationValue = expandAnimation.value;
            final hOffset = (buttonWidth / 2) - (animationValue / 2);
            final vOffset = -((kSignInButtonHeight / 2) +
                (animationValue / 2) -
                kSignInButtonHeight);
            return CompositedTransformFollower(
              offset: Offset(hOffset, vOffset),
              link: _layerLink,
              child: Container(
                width: animationValue,
                height: animationValue,
                decoration:
                    BoxDecoration(color: Colors.pink, shape: BoxShape.circle),
              ),
            );
          },
        ),
      );
    });

    Overlay.of(context).insert(expandingOverlay);

    _buttonExpandController.forward();
    _buttonExpandController.addStatusListener((status) {
      print('Status = $status');
      if (status == AnimationStatus.completed) {
        print('navigating');
        Navigator.of(context).push(SecondScreen.route());

        Future.delayed(Duration(milliseconds: 100), () {
          expandingOverlay?.remove();
          logInBtnOpacity = 1;

          _buttonExpandController.reset();
          _controller.reset();
          _buttonSignInChild = buttonSignInNormal;
        });
      }
    });
  }

  Widget _createSignInButton(bool mainBtn) {
    return Container(
      alignment: Alignment.center,
      child: Center(child: _buttonSignInChild),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(32.0),
        color: Colors.pink,
      ),
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(32.0)),
    );
  }

  double _getSignInButtonWidth() {
    final RenderBox renderBox =
        _buttonSignInKey.currentContext.findRenderObject();
    return renderBox.size.width;
  }
}

class MyTextFormField extends StatelessWidget {
  const MyTextFormField(
      {Key key,
      this.iconData,
      this.obscureText = false,
      this.hintText,
      this.validator})
      : super(key: key);

  final IconData iconData;
  final bool obscureText;
  final String hintText;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        cursorColor: Colors.white60,
        cursorWidth: 2,
        obscureText: obscureText,
        style: TextStyle(color: Colors.white),
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Icon(
              iconData,
              color: Colors.white60,
            ),
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
