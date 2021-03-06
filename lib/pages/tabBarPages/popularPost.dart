import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:mucbirsebepler/bloc/postbloc/bloc.dart';
import 'package:mucbirsebepler/model/post.dart';
import 'package:mucbirsebepler/model/user.dart';
import 'package:mucbirsebepler/widgets/uiHelperWidgets.dart';
import 'package:mucbirsebepler/bloc/databasebloc/bloc.dart';

class PopularPost extends StatefulWidget {
  final User user;

  const PopularPost({Key key, this.user}) : super(key: key);

  @override
  _PopularPostState createState() => _PopularPostState();
}

class _PopularPostState extends State<PopularPost> {
  PostBloc _postBloc;
  DataBaseBloc _dataBaseBloc;
  User finalUser;
  bool hasMore = false;
  bool yuklendiMi = false;
  ScrollController _scrollController;
  Widget waitingWidget = SizedBox(
    height: 0,
    width: 0,
  );
  List<Post> postList = [];

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_listeScrollListener);
    _postBloc = BlocProvider.of<PostBloc>(context);
    _dataBaseBloc = BlocProvider.of<DataBaseBloc>(context);
    _postBloc.add(Refresh());
    _postBloc.add(GetPost());
    _dataBaseBloc.add(GetUserr(userID: widget.user.userID));

    super.initState();
  }

  @override
  void dispose() {
    postList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _postBloc.add(GetMorePost());
            hasMore = true;
          },
          child: Center(
            child: Icon(
              LineAwesomeIcons.plus,
              size: 40,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.deepOrange,
        ),
        body: Container(
          color: Colors.black,
          width: width,
          height: height,
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                MultiBlocListener(
                  listeners: [
                    BlocListener<DataBaseBloc, DataBaseState>(
                      listener: (context, state) {
                        if (state is DataBaseLoadedState) {
                          setState(() {
                            yuklendiMi = true;
                          });
                          finalUser = state.user;
                        }
                      },
                    ),
                    BlocListener<PostBloc, PostState>(
                      listener: (context, state) {
                        if (state is PostLoadingState) {
                          if (!hasMore) {
                            waitingWidget = Center(
                              child: LoadingBouncingGrid.square(
                                borderColor: Colors.deepPurple,
                                backgroundColor: Colors.deepPurple,
                              ),
                            );
                          }
                        }
                        if (state is PostErrorState) {
                          waitingWidget = SizedBox(
                            width: 0,
                            height: 0,
                          );
                          final snackBar = SnackBar(
                            content:
                                Text("İnternet bağlantınızı kontrol ediniz"),
                            backgroundColor: Colors.red,
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                        if (state is PostLoadedState) {
                          hasMore = false;
                          waitingWidget = SizedBox(
                            height: 0,
                            width: 0,
                          );
                        }
                      },
                    )
                  ],
                  child: BlocBuilder<PostBloc, PostState>(
                      // ignore: missing_return
                      builder: (context, state) {
                    if (state is PostLoadingState) {
                      return Center(child: waitingWidget);
                    }
                    if (state is PostLoadedState) {
                      if (!hasMore && yuklendiMi) {
                        postList = state.listPost;
                        return SingleChildScrollView(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          child: AnimationLimiter(
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                controller: _scrollController,
                                itemCount: hasMore
                                    ? postList.length + 1
                                    : postList.length,
                                shrinkWrap: true,
                                itemBuilder: (contex, index) {
                                  return AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 875),
                                      child: ScaleAnimation(
                                        child: FadeInAnimation(
                                          child: postCoontainer(
                                              gelenUser: finalUser,
                                              bloc: _postBloc,
                                              post: postList[index],
                                              width: width,
                                              height: height,
                                              context: context),
                                        ),
                                      ));
                                }),
                          ),
                        );
                      } else
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                    }
                    if (state is PostErrorState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _listeScrollListener() {
    if (_scrollController.offset <=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _postBloc.add(GetMorePost());
    }
  }
}
