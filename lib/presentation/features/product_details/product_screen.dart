import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openflutterecommerce/data/fake_repositories/models/product.dart';
import 'package:openflutterecommerce/data/fake_repositories/product_repository.dart';
import 'package:openflutterecommerce/presentation/widgets/widgets.dart';

import '../wrapper.dart';
import 'product_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import 'views/details.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({Key key, this.productId}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: OpenFlutterScaffold(
      background: null,
      title: null,
      body: BlocProvider<ProductBloc>(
          create: (context) {
            return ProductBloc(productRepository: ProductRepository())
              ..add(ProductStartEvent(widget.productId));
          },
          child: ProductWrapper()),
      bottomMenuIndex: 1,
    ));
  }
}

class ProductWrapper extends StatefulWidget {
  final Product product;

  const ProductWrapper({Key key, this.product}) : super(key: key);

  @override
  _ProductWrapperState createState() => _ProductWrapperState();
}

class _ProductWrapperState extends OpenFlutterWrapperState<ProductWrapper> {
  //State createState() => OpenFlutterWrapperState();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
        bloc: BlocProvider.of<ProductBloc>(context),
        builder: (BuildContext context, ProductState state) {
          if (state is ProductLoadedState) {
            return getPageView(<Widget>[
              ProductDetailsView(
                  product: state.product,
                  similarProducts: state.similarProducts,
                  changeView: changePage),
            ]);
          }
          return Container();
        });
  }
}
