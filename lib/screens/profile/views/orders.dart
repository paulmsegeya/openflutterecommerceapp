import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openflutterecommerce/config/theme.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:openflutterecommerce/repos/models/user_order.dart';
import 'package:openflutterecommerce/screens/profile/profile_event.dart';
import 'package:openflutterecommerce/widgets/block_header.dart';
import 'package:openflutterecommerce/widgets/order_tile.dart';
import 'package:openflutterecommerce/widgets/widgets.dart';

import '../../wrapper.dart';
import '../profile_bloc.dart';
import '../profile_state.dart';

class MyOrdersView extends StatefulWidget {
  final Function changeView;

  const MyOrdersView({Key key, this.changeView}) : super(key: key);

  @override
  _MyOrdersViewState createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView> {
  final List<Widget> tabs = <Widget>[
    Padding(
      padding: const EdgeInsets.symmetric(horizontal:AppSizes.sidePadding),
      child: Tab(text: 'Delivered'),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal:AppSizes.sidePadding),
      child: Tab(text: 'Processing'),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal:AppSizes.sidePadding),
      child: Tab(text: 'Cancelled'),
    ),
  ];


  @override
  Widget build(BuildContext context) {
    ThemeData _theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        
      },
      builder: (context, state) {
        ProfileBloc bloc = BlocProvider.of<ProfileBloc>(context);
        if ( state is ProfileMyOrdersState) {
          return SafeArea(
            child: DefaultTabController(
              length: tabs.length,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: AppSizes.sidePadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>
                      [
                        OpenFlutterBlockHeader(
                          title: 'My Orders', 
                          width: width,
                        ),
                        Padding(padding:EdgeInsets.only(bottom: AppSizes.sidePadding)),
                        TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          labelColor: AppColors.white,
                          labelPadding: EdgeInsets.symmetric(horizontal: 4),
                          unselectedLabelColor: AppColors.black,
                          indicator: BubbleTabIndicator(
                            indicatorHeight: 32,
                            indicatorColor: Colors.black,
                            tabBarIndicatorSize: TabBarIndicatorSize.tab,
                          ),
                          tabs: tabs,
                          unselectedLabelStyle:_theme.textTheme.headline5,
                          labelStyle: _theme.textTheme.headline5.copyWith(
                            color: AppColors.white
                          ),
                        ),
                      ] 
                    ),
                  ),
                  Padding(padding:EdgeInsets.only(bottom: AppSizes.sidePadding)),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal:AppSizes.sidePadding),
                      child: TabBarView(
                        children: <Widget>[
                          buildOrderList(state.orderData, bloc),
                          buildOrderList(state.orderData, bloc),
                          buildOrderList(state.orderData, bloc),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ), 
          );
        }
        return Container();
      }
    );
  }
  buildOrderList(List<UserOrder> orders, ProfileBloc bloc){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return OpenFlutterOrderTile(
          order: orders[index],
          onClick: ((int orderId) => {
            bloc..add(ProfileMyOrderDetailsEvent(orderId)),
            widget.changeView(changeType: ViewChangeType.Exact, index: 7)
          }),
        );
      }
    );
  }
}

