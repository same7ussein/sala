import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/favorites_model.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/color.dart';
import '../productDetails/product_details.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {
          if (state is ShopSuccessChangeFavoritesState) {
            if (state.model.status!) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.model.message.toString()),
                backgroundColor: Colors.deepPurple,
                duration: const Duration(milliseconds: 350),
              ));
            }
            if (!state.model.status!) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.model.message.toString()),
                backgroundColor: Colors.red,
                duration: const Duration(milliseconds: 350),
              ));
            }
          }
        },
        builder: (context, state) => ShopCubit.get(context).favoritesModel ==
                null
            ? Center(child: LottieBuilder.asset('assets/loading.json'))
            : ShopCubit.get(context).favoritesModel!.data!.data.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.menu,
                          size: 120,
                          color: Colors.grey,
                        ),
                        Text(
                          "No products yet, try add some",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.blueAccent.shade200, fontSize: 25),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => buildFavItem(
                        ShopCubit.get(context).favoritesModel!, context, index),
                    separatorBuilder: (context, index) => myDivider(),
                    itemCount: ShopCubit.get(context)
                        .favoritesModel!
                        .data!
                        .data
                        .length,
                  ));
  }

  Widget buildFavItem(FavoritesModel model, context, index) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 460,
          child: InkWell(
            onTap: () {
              navigateTo(
                  context, ProductDetails(model.data!.data[index].product!.id));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    CachedNetworkImage(
                      height: 300,
                      width: double.infinity,
                      imageUrl: '${model.data!.data[index].product!.image}',
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                        color: Colors.red,
                      )),
                    ),
                    if (model.data!.data[index].product!.discount != 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        color: Colors.red,
                        child: const Text(
                          'DISCOUNT',
                          style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${model.data!.data[index].product!.name}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 20.0,
                          height: 1.1,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          '${model.data!.data[index].product!.price} EGP',
                          style: const TextStyle(
                              fontSize: 20.0,
                              color: defaultColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 20),
                        if (model.data!.data[index].product!.discount != 0)
                          Text(
                            '${model.data!.data[index].product!.oldPrice} EGP',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough),
                          ),
                        const Spacer(),
                        FloatingActionButton(
                          onPressed: () => ShopCubit.get(context)
                              .changeFavourites(
                                  model.data!.data[index].product!.id!),
                          child: const Icon(
                            Icons.favorite_border,
                            size: 30.0,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
}
