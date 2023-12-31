import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AwsCognitoService {
  final userPool = CognitoUserPool('${(dotenv.env['POOL_ID'])}', '${(dotenv.env['CLIENT_ID'])}');

  Future<void> login(String email, String password) async {
    final user = CognitoUser(email, userPool);
    final authDetails = AuthenticationDetails(
      validationData: {'USERNAME': email, 'PASSWORD': password},
    );
    CognitoUserSession? session;
    try{
      session = await user.authenticateUser(authDetails);
    } on CognitoUserNewPasswordRequiredException catch (e) {
      // handle New Password challenge
    } on CognitoUserMfaRequiredException catch (e) {
      // handle SMS_MFA challenge
    } on CognitoUserSelectMfaTypeException catch (e) {
      // handle SELECT_MFA_TYPE challenge
    } on CognitoUserMfaSetupException catch (e) {
      // handle MFA_SETUP challenge
    } on CognitoUserTotpRequiredException catch (e) {
      // handle SOFTWARE_TOKEN_MFA challenge
    } on CognitoUserCustomChallengeException catch (e) {
      // handle CUSTOM_CHALLENGE challenge
    } on CognitoUserConfirmationNecessaryException catch (e) {
      // handle User Confirmation Necessary
    } on CognitoClientException catch (e) {
      // handle Wrong Username and Password and Cognito Client
    }catch (e){
      if (kDebugMode) {
        print(e);
      }
    }

  }

  Future<bool> registrationConfirmed(String email, String otp) async {
    final user = CognitoUser(email, userPool);
    bool registrationConfirmed = false;

    try {
      // Attempt to confirm the registration with the OTP
      registrationConfirmed = await user.confirmRegistration(otp);
      return registrationConfirmed; // Return the confirmation status
    } catch (e) {
      if (kDebugMode) {
        print(e); // Print the error in debug mode
      }
      return false; // Return false if an exception occurred
    }
  }


  Future<void> resendRegConfirmed(String email ) async {
    final user = CognitoUser(email, userPool);

    final String status;
    try {
      status = await user.resendConfirmationCode();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

}
