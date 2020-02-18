import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/api/api.dart';
import 'package:mygameslist_flutter/models/review_model.dart';
import 'package:mygameslist_flutter/models/wiki_model.dart';

class DetailsEvent {}

class LoadDetailsEvent extends DetailsEvent {
  final String id;
  LoadDetailsEvent(this.id);
}

class ReviewDetailsEvent extends DetailsEvent {
  final ReviewModel review;

  ReviewDetailsEvent({this.review});
}

class DetailsLoadState {}

class DetailsLoadingState extends DetailsLoadState {}

class DetailsLoadedState extends DetailsLoadState {
  final WikiModel article;
  final List<ReviewModel> reviews;
  DetailsLoadedState(this.article, this.reviews);
}

class DetailsFailedState extends DetailsLoadState {}

class DetailsBloc extends Bloc<DetailsEvent, DetailsLoadState> {
  @override
  DetailsLoadState get initialState => DetailsLoadingState();

  @override
  Stream<DetailsLoadState> mapEventToState(DetailsEvent event) async* {
    if (event is LoadDetailsEvent) {
      yield DetailsLoadingState();
      try {
        WikiModel article = await ApiHelper.getArticleById(event.id);
        List<ReviewModel> reviews = await ApiHelper.getAllReviews(article.id);
        yield DetailsLoadedState(article, reviews);
      } catch (e) {
        yield DetailsFailedState();
      }
    } else if (event is ReviewDetailsEvent) {
      try {
        await ApiHelper.postReview(event.review);
        WikiModel article = await ApiHelper.getArticleById(event.review.id);
        List<ReviewModel> reviews = await ApiHelper.getAllReviews(article.id);
        yield DetailsLoadedState(article, reviews);
      } catch (e) {
        yield DetailsFailedState();
      }
    }
  }
}
