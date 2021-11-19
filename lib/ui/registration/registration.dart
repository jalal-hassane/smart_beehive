import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/composite/widgets.dart';
import 'package:smart_beehive/data/local/models/beekeeper.dart';
import 'package:smart_beehive/ui/global/loading.dart';
import 'package:smart_beehive/ui/registration/registration_viewmodel.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:smart_beehive/utils/pref_utils.dart';

import '../../main.dart';
import '../home.dart';

const _tag = 'Registration';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _Registration createState() => _Registration();
}

class _Registration extends State<Registration> {
  late RegistrationViewModel _registrationViewModel;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _proceedDisabled = true;
  double _proceedOpacity = 0.5;

  bool _showLoader = false;

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_canProceed);
    _passwordController.addListener(_canProceed);
  }

  @override
  Widget build(BuildContext context) {
    _initViewModel();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 3,
                  child: inAppLogo(),
                ),
                Expanded(
                  flex: 10,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: bottom(16),
                          child: sheetTextField(
                            screenWidth,
                            screenHeight,
                            _usernameController,
                            hintUsername,
                            align: TextAlign.center,
                          ),
                        ),
                        sheetTextField(
                          screenWidth,
                          screenHeight,
                          _passwordController,
                          hintPassword,
                          shouldHideText: true,
                          last: true,
                          align: TextAlign.center,
                          type: TextInputType.visiblePassword,
                          submit: (_) => _proceed(),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: AbsorbPointer(
                    absorbing: _proceedDisabled,
                    child: Opacity(
                      opacity: _proceedOpacity,
                      child: ElevatedButton(
                        onPressed: () => _proceed(),
                        style: buttonStyle,
                        child: SizedBox(
                          width: screenWidth * 0.4,
                          height: screenHeight * 0.056,
                          child: Center(
                            child: Text(
                              textRegisterLogin,
                              style: mTS(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: _showLoader,
              child: const Loading(),
            ),
          ],
        ),
      ),
    );
  }

  _initViewModel() {
    _registrationViewModel = Provider.of<RegistrationViewModel>(context);
    _registrationViewModel.helper = RegistrationHelper(
      success: _success,
      failure: _failure,
    );
  }

  _success(Beekeeper beekeeper) {
    _load(false);
    PrefUtils.setLoggedIn(true);
    me = beekeeper;
    _openHome();
  }

  _failure(String error) {
    _load(false);
    showSnackBar(context, error);
  }

  _load(bool isLoading) {
    setState(() {
      _showLoader = isLoading;
    });
  }

  _canProceed() {
    final username = _usernameController.text;
    final password = _passwordController.text;
    try {
      assert(!username.isNullOrEmpty);
      assert(!password.isNullOrEmpty);
      handleProceedState(true);
    } catch (e) {
      handleProceedState(false);
    }
  }

  _proceed() {
    _load(true);
    unFocus(context);
    final username = _usernameController.text.toString();
    final password = _passwordController.text.toString();
    _registrationViewModel.checkUsernameAvailability(username, password);
  }

  handleProceedState(bool enabled) {
    setState(() {
      _proceedDisabled = !enabled;
      _proceedOpacity = enabled ? 1.0 : 0.5;
    });
  }

  _openHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        settings: const RouteSettings(name: 'Home'),
        builder: (context) => const Home(),
      ),
    );
  }
}
