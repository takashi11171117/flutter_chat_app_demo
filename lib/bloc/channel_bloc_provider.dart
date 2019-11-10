import 'package:flutter/widgets.dart';
import 'channel_bloc.dart';

/// Thank you https://medium.com/flutter-jp/bloc-provider-70e869b11b2f
///
/// ・inheritFromWidgetOfExactType
/// これが呼ばれると引数に渡ってきたbuild contextが登録されてWidgetに変更があった時に下位ツリーrebuildを要求できる(updateShouldNotify で制御可能)
/// そのため、didChangeDependencies 以降のタイミングでしか呼べない
///
/// ・ancestorInheritedElementForWidgetOfExactType
/// 単にInheritedWidgetのその時点でのElementを取得するだけ
/// initState タイミングでも呼べる

class ChannelBlocProvider extends InheritedWidget {
  final ChannelBloc bloc;
  ChannelBlocProvider({
    Key key,
    @required Widget child,
    @required this.bloc
  }) : super(key: key, child: child);
  
  static ChannelBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ChannelBlocProvider) as ChannelBlocProvider).bloc;
  }

  @override
  bool updateShouldNotify(ChannelBlocProvider oldWidget) => bloc != oldWidget.bloc;
  
}