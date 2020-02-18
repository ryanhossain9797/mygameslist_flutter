import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/api/api.dart';
import 'package:mygameslist_flutter/models/wiki_model.dart';

class ListLoadEvent {}

class ListLoadState {}

class ListLoadingState extends ListLoadState {}

class ListLoadedState extends ListLoadState {
  final List<WikiModel> articles;
  ListLoadedState(this.articles);
}

class ListFailedState extends ListLoadState {}

class ListBloc extends Bloc<ListLoadEvent, ListLoadState> {
  @override
  ListLoadState get initialState => ListLoadingState();

  @override
  Stream<ListLoadState> mapEventToState(ListLoadEvent event) async* {
    yield ListLoadingState();
    try {
      List<WikiModel> articles = await ApiHelper.getAllArticles();
      yield ListLoadedState(articles);
    } catch (e) {
      yield ListFailedState();
    }
  }
}
