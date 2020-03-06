import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/api/api.dart';
import 'package:mygameslist_flutter/models/game_model.dart';

class ListLoadEvent {}

class ListLoadState {}

class ListLoadingState extends ListLoadState {}

class ListLoadedState extends ListLoadState {
  final List<GameModel> games;
  ListLoadedState(this.games);
}

class ListFailedState extends ListLoadState {}

class ListBloc extends Bloc<ListLoadEvent, ListLoadState> {
  @override
  ListLoadState get initialState => ListLoadingState();

  @override
  Stream<ListLoadState> mapEventToState(ListLoadEvent event) async* {
    yield ListLoadingState();
    try {
      List<GameModel> games = await ApiHelper.getAllGames();
      yield ListLoadedState(games);
    } catch (e) {
      yield ListFailedState();
    }
  }
}
