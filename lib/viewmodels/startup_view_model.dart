import 'package:chat_app/constants/route_names.dart';
import 'package:chat_app/locator.dart';
import 'package:chat_app/services/authentication_service.dart';
import 'package:chat_app/services/navigation_service.dart';
import 'package:chat_app/viewmodels/base_model.dart';

class StartUpViewModel extends BaseModel{

  final AuthenticationService _authenticationService = locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();


  Future handleStartUpLogic() async {
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();

    if(hasLoggedInUser){
      _navigationService.navigateTo(SelectDiscussionRoute);
    } else {
      _navigationService.navigateTo(LoginViewRoute);
    }

  }

}