import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mygameslist_flutter/api/api.dart';
import 'package:mygameslist_flutter/models/review_model.dart';
import 'package:mygameslist_flutter/models/game_model.dart';

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
  final String reviewId;
  DeleteReviewDetailsEvent({this.reviewId});
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
      try {
        print("LISTBLOC: loading reviews");
        List<ReviewModel> reviews = await ApiHelper.getAllReviews(event.id);
        print("LISTBLOC: got ${reviews.length} reviews from api");
        if (state is DetailsLoadedState) {
          print("LISTBLOC: loading new reviews with old game");
          yield DetailsLoadedState((state as DetailsLoadedState).game, reviews);
        } else {
          print("LISTBLOC: loading game with details and reviews");
          GameModel game = await ApiHelper.getGameById(event.id);
          print("LISTBLOC: loaded new game is " + game.title);
          yield DetailsLoadedState(game, reviews);
        }
      } catch (e) {
        print("LISTBLOC: failed to load details");
        print(e);
        yield DetailsFailedState();
      }
    } else if (event is SubmitReviewDetailsEvent) {
      try {
        await ApiHelper.postReview(event.review);
        GameModel game = await ApiHelper.getGameById(event.review.articleId);
        List<ReviewModel> reviews = await ApiHelper.getAllReviews(game.id);
        yield DetailsLoadedState(game, reviews);
      } catch (e) {
        yield DetailsFailedState();
      }
    } else if (event is DeleteReviewDetailsEvent) {
      yield state;
    }
  }
}
