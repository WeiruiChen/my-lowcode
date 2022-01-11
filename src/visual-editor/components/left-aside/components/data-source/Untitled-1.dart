import 'package:common/common.dart';
import 'package:common/widgets/custom_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:main_component/objects/momentlist.dart';
import '../states/user_profile_model.dart';
import '../states/user_momentlist_model.dart';
import 'package:common/widgets/voice_play.dart';

// 时间工具函数
// import 'package:common/utils/string_utility.dart';

// 网络请求model
class MytabPage extends StatefulWidget {
  final Map params;

  const MytabPage(this.params);

  @override
  State<StatefulWidget> createState() {
    return _MytabPage();
  }
}

class _MytabPage extends State<MytabPage> with AutomaticKeepAliveClientMixin {
  // 个人信息model
  late UsgsModel _model;
  late MomentList _momentList;
  ScrollController _scrollController = new ScrollController();
  bool isMyInfo = true;

  // 页面常量
  static const NAME_COLOR = Color(0xFF1F1F1F);
  static const SIGN_COLOR = Color(0xFF858585);
  static const COUNT_COLOR = Color(0xFF1F1F1F);
  static const SPLITE_COLOR = Color(0xFF979797);
  late final double signMaxWidth = screenWidth - 32 - 32;
  late final double screenWidth = MediaQuery.of(context).size.width;

  static const TextStyle AGE_STYLE = TextStyle(
      fontWeight: FontWeight.w400, fontSize: 11, color: Color(0xFFFFFFFF));

  @override
  void initState() {
    super.initState();

    _model = UsgsModel();
    _momentList = MomentList();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _momentList.requestData(NetRequestType.Refresh);
        // _momentList.
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    _momentList.dispose();
    _scrollController.dispose();
    super.dispose();
  }

// 个人信息栏
  Widget _buildUserInfo() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        // width: double.infinity,
        children: [
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 姓名
                          Selector<UsgsModel, String>(
                            selector: (BuildContext context, UsgsModel model) =>
                                model.userInfo.nickname,
                            builder: (context, nickname, child) {
                              return Text(
                                nickname,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21,
                                    color: NAME_COLOR),
                              );
                            },
                          ),
                          const SizedBox(width: 5),
                          _buildItemSexCell(),
                        ],
                      ),
                      // 个性签名
                      Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Selector<UsgsModel, String>(
                            selector: (BuildContext context, UsgsModel model) =>
                                model.userInfo.sign,
                            builder: (context, sign, child) {
                              return Container(
                                constraints:
                                    BoxConstraints(maxWidth: signMaxWidth),
                                child: Text(
                                  sign,
                                  maxLines: 1,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14, color: SIGN_COLOR),
                                ),
                              );
                            },
                          )),
                      // 标签
                      Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Selector<UsgsModel, String>(
                            selector: (BuildContext context, UsgsModel model) =>
                                model.userInfo.tag,
                            builder: (context, tag, child) {
                              // 分割tag
                              List<String> tagList = tag.split(',');

                              List<Widget> tagWidget = List.generate(
                                  tagList.length,
                                  (index) => _buildTagCell(tagList[index]));
                              return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: tagWidget);
                            },
                          )),
                      Container(
                        margin: const EdgeInsets.only(top: 28),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Selector<UsgsModel, int>(
                                  selector:
                                      (BuildContext context, UsgsModel model) =>
                                          model.userInfo.fansCount,
                                  builder: (context, fansCount, child) {
                                    return Text(
                                      fansCount.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          color: COUNT_COLOR),
                                    );
                                  },
                                ),
                                Text(isMyInfo ? '关注我的人' : '关注他的人',
                                    style: const TextStyle(
                                        fontSize: 12, color: SIGN_COLOR))
                              ],
                            ),
                            Container(
                              width: 0.4,
                              height: 37,
                              color: SPLITE_COLOR,
                              // child: ,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Selector<UsgsModel, int>(
                                  selector:
                                      (BuildContext context, UsgsModel model) =>
                                          model.userInfo.followCount,
                                  builder: (context, followCount, child) {
                                    return Text(
                                      followCount.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          color: COUNT_COLOR),
                                    );
                                  },
                                ),
                                Text(this.isMyInfo ? '我关注的人' : '他关注的人',
                                    style: const TextStyle(
                                        fontSize: 12, color: SIGN_COLOR))
                              ],
                            ),
                            Container(
                              width: 0.4,
                              height: 37,
                              color: SPLITE_COLOR,
                              // child: ,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Selector<UsgsModel, int>(
                                  selector:
                                      (BuildContext context, UsgsModel model) =>
                                          model.userInfo.guestCount,
                                  builder: (context, guestCount, child) {
                                    return Text(
                                      guestCount.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          color: COUNT_COLOR),
                                    );
                                  },
                                ),
                                const Text('访客数',
                                    style: TextStyle(
                                        fontSize: 12, color: SIGN_COLOR))
                              ],
                            )
                          ],
                        ),
                      ),
                      // 留白
                      const SizedBox(height: 39)
                    ],
                  ),
                )
              ])
        ]);
  }

  Widget _buildAvatar() {
    return Positioned(
      top: 0,
      child: Container(
        height: 87.0,
        width: 87.0,
        child: Selector<UsgsModel, String>(
          selector: (BuildContext context, UsgsModel model) =>
              model.userInfo.avatar,
          builder: (context, avatar, child) {
            return ClipOval(
              child: avatar == ''
                  ? Image.asset('assets/images/default_avatar.png',
                      package: 'common')
                  : Image.network(
                      avatar,
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(
            height: 43,
          ),
          Container(
            padding: const EdgeInsets.only(top: 35),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(21.0),
                    topRight: Radius.circular(21.0)),
                color: const Color(0xFFFFFFFF)),
            child: _buildUserInfo(),
          ),
        ]),
        _buildAvatar()
      ],
    );
  }

  Widget _buildTagCell(String tag) {
    return Container(
      height: 21.0,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.only(left: 7, top: 2, right: 7),
      decoration: const BoxDecoration(
          color: Color(0xFFFFF3EF),
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      child: Text(
        tag,
        style: const TextStyle(fontSize: 12, color: NAME_COLOR),
      ),
    );
  }

  Widget _buildItemSexCell() {
    return Container(
      height: 17.0,
      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFFFF66B8), Color(0xFFFF8099)]),
          borderRadius: BorderRadius.all(Radius.circular(9.0))),
      child: Row(
        children: [
          Image.asset(
            'assets/images/girl_3x.png',
            package: 'common',
            width: 10.0,
          ),
          const SizedBox(width: 2.0),
          Selector<UsgsModel, int>(
              selector: (BuildContext context, UsgsModel model) =>
                  model.userInfo.age,
              builder: (context, age, child) {
                return Text(
                  age.toString(),
                  style: AGE_STYLE,
                );
              })
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Selector<UsgsModel, String>(
            selector: (BuildContext context, UsgsModel model) =>
                model.userInfo.bgimg,
            builder: (context, bgimg, child) {
              return Image.network(
                bgimg,
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        Align(alignment: Alignment.bottomCenter, child: _buildInfo()),
      ],
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: Image.asset(
          'assets/images/info_edit.png',
          package: 'main_component',
          width: 23,
          height: 23,
        ),
        onPressed: () {},
      ),
      IconButton(
        icon: Image.asset(
          'assets/images/setting.png',
          package: 'main_component',
          width: 23,
          height: 23,
        ),
        onPressed: () {},
      )
    ];
  }

  Widget _buildAppSliver(BuildContext context) {
    int length = context
        .select<MomentList, int>((MomentList value) => value.momentInfo.length);
    List<MomentData> momentList = context.select<MomentList, List<MomentData>>(
        (MomentList value) => value.momentInfo);

    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          actions: isMyInfo
              ? _buildActions()
              : [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/chart.png',
                      package: 'main_component',
                      width: 23,
                      height: 23,
                    ),
                    onPressed: () {
                      Map<String, dynamic> arg = {
                        "coversationType": 1,
                        "targetId": 'liweijia'
                      };
                      FlutterBoostHelper.pushFlutter('conversation',
                          urlParams: arg);
                    },
                  )
                ],
          flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _buildHeader(context)),
          expandedHeight: 359,
          stretch: true,
          backgroundColor: Color(0xFFFFFFFF),
          pinned: false,
          floating: false,
          snap: false,
          primary: true,
          leading: isMyInfo
              ? null
              : IconButton(
                  color: Color(0xFF000000),
                  icon: Icon(Icons.arrow_back_ios_new),
                  onPressed: () => {Navigator.pop(context)},
                ),
        ),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              DateTime date = DateTime.fromMillisecondsSinceEpoch(
                  momentList[index].createTime * 1000);
              return Container(
                margin: EdgeInsets.all(5),
                child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      width: 83,
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: date.day < 10
                                  ? '0' + date.day.toString()
                                  : date.day.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                  color: COUNT_COLOR)),
                          TextSpan(
                              text: (date.month < 10
                                      ? '0' + date.month.toString()
                                      : date.month.toString()) +
                                  '月',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: COUNT_COLOR))
                        ]),
                      ),
                    ),
                    // SizedBox(width: 10),
                    Expanded(
                        child: Container(
                            height: 83,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 12, top: 21),
                                  width: 157,
                                  height: 31,
                                  child: VoicePlay(momentList[index].vurl),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18.0)),
                                gradient: LinearGradient(
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft,
                                    colors: [
                                      Color(0xFFFFEEE7),
                                      Color(0xFFFFF1FC),
                                      Color(0xFFCCFFFF)
                                    ])
                                // color: const Color(0xFFFFFFFF)),
                                )))
                  ],
                ),
              );
            },
            childCount: momentList.length,
            semanticIndexCallback: (widget, localIndex) {
              print('semanticIndexCallback:' + localIndex.toString());
              return localIndex;
            },
          ),
          itemExtent: 83,
        )
      ],
    );
  }

  Widget _buildBody() {
    return Container(
      color: Color(0xFFFFFFFF),
      child: Builder(builder: (context) {
        return _buildAppSliver(context);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // print('context' + context.toString());

    String uid = context.watch<GlobalData>().uid;
    // 判断是否首页跳转
    if (widget.params.containsKey('uid')) {
      uid = widget.params['uid'].toString();
      isMyInfo = false;
    }
    // if(widget.pa)
    _model.uid = uid;
    _momentList.uid = uid;
    _model.requestData(NetRequestType.Inital);
    _momentList.requestData(NetRequestType.Inital);

    // _model
    return Scaffold(
        body: MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _model),
        // ChangeNotifierProvider<UsgsModel>.value(value: _model),
        ChangeNotifierProvider.value(value: _momentList)
      ],
      child: _buildBody(),
    ));
    // )
  }

  @override
  bool get wantKeepAlive => true;
}
