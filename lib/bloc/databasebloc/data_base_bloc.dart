import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:mucbirsebepler/data/dbRepository.dart';
import 'package:mucbirsebepler/locator.dart';
import 'package:mucbirsebepler/model/post.dart';
import 'package:mucbirsebepler/model/user.dart';
import './bloc.dart';

class DataBaseBloc extends Bloc<DataBaseEvent, DataBaseState> {

  DbRepository dbRepository=getIt<DbRepository>();
  @override
  DataBaseState get initialState => InitialDataBaseState();

  @override
  Stream<DataBaseState> mapEventToState(
    DataBaseEvent event,
  ) async* {
    if(event is SaveUserDB){
      yield DataBaseLoadingState();
      try{
        //repodan al

        User gelenUser= event.user;
        User kaydedilenUser= await dbRepository.saveUser(gelenUser);
        yield DataBaseLoadedState(user: kaydedilenUser);
      }catch(_){
        debugPrint(_.toString());
        yield DataBaseErrorState();

      }
    }

    if(event is GetUserr){
      yield DataBaseLoadingState();
      try{
        //repodan al

        String gelenUser= event.userID;
        User kaydedilenUser= await dbRepository.getUser(gelenUser);
        yield DataBaseLoadedState(user: kaydedilenUser);
      }catch(_){
        debugPrint(_.toString());
        yield DataBaseErrorState();

      }
    }


  }
}
