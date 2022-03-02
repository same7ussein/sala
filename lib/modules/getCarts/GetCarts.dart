import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/getCartModel.dart';
import '../../shared/components/components.dart';
import '../search/search_screen.dart';

class GetCarts extends StatelessWidget {
  const GetCarts({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<ShopCubit>(context)..getAllCarts(),
        child: BlocConsumer<ShopCubit, ShopStates>(
          builder: (context, state) => Scaffold(
            appBar: AppBar(
              title: const Text('Carts'),
              actions: [
                IconButton(
                    onPressed: () {
                      navigateTo(context, Search());
                    },
                    icon: const Icon(Icons.search))
              ],
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            body: ShopCubit.get(context).getCartModel == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Center(
                        child: LottieBuilder.asset('assets/loading.json')),
                  )
                : ShopCubit.get(context).getCartModel!.data.cartItems.isEmpty
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
                              "No products in your carts yet, try add some",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.blueAccent.shade200,
                                  fontSize: 25),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.grey[200],
                              child: GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisCount: 1,
                                children: List.generate(
                                    ShopCubit.get(context)
                                        .getCartModel!
                                        .data
                                        .cartItems
                                        .length,
                                    (index) => productsView(
                                        ShopCubit.get(context).getCartModel,
                                        index,
                                        context)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius: BorderRadius.circular(15)),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                "Total Price : ${ShopCubit.get(context).getCartModel!.data.total} EGP",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 25),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
          listener: (context, state) {
            if (state is SuccessCart) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Deleted Succefully"),
                backgroundColor: Colors.red,
                duration: Duration(milliseconds: 350),
              ));
            }
          },
        ));
  }
}

Widget productsView(GetCartModel? model, index, context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.5),
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: model!.data.cartItems[index].product.image,
                placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                  color: Colors.red,
                )),
              ),
            ),
            Center(
              child: Text(
                model.data.cartItems[index].product.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    ShopCubit.get(context).minusQuantity(model, index);
                    ShopCubit.get(context).updateCartData(
                        id: model.data.cartItems[index].id.toString(),
                        quantity: ShopCubit.get(context).quantity);
                  },
                  icon: const Icon(Icons.remove),
                  color: Colors.blue,
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  model.data.cartItems[index].quantity.toString(),
                  style: const TextStyle(color: Colors.blue, fontSize: 25),
                ),
                const SizedBox(
                  width: 2,
                ),
                IconButton(
                  onPressed: () {
                    ShopCubit.get(context).plusQuantity(model, index);
                    ShopCubit.get(context).updateCartData(
                        id: model.data.cartItems[index].id.toString(),
                        quantity: ShopCubit.get(context).quantity);
                  },
                  icon: const Icon(Icons.add),
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    "${model.data.cartItems[index].product.price.toString()} EGP",
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => ShopCubit.get(context)
                      .changeCart(id: model.data.cartItems[index].product.id),
                  icon: const Icon(
                    Icons.restore_from_trash,
                    color: Colors.red,
                    size: 30,
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
  );
}
