import 'package:equatable/equatable.dart';
import 'package:mucbirsebepler/model/user.dart';

abstract class DataBaseEvent extends Equatable {
  const DataBaseEvent();
}


class SaveUserDB extends DataBaseEvent{
  final User user;

  SaveUserDB({this.user});
  @override
  List<Object> get props => [user];


}

class GetUserr extends DataBaseEvent{
final String userID;

GetUserr({this.userID});
@override

List<Object> get props => [userID];
}




