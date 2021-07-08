import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fyp_app_design/constants.dart';
import 'package:fyp_app_design/controller/user_auth.dart';
import 'package:fyp_app_design/controller/user_controller.dart';
import 'package:fyp_app_design/view/activity-screens/all_activity_views.dart';
import 'package:fyp_app_design/view/activity-screens/guess_the_word_activity.dart';
import 'package:fyp_app_design/view/activity_view.dart';
import 'package:fyp_app_design/view/advisor_edit_profile.dart';
import 'package:fyp_app_design/view/advisor_home.dart';
import 'package:fyp_app_design/view/advisor_settings.dart';
import 'package:fyp_app_design/view/advisor_update_module.dart';
import 'package:fyp_app_design/view/advisor_update_level.dart';
import 'package:fyp_app_design/view/advisor_create_module.dart';
import 'package:fyp_app_design/view/all_views.dart';
import 'package:fyp_app_design/view/edit_profile.dart';
import 'package:fyp_app_design/view/nf-screens/badge_unlocked.dart';
import 'package:fyp_app_design/view/nf-screens/before_adaptive_quiz.dart';
import 'package:fyp_app_design/view/components/create_adaptive_question.dart';
import 'package:fyp_app_design/view/student-home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(CyberEdApp());
}

class CyberEdApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final FirebaseAuth firebaseAuth;

  CyberEdApp({Key key, this.firebaseAuth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print('Initialized Successfully');
          return MultiProvider(
            providers: [
              Provider<UserAuth>(
                create: (_) => UserAuth(FirebaseAuth.instance),
              ),
              StreamProvider(
                create: (context) => context.read<UserAuth>().authStateChanges,
                initialData: CircularProgressIndicator(),
              ),
            ],
            child: MaterialApp(
              routes: {
                '/first-screen': (context) => FirstScreen(),
                '/student-reg': (context) => StudentRegisterView(),
                '/student-login': (context) => StudentLoginView(),
                '/advisor-view': (context) => AdvisorLoginView(),
                '/student-home': (context) => StudentHomeView(),
                '/edit-profile': (context) => EditProfile(),
                '/home-view': (context) => HomeScreenView(),
                '/complete-profile': (context) => CompleteProfilePageView(),
                '/adaptive-quiz': (context) => AdaptiveQuizView(),
                '/intro-before-adaptive-quiz': (context) =>
                    IntroBeforeAdaptiveQuizScreen(),
                '/activity-view': (context) => ActivityView(),
                '/video-activity': (context) => VideoActivity(),
                '/game-activity': (context) => GameActivity(),
                '/pdf-viewer': (context) => PDFViewerPage(),
                '/badge-unlocked': (context) => BadgeUnlockedView(),
                '/advisor-home': (context) => AdvisorHomeView(),
                '/advisor-profile': (context) => AdvisorProfileView(),
                '/advisor-settings': (context) => AdvisorSettingsView(),
                '/advisor-update-module': (context) =>
                    AdvisorUpdateModuleView(),
                '/advisor-update-level': (context) => AdvisorUpdateLevelView(),
                '/advisor-create-module': (context) => AdvisorCreateModule(),
                '/create-adaptive-questions': (context) =>
                    CreateAdaptiveQuestion(),
                '/guess-game-activity': (context) => HangmanGameView(),
              },
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: Colors.black,
                textTheme:
                    Theme.of(context).textTheme.apply(bodyColor: kTextColor),
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              title: 'Cyber Ed',
              home: AuthenticationWrapper(),
            ),
          );
        }
        if (snapshot.hasError) {
          print('Initialization Error');
          CoolAlert.show(
            context: context,
            type: CoolAlertType.error,
            text: 'An Error Has Occured',
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}

// ignore: must_be_immutable
class AuthenticationWrapper extends StatelessWidget {
  UserController _userController = UserController();
  SharedPreferences _sharedPreferences;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen((User user) async {
      if (user == null) {
        _sharedPreferences = await SharedPreferences.getInstance();
        if (_sharedPreferences.containsKey('advisorLoggedIn') == true) {
          if (_sharedPreferences.getBool('advisorLoggedIn') == true) {
            Navigator.pushNamed(context, '/advisor-home');
          } else {
            Navigator.pushNamed(context, '/first-screen');
          }
        } else {
          Navigator.pushNamed(context, '/first-screen');
        }
      } else {
        try {
          _userController.getStudentRegistrationCompletion().then((value) {
            if (value) {
              _userController
                  .getStudentAdaptiveScorePresence(
                      FirebaseAuth.instance.currentUser)
                  .then((value) {
                if (value) {
                  Navigator.pushNamed(context, '/student-home');
                } else {
                  Navigator.pushNamed(context, '/intro-before-adaptive-quiz');
                }
              });
            } else {
              Navigator.pushNamed(context, '/complete-profile');
            }
          });
        } catch (e) {
          Navigator.pushNamed(context, '/home-view');
        }
      }
    });
    return Center(
        child: Container(
      child: CircularProgressIndicator(),
    ));
  }
}
