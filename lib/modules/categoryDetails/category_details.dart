import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/categoryDetailsModel.dart';
import '../productDetails/product_details.dart';

class CategoryDetails extends StatelessWidget {
  final int? id;
  const CategoryDetails({Key? key, required this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ShopCubit>(context)..getCategoryDetail(catId: id),
      child: BlocConsumer<ShopCubit, ShopStates>(
        builder: (context, state) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Categories'),
          ),
          body: ShopCubit.get(context).categoyDetails == null ||
                  state is LoadingGetCAtegoryDetailsData
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child:
                      Center(child: LottieBuilder.asset('assets/loading.json')),
                )
              : Container(
                  color: Colors.grey[200],
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(
                        ShopCubit.get(context).categoyDetails!.data.data.length,
                        (index) => productsView(
                            ShopCubit.get(context).categoyDetails,
                            index,
                            context)),
                  ),
                ),
        ),
        listener: (context, state) {
          if (state is SuccessGetCAtegoryDetailsData) {}
        },
      ),
    );
  }
}

Widget productsView(CategoryDetailsModel? model, index, context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProductDetails(model!.data.data[index].id)));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.5),
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    CachedNetworkImage(
                      imageUrl: model!.data.data[index].image,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                        color: Colors.red,
                      )),
                    ),
                    if (model.data.data[index].discount != 0)
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
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 15),
                    child: Text(
                      "${model.data.data[index].price.toString()} EGP",
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                  model.data.data[index].discount != 0
                      ? Text(
                          model.data.data[index].oldPrice.toString(),
                          style: TextStyle(
                              color: Colors.grey[400],
                              decoration: TextDecoration.lineThrough),
                        )
                      : const Text(""),
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
