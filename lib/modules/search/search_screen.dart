import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/search_model.dart';
import '../../shared/styles/color.dart';
import '../productDetails/product_details.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ShopCubit>(context),
      child: BlocConsumer<ShopCubit, ShopStates>(
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Search",
                  ),
                  onChanged: (value) {
                    ShopCubit.get(context).getSearchProduct(txt: value);
                  },
                ),
                if (state is LoadingSearch)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0, vertical: 10),
                    child: Center(
                        child: LottieBuilder.asset('assets/loading.json')),
                  ),
                ShopCubit.get(context).searchModel == null
                    ? const Text("")
                    : GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 1,
                        mainAxisSpacing: 1 / 2,
                        childAspectRatio: 1 / 1.3,
                        children: List.generate(
                            ShopCubit.get(context)
                                .searchModel!
                                .data!
                                .data
                                .length,
                            (index) => productsSearchView(
                                  ShopCubit.get(context).searchModel,
                                  index,
                                  ShopCubit.get(context).favorites,
                                  context,
                                )),
                      ),
              ],
            ),
          ),
        ),
        listener: (context, state) {},
      ),
    );
  }
}

Widget productsSearchView(
    SearchModel? model, index, Map<int, bool> fav, context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductDetails(model!.data!.data[index].id)));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.5),
      child: Container(
        height: 300,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              GestureDetector(
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      height: 220,
                      imageUrl: model!.data!.data[index].image!,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                        color: Colors.red,
                      )),
                    ),

                    //problem

                    // if (model.data!.data[index].discount != 0)
                    //   Container(
                    //     color: Colors.red,
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 5.0,
                    //     ),
                    //     child: const Text(
                    //       'DISCOUNT',
                    //       style: TextStyle(fontSize: 15.0, color: Colors.white),
                    //     ),
                    //   ),
                  ],
                ),
              ),
              Text(
                model.data!.data[index].name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20.0,
                  height: 1.3,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      '${model.data!.data[index].price} EGP',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  // if (model.data!.data[index].discount != 0)
                  //   Text(
                  //     '${model.data!.data[index].oldPrice}',
                  //     style: const TextStyle(
                  //         color: Colors.blue,
                  //         decoration: TextDecoration.lineThrough),
                  //   ),
                  const Spacer(),
                  FloatingActionButton(
                    backgroundColor: ShopCubit.get(context)
                            .favorites[model.data!.data[index].id]!
                        ? defaultColor
                        : Colors.grey,
                    mini: true,
                    onPressed: () => ShopCubit.get(context)
                        .changeFavourites(model.data!.data[index].id!),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 20.0,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
