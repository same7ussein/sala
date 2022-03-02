import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/cartModel.dart';
import '../../models/productDetailsModel.dart';
import 'package:readmore/readmore.dart';

import '../../shared/styles/color.dart';

class ProductDetails extends StatelessWidget {
  final id;
  const ProductDetails(this.id);
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<ShopCubit>(context)
          ..getProductDetails(id.toString()),
        child: BlocConsumer<ShopCubit, ShopStates>(
            builder: (context, state) => (state
                    is LoadingGetProductsDetailsData)
                ? Scaffold(
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Center(
                          child: LottieBuilder.asset('assets/loading.json')),
                    ),
                  )
                : Scaffold(
                    backgroundColor: Colors.white,
                    floatingActionButton: FloatingActionButton(
                      heroTag: "btn2",
                      onPressed: () {
                        return ShopCubit.get(context).changeCart(
                            id: ShopCubit.get(context)
                                .productDetailsModel!
                                .data
                                .id);
                      },
                      child: const Icon(Icons.add_shopping_cart),
                      backgroundColor: (ShopCubit.get(context).isCart[id]!)
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      iconTheme: const IconThemeData(color: Colors.black),
                    ),
                    body: buildPeoducts(
                        context,
                        ShopCubit.get(context).productDetailsModel,
                        ShopCubit.get(context).cartModel,
                        ShopCubit.get(context).isCart,
                        id),
                  ),
            listener: (context, state) {
              if (state is SuccessCart) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.cart.message.toString()),
                  backgroundColor: Colors.brown,
                  duration: const Duration(milliseconds: 350),
                ));
              }
              if (state is LoadingGetProductsDetailsData) {}
            }));
  }
}

Widget buildPeoducts(
    context, ProductDetailsModel? model, CartModel? cartModel, cart, id) {
  List<Widget> images = [];
  for (var element in model!.data.images) {
    images.add(CachedNetworkImage(
      height: 250,
      imageUrl: element,
      placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(
        color: Colors.red,
      )),
    ));
  }
  return ShopCubit.get(context).productDetailsModel == null
      ? Center(child: Center(child: LottieBuilder.asset('assets/loading.json')))
      : Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView(
            children: [
              Text(
                model.data.name,
                style: const TextStyle(fontSize: 25),
              ),
              CarouselSlider(
                items: images,
                options: CarouselOptions(
                  onPageChanged: (index, reason) =>
                      {ShopCubit.get(context).changeVal(index)},
                  height: 250.0,
                  initialPage: 0,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(seconds: 1),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Center(
                  child: AnimatedSmoothIndicator(
                      effect: const WormEffect(
                          dotColor: Color.fromARGB(255, 133, 131, 131),
                          activeDotColor: Colors.red),
                      activeIndex: ShopCubit.get(context).value,
                      count: images.length),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text(
                    "${model.data.price} EGP",
                    style: const TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                  const Spacer(),
                  FloatingActionButton(
                    backgroundColor:
                        ShopCubit.get(context).favorites[model.data.id]!
                            ? defaultColor
                            : Colors.grey,
                    mini: true,
                    onPressed: () =>
                        ShopCubit.get(context).changeFavourites(model.data.id),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 20.0,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Divider(
                  height: 2,
                  color: Colors.blue,
                  endIndent: 10,
                  indent: 10,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Description",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
              const SizedBox(
                height: 15,
              ),
              ReadMoreText(
                model.data.description.toString(),
                style: const TextStyle(color: Colors.black, fontSize: 20),
                trimLines: 8,
                colorClickableText: Colors.red,
                trimMode: TrimMode.Line,
                trimCollapsedText: '...Show more',
                trimExpandedText: ' show less',
              ),
            ],
          ),
        );
}
