import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/widgets.dart';
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

  bool _showShimmer = false;
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
        backgroundColor: colorPrimary,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 4,
                  child: inAppLogo(),
                ),
                Expanded(
                  flex: 6,
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          margin: bottom(16),
                          child: registrationTextField(
                            screenWidth,
                            screenHeight,
                            _usernameController,
                            hintUsername,
                          ),
                        ),
                        Container(
                          margin: bottom(32),
                          child: registrationTextField(
                            screenWidth,
                            screenHeight,
                            _passwordController,
                            hintPassword,
                            shouldHideText: true,
                            last: true,
                            type: TextInputType.visiblePassword,
                            submit: (_) => _proceed(),
                          ),
                        ),
                        AbsorbPointer(
                          absorbing: _proceedDisabled,
                          child: Opacity(
                            opacity: _proceedOpacity,
                            child: GestureDetector(
                              onTap: _proceed,
                              child: proceedButton(
                                screenWidth,
                                screenHeight,
                                textRegisterLogin,
                                showShimmer: _showShimmer,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
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

  _success() {
    _load(false);
    PrefUtils.setLoggedIn(true);
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
      _showShimmer = enabled;
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
