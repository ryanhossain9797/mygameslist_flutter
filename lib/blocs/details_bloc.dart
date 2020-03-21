import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/api/api.dart';
import 'package:mygameslist_flutter/models/review_model.dart';
import 'package:mygameslist_flutter/models/game_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsEvent {}

class LoadDetailsEvent extends DetailsEvent {
  final String id;
  LoadDetailsEvent(this.id);
}

class SubmitReviewDetailsEvent extends DetailsEvent {
  final ReviewModel review;
  SubmitReviewDetailsEvent({this.review});
}

class DeleteReviewDetailsEvent extends DetailsEvent {
  final ReviewModel review;
  DeleteReviewDetailsEvent({this.review});
}

class DetailsLoadState {}

class DetailsLoadingState extends DetailsLoadState {}

class DetailsLoadedState extends DetailsLoadState {
  final GameModel game;
  final List<ReviewModel> reviews;
  DetailsLoadedState(this.game, this.reviews);
}

class DetailsFailedState extends DetailsLoadState {}

class DetailsBloc extends Bloc<DetailsEvent, DetailsLoadState> {
  @override
  DetailsLoadState get initialState => DetailsLoadingState();

  @override
  Stream<DetailsLoadState> mapEventToState(DetailsEvent event) async* {
    if (event is LoadDetailsEvent) {
      yield DetailsLoadingState();
      //-------------------Intentional delay for better smoothness
      await Future.delayed(Duration(seconds: 1));
      try {
        print("DETAILSBLOC: loading reviews");
        List<ReviewModel> reviews = await ApiHelper.getAllReviews(event.id);
        print("DETAILSBLOC: got ${reviews.length} reviews from api");
        if (state is DetailsLoadedState) {
          print("DETAILSBLOC: loading new reviews with old game");
          yield DetailsLoadedState((state as DetailsLoadedState).game, reviews);
        } else {
          print("DETAILSBLOC: loading game with details and reviews");
          GameModel game = await ApiHelper.getGameById(event.id);
          print("DETAILSBLOC: loaded new game is " + game.title);
          yield DetailsLoadedState(game, reviews);
        }
      } catch (e) {
        print("DETAILSBLOC: failed to load details");
        print(e);
        yield DetailsFailedState();
      }
    } else if (event is SubmitReviewDetailsEvent) {
      //yield DetailsLoadingState();
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString("token");
        await ApiHelper.postReview(token, event.review);
        GameModel game = await ApiHelper.getGameById(event.review.articleId);
        List<ReviewModel> reviews = await ApiHelper.getAllReviews(game.id);
        yield DetailsLoadedState(game, reviews);
      } catch (e) {
        yield DetailsFailedState();
      }
    } else if (event is DeleteReviewDetailsEvent) {
      //yield DetailsLoadingState();
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString("token");
        await ApiHelper.deleteReviewById(token,
            aid: event.review.articleId,
            cid: event.review.id,
            username: event.review.username);
        print("DETAILSBLOC: deleted, reloading");
        GameModel game = await ApiHelper.getGameById(event.review.articleId);
        List<ReviewModel> reviews = await ApiHelper.getAllReviews(game.id);
        yield DetailsLoadedState(game, reviews);
      } catch (e) {
        print("DETAILSBLOC: failed to delete $e");
        yield DetailsFailedState();
      }
    }
  }
}
