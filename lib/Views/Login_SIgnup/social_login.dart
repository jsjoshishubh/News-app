import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newsapp/Commons/common_loader.dart';
import 'package:newsapp/Styles/app_colors.dart';
import 'package:newsapp/Utils/utils.dart';

class SocialMediaLoginScreen extends StatefulWidget {
  const SocialMediaLoginScreen({super.key});

  @override
  State<SocialMediaLoginScreen> createState() => _SocialMediaLoginScreenState();
}

class _SocialMediaLoginScreenState extends State<SocialMediaLoginScreen> {
  bool isGoogleLogin = false;
  bool isGithubLogin = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GitHubSignIn gitHubSignIn = GitHubSignIn(
    clientId: '0870812afd4e1b0bec54',
    redirectUrl: 'https://news-app-885d5.firebaseapp.com/__/auth/handler',
    title: 'GitHub Connection',
    clientSecret: '3601520249b3eed56c21dffb9247652c5a37569f',
  );

  User? _user;

  @override
  void initState() {
    super.initState();
    onIntState();
  }

  onIntState() {
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  onHandleSignIn() async {
    try {
      setState(() {
        isGoogleLogin = true;
      });
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      setState(() {
        isGoogleLogin = false;
      });
      return await _auth.signInWithCredential(credential);
    } catch (error) {
      toastWidget('Something went wrong,Please retry google login after some time',true);
      setState(() {
        isGoogleLogin = false;
      });
      log('error -=---- ${error}');
      return null;
    }
  }

  onHandleGitHubLogin(BuildContext context) async {
    try {
      setState(() {
        isGithubLogin = true;
      });
      final GitHubSignInResult result = await gitHubSignIn.signIn(context);
      if (result.status == GitHubSignInResultStatus.ok) {
        final String? gitHubToken = result.token;
        AuthCredential credential = GithubAuthProvider.credential(gitHubToken!);
        setState(() {
          isGithubLogin = false;
        });
        toastWidget('Github login successfull');
        return await _auth.signInWithCredential(credential);
      } else {
        setState(() {
          isGithubLogin = false;
        });
        return null;
      }
    } catch (error) {
      log('error ---- ${error}');
      setState(() {
        isGithubLogin = false;
      });
      toastWidget('Something went wrong,Please retry google login after some time',true);
      return null;
    }
  }

  onUserCreditionalValidated(type) async {
    if (type == 'GOOGLE') {
      UserCredential? userCredential = await onHandleSignIn();
      if (userCredential != null) {
        Map<String, dynamic> loginInfo = {
          '_id': userCredential.user!.uid,
          'name': userCredential.user!.displayName,
          'email': userCredential.user!.displayName,
          'image': userCredential.user!.photoURL,
        };
        onLocalSetup(data: loginInfo,startup: true, callback: () {
              setState(() {
                isGoogleLogin = false;
              });
            });
        toastWidget('Google login has been successfull');
      }
    } else {
      UserCredential? userCredential = await onHandleGitHubLogin(context);
      if (userCredential != null) {
        Map<String, dynamic> loginInfo = {
          '_id': userCredential.user!.uid,
          'name': userCredential.user!.displayName,
          'email': userCredential.user!.displayName,
          'image': userCredential.user!.photoURL,
        };
        onLocalSetup(data: loginInfo, startup: true, callback: () {
              setState(() {
                isGithubLogin = false;
              });
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    Image.asset('Assets/Images/login.png',scale: 0.9,),
                    const SizedBox(height: 20,),
                    Text('Welcome To News App',style: getTextStyle(size: 25,fontWeight: FontWeight.w600,color: primaryColor),             maxLines: 2,textAlign: TextAlign.center,),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                      child: Text('Experience the pulse of the world with our intuitive news app. Tailored for seamless updates, dive into curated content that keeps you informed and engaged.',
                        textAlign: TextAlign.center,
                        style: getTextStyle(color: Colors.grey, size: 14),
                        maxLines: 4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40,),
              Container(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => onUserCreditionalValidated('GOOGLE'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10),
                        child: Card(
                          elevation: 2,
                          shadowColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          child: isGoogleLogin ? Padding(padding: EdgeInsets.all(10),child: commonLoader(),) :  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('Assets/Images/google.webp',scale: 15,),
                                const SizedBox( width: 10,),
                                Text('Continue With Google',style: getTextStyle(color: primaryColor,size: 14),)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),


                    InkWell(
                      onTap: () => onUserCreditionalValidated('GITHUB'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric( horizontal: 50.0, vertical: 10),
                        child: Card(
                          elevation: 2,
                          shadowColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          child: isGithubLogin ? Padding(padding: EdgeInsets.all(10),child: commonLoader(),) : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('Assets/Images/github.png',scale: 19,),
                                const SizedBox(width: 14,),
                                Text('Continue With Github',style: getTextStyle(color: primaryColor,size: 14))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
