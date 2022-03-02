import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sala_app/layout/cubit/states.dart';
import '../../models/addressmodel.dart';
import '../../models/cartModel.dart';
import '../../models/categories_model.dart';
import '../../models/categoryDetailsModel.dart';
import '../../models/change_favorites_model.dart';
import '../../models/favorites_model.dart';
import '../../models/getCartModel.dart';
import '../../models/home_model.dart';
import '../../models/login_model.dart';
import '../../models/productDetailsModel.dart';
import '../../models/search_model.dart';
import '../../modules/cateogries/categories_screen.dart';
import '../../modules/favorites/favorites_screen.dart';
import '../../modules/products/products_screen.dart';
import '../../modules/settings/settings_screen.dart';
import '../../shared/components/constant.dart';
import '../../shared/network/dio_helper/dio_helper.dart';
import '../../shared/network/end_points.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    const ProtectsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    const SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ShopChangBottomState());
  }

  HomeModel? homeModel;

  void getHomeData() {
    emit(ShopLoadingHomeDataState());
    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJason(value.data);
      printFullText(homeModel.toString());
      for (var element in homeModel!.data!.products) {
        favorites.addAll({element.id!: element.inFavorites!});
        isCart.addAll({element.id!: element.isCart!});
      }

      emit(ShopSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorHomeDataState(error));
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(ShopSuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorCategoriesState(error));
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavourites(int productId) {
    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavoritesState());
    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      lang: 'en',
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      print(value.data);
      if (!changeFavoritesModel!.status!) {
        favorites[productId] = !favorites[productId]!;
      } else {
        getFavourite();
      }
      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error) {
      favorites[productId] = !favorites[productId]!;
      print(error.toString());
      emit(ShopErrorChangeFavoritesState(error));
    });
  }

  FavoritesModel? favoritesModel;
  Map<int, bool> favorites = {};
  void getFavourite() {
    emit(ShopLoadingGetFavoritesState());
    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      printFullText(value.data.toString());

      emit(ShopSuccessFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorFavoritesState(error));
    });
  }

  //search
  SearchModel? searchModel;
  void getSearchProduct({required String txt}) {
    emit(LoadingSearch());
    DioHelper.postData(url: SEARCH, data: {'text': txt}, token: token)
        .then((value) {
      searchModel = SearchModel.fromJson(value.data);
      emit(SuccessSearch());
    }).catchError((error) {
      emit(ErrorSearch());
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingGetProfileState());
    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      printFullText(userModel!.data!.name!);

      emit(ShopSuccessProfileState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorProfileState(error));
    });
  }

  //********************************************************************

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserState());
    DioHelper.putData(url: UPDATE_PROFILE, token: token, data: {
      'name': name,
      'email': email,
      'phone': phone,
    }).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      printFullText(userModel!.data!.name!);

      emit(ShopSuccessUpdateUserState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorProfileState(error));
    });
  }

  ProductDetailsModel? productDetailsModel;
  void getProductDetails(String id) {
    emit(LoadingGetProductsDetailsData());
    DioHelper.getData(url: PRODUCTSDETAILS + id, token: token).then((value) {
      productDetailsModel = ProductDetailsModel.fromJson(value.data);
      emit(SuccessGetProductsDetailsData());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorGetProductsDetailsData());
    });
  }

  int value = 0;
  void changeVal(index) {
    value = index;
    emit(ChangeIndicatorState());
  }

  CategoryDetailsModel? categoyDetails;
  void getCategoryDetail({required int? catId}) {
    emit(LoadingGetCAtegoryDetailsData());
    DioHelper.getData(url: PRODUCTS, token: token, query: {
      'category_id': catId,
    }).then((value) {
      categoyDetails = CategoryDetailsModel.fromJson(value.data);
      emit(SuccessGetCAtegoryDetailsData());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorGetCAtegoryDetailsData());
    });
  }

  GetCartModel? getCartModel;
  void getAllCarts() {
    emit(LoadinggetAllCarts());
    DioHelper.getData(url: CARTS, token: token).then((value) {
      getCartModel = GetCartModel.fromJson(value.data);
      emit(SuccessgetAllCarts());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorgetAllCarts());
    });
  }

  Map<int, bool> isCart = {};
  CartModel? cartModel;
  void changeCart({required int id}) {
    emit(LoadingCart());
    DioHelper.postData(url: CARTS, data: {'product_id': id}, token: token)
        .then((value) {
      isCart[id] = !(isCart[id]!);
      getAllCarts();
      cartModel = CartModel.fromJson(value.data);
      emit(SuccessCart(cartModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCart());
    });
  }

  int quantity = 1;
  void plusQuantity(GetCartModel model, index) {
    quantity = model.data.cartItems[index].quantity;
    quantity++;
    emit(plusDone());
  }

  void minusQuantity(GetCartModel model, index) {
    quantity = model.data.cartItems[index].quantity;
    if (quantity > 1) quantity--;
    emit(minusDone());
  }

  void updateCartData({required String id, int? quantity}) {
    emit(LoadinggetCountCarts());
    DioHelper.putData(
            url: CARTSUPDATE + id, data: {'quantity': quantity}, token: token)
        .then((value) {
      getAllCarts();
      emit(SuccessgetCountCarts());
    }).catchError((error) {
      emit(ErrorgetCountCarts());
    });
  }

  AddressModel? addressModel;
  void addUserAddress({
    required String name,
    required String city,
    required String region,
    required String street,
    required String latitude,
    required String longitude,
  }) {
    emit(ShopLoadingAddAddressState());
    DioHelper.postData(
      url: ADDRESSES,
      data: {
        name: 'name',
        city: 'city',
        region: 'region',
        street: 'details',
        latitude: 'latitude',
        longitude: 'longitude',
      },
      token: token,
    ).then((value) {
      emit(ShopSuccessAddAddressState());
      addressModel = AddressModel.fromJson(value.data);
      print('${addressModel!}');
      print('${addressModel!.status}');
      print('${addressModel!.message}');
    }).catchError((onError) {
      emit(ShopErrorAddAddressState());
      print('Error when add user addresses =====> ${onError.toString()}');
    });
  }

  bool? emailValid = false;
  bool legalEmail(String email) {
    return emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
