part of 'offer_cubit.dart';

class OfferState extends Equatable {
  const OfferState();

  @override
  List<Object> get props => [];
}

class OfferInit extends OfferState {
  const OfferInit();
}

//Loading
class LDeclineOffer extends OfferState {
  const LDeclineOffer();
}

//Failed
class FDeclineOffer extends OfferState {
  final Failure failure;
  const FDeclineOffer({required this.failure});
}

//Success
class SDeclineOffer extends OfferState {
  final DeclineOfferResponseModel result;
  const SDeclineOffer({required this.result});
}

//Loading
class LAcceptOffer extends OfferState {
  const LAcceptOffer();
}

//Failed
class FAcceptOffer extends OfferState {
  final Failure failure;
  const FAcceptOffer({required this.failure});
}

//Success
class SAcceptOffer extends OfferState {
  final AcceptOfferResponseModel result;
  const SAcceptOffer({required this.result});
}

//Loading
class LPlaceOffer extends OfferState {
  const LPlaceOffer();
}

//Failed
class FPlaceOffer extends OfferState {
  final Failure failure;
  const FPlaceOffer({required this.failure});
}

//Success
class SPlaceOffer extends OfferState {
  final AcceptOfferResponseModel result;
  const SPlaceOffer({required this.result});
}

//Loading
class LPaymentHistory extends OfferState {
  const LPaymentHistory();
}

//Failed
class FPaymentHistory extends OfferState {
  final Failure failure;
  const FPaymentHistory({required this.failure});
}

//Success
class SPaymentHistory extends OfferState {
  final PaymentHistoryModelResponseModel result;
  const SPaymentHistory({required this.result});
}
