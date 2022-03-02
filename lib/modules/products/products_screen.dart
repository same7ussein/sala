import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/categories_model.dart';
import '../../models/home_model.dart';
import '../../shared/components/components.dart';
import '../../shared/styles/color.dart';
import '../categoryDetails/category_details.dart';
import '../productDetails/product_details.dart';

class ProtectsScreen extends StatelessWidget {
  const ProtectsScreen({Key? key}) : super(key: key);

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
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).homeModel != null &&
              ShopCubit.get(context).categoriesModel != null,
          builder: (context) => productsBuilder(
              ShopCubit.get(context).homeModel!,
              ShopCubit.get(context).categoriesModel!,
              context),
          fallback: (context) =>
              Center(child: LottieBuilder.asset('assets/loading.json')),
        );
      },
    );
  }

  Widget productsBuilder(
          HomeModel model, CategoriesModel categoriesModel, context) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model.data!.banners
                  .map(
                    (e) => CachedNetworkImage(
                      imageUrl: e.image!,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                        color: Colors.red,
                      )),
                    ),
                    // Image(
                    //   image: NetworkImage('${e.image}'),
                    //   width: double.infinity,
                    //   fit: BoxFit.cover,
                    // ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 250.0,
                initialPage: 0,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: 100.0,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CategoryDetails(
                                        id: categoriesModel
                                            .data!.data[index].id)));
                          },
                          child: buildCategoryItem(
                              categoriesModel.data!.data[index])),
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 10.0,
                      ),
                      itemCount: categoriesModel.data!.data.length,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 1.0,
                  crossAxisSpacing: 1.0,
                  childAspectRatio: 1 / 2.2,
                  children: List.generate(
                    model.data!.products.length,
                    (index) => InkWell(
                        onTap: () {
                          navigateTo(context,
                              ProductDetails(model.data!.products[index].id));
                        },
                        child: buildGridProducts(
                            model.data!.products[index], context)),
                  )),
            ),
          ],
        ),
      );
  Widget buildCategoryItem(DataModel model) => Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          CachedNetworkImage(
            height: 120,
            width: 120,
            imageUrl: model.image!,
            placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(
              color: Colors.red,
            )),
          ),
          Container(
              color: Colors.black.withOpacity(.8),
              width: 100.0,
              child: Text(
                model.name!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white),
              )),
        ],
      );
  Widget buildGridProducts(ProductModel model, context) => Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                CachedNetworkImage(
                  height: 250,
                  imageUrl: model.image!,
                  placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                    color: Colors.red,
                  )),
                ),
                if (model.discount != 0)
                  Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    child: const Text(
                      'DISCOUNT',
                      style: TextStyle(fontSize: 15.0, color: Colors.white),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20.0,
                      height: 1.3,
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text(
                            '${model.price!.round()}EGP',
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: defaultColor,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          if (model.discount != 0)
                            Text(
                              '${model.oldPrice!}EGP',
                              style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough),
                            ),
                        ],
                      ),
                      const Spacer(),
                      FloatingActionButton(
                        backgroundColor:
                            ShopCubit.get(context).favorites[model.id]!
                                ? defaultColor
                                : Colors.grey,
                        mini: true,
                        onPressed: () =>
                            ShopCubit.get(context).changeFavourites(model.id!),
                        child: const Icon(
                          Icons.favorite_border,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
