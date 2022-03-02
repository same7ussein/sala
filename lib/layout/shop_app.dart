import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modules/deawer.dart';
import '../modules/getCarts/GetCarts.dart';
import '../modules/search/search_screen.dart';
import '../shared/components/components.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return Scaffold(
            drawer: const NavigationDrawerWidget(),
            appBar: AppBar(
              title: const Text('Sala'),
              //leading: const MenuDrawer(),
              actions: [
                IconButton(
                    onPressed: () {
                      navigateTo(context, Search());
                    },
                    icon: const Icon(Icons.search)),
              ],
            ),
            body: cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const GetCarts()));
              },
              child: const Icon(Icons.shopping_cart),
              backgroundColor: Colors.deepOrange,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: AnimatedBottomNavigationBar(
              icons: const [
                Icons.home,
                Icons.category,
                Icons.favorite_border,
                Icons.account_circle,
              ],
              activeColor: Colors.deepOrange,
              onTap: (index) {
                ShopCubit.get(context).changeBottom(index);
              },
              activeIndex: ShopCubit.get(context).currentIndex,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.softEdge,
              leftCornerRadius: 32,
              rightCornerRadius: 32,
            ));
      },
    );
  }
}
