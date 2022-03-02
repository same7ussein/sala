import '../../models/cartModel.dart';
import '../../models/change_favorites_model.dart';
import '../../models/login_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ShopChangBottomState extends ShopStates {}

/// get Home Data states
class ShopLoadingHomeDataState extends ShopStates {}

class ShopSuccessHomeDataState extends ShopStates {}

class ShopErrorHomeDataState extends ShopStates {
  final String error;

  ShopErrorHomeDataState(this.error);
}

class ShopSuccessCategoriesState extends ShopStates {}

class ShopErrorCategoriesState extends ShopStates {
  final String error;

  ShopErrorCategoriesState(this.error);
}

class ShopChangeFavoritesState extends ShopStates {}

class ShopSuccessChangeFavoritesState extends ShopStates {
  late final ChangeFavoritesModel model;
  ShopSuccessChangeFavoritesState(this.model);
}

class ShopErrorChangeFavoritesState extends ShopStates {
  final String error;

  ShopErrorChangeFavoritesState(this.error);
}

/// Favorites States
class ShopSuccessFavoritesState extends ShopStates {}

class ShopLoadingGetFavoritesState extends ShopStates {}

class ShopErrorFavoritesState extends ShopStates {
  final String error;

  ShopErrorFavoritesState(this.error);
}

//search
class LoadingSearch extends ShopStates {}

class SuccessSearch extends ShopStates {}

class ErrorSearch extends ShopStates {}

/// Profile States
class ShopSuccessProfileState extends ShopStates {}

class ShopLoadingGetProfileState extends ShopStates {}

class ShopErrorProfileState extends ShopStates {
  final String error;

  ShopErrorProfileState(this.error);
}

class ShopSuccessUpdateUserState extends ShopStates {
  final ShopLoginModel loginModel;
  ShopSuccessUpdateUserState(this.loginModel);
}

class ShopLoadingUpdateUserState extends ShopStates {}

class ShopErrorUpdateUserState extends ShopStates {
  final String error;

  ShopErrorUpdateUserState(this.error);
}

class InitialGetProductsDetailsState extends ShopStates {}

class LoadingGetProductsDetailsData extends ShopStates {}

class SuccessGetProductsDetailsData extends ShopStates {}

class ErrorGetProductsDetailsData extends ShopStates {}

class ChangeIndicatorState extends ShopStates {}

class LoadingCart extends ShopStates {}

class SuccessCart extends ShopStates {
  final CartModel cart;
  SuccessCart(this.cart);
}

class ErrorCart extends ShopStates {}

class LoadingGetCAtegoryDetailsData extends ShopStates {}

class SuccessGetCAtegoryDetailsData extends ShopStates {}

class ErrorGetCAtegoryDetailsData extends ShopStates {}

class LoadinggetAllCarts extends ShopStates {}

class SuccessgetAllCarts extends ShopStates {}

class ErrorgetAllCarts extends ShopStates {}

class LoadinggetCountCarts extends ShopStates {}

class SuccessgetCountCarts extends ShopStates {}

class ErrorgetCountCarts extends ShopStates {}

class plusDone extends ShopStates {}

class minusDone extends ShopStates {}


class ShopLoadingAddAddressState extends ShopStates {}

class ShopSuccessAddAddressState extends ShopStates {}

class ShopErrorAddAddressState extends ShopStates {}
