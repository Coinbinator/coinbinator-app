import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:le_crypto_alerts/metas/ticker.dart';
import 'package:le_crypto_alerts/metas/ticker_watch.dart';
import 'package:le_crypto_alerts/pages/watching/watching_page_model.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/e.dart';
import 'package:provider/provider.dart';

class WatchListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WatchingPageModel>(context);

    return CustomScrollView(
      slivers: [
        // SliverMenu(c),
        // SliverAppBar()
        // SliverMenu(
        SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: WatchListViewMenuDelegate(),
        ),
        // ),
        SliverList(
            delegate: SliverChildListDelegate([
          for (final tickerWatch in model.watchingTickers) ...[
            // TextButton(
            //     onPressed: () => Navigator.of(context).pop(),
            //     child: Text("asd")),
            buildListItem(context, tickerWatch,
                app().tickers.getTickerFromTickerWatch(tickerWatch)),
          ],
        ]))
      ],
    );
  }

  Widget buildListItem(
    BuildContext context,
    TickerWatch tickerWatch,
    Ticker ticker,
  ) {
    final model = Provider.of<WatchingPageModel>(context);

    //todo: mover estilos para classe centralizada de estilos
    final style1 = Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20);
    final style2 = Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 16);
    final style3 = Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 12);

    final stylePositive = Theme.of(context)
        .textTheme
        .bodyText2
        .copyWith(fontSize: 12, color: Colors.green);
    final styleNegative = Theme.of(context)
        .textTheme
        .bodyText2
        .copyWith(fontSize: 12, color: Colors.red);

    // final watchListViewModel = Provider.of<WatchListViewModel>(context, listen: true);
    // return ListTile(title: Text(tickerWatch.key));

    return GestureDetector(
      onLongPress: () {
        model.selectTickerWatch(tickerWatch);
      },
      onTap: () {
        if (model.selectingTickerWatches())
          return model.toggleTickerWatch(tickerWatch);
      },
      child: Card(
          margin: EdgeInsets.all(4),
          color: model.selectedTickerWatches.contains(tickerWatch.key)
              ? Colors.amberAccent
              : null,
          child: Padding(
            padding: EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            style: style1, text: tickerWatch.pair.base?.symbol),
                        TextSpan(style: style2, text: '/'),
                        TextSpan(
                            style: style2,
                            text: tickerWatch.pair.quote?.symbol),
                      ]),
                    ),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            style: style3, text: tickerWatch.exchange.name),
                      ]),
                    ),
                  ],
                ),
                Column(children: [
                  if (ticker != null) ...[
                    RichText(
                      // text: TextSpan(style: style1, text: "${E.currency(ticker.price, decimalDigits: 2, symbol: 'USD', name: 'Dolar', locale: 'en_us')}"),
                      text: TextSpan(
                          style: style1,
                          text: "${E.currency(ticker.price, symbol: "")}"),
                    ),
                    RichText(
                      // text: TextSpan(style: stylePositive, text: '"+1.4% 24h" ${ticker.date}'),
                      // text: TextSpan(style: stylePositive, text: '"+1.4% 24h"'),
                      text: TextSpan(
                          style: stylePositive,
                          text: ticker.pair.quote?.symbol),
                    ),
                  ],
                ]),
              ],
            ),
          )),
    );
  }
}

class WatchListViewMenuDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final model = Provider.of<WatchingPageModel>(context);

    return Container(
      color: LeColors.white.shade50,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                model.startAddTickerWatch(context);
              },
              child: Text("Add watch"),
            ),
          ],
        ),
      ),
    );
  }
}
