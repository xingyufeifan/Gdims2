//
//  NDDefine.h
//  Gdims2
//
//  Created by 李青松 on 2018/3/1.
//  Copyright © 2018年 name. All rights reserved.
//

#ifndef NDDefine_h
#define NDDefine_h

#define ND_BOUNDS_WIDTH         [[UIScreen mainScreen] bounds].size.width
#define ND_BOUNDS_HEIGHT        [[UIScreen mainScreen] bounds].size.height

#define ND_IMAGE_URL            @"http://183.230.108.112/meteor/downImage.do?imageName="

//MARK: - APIURL
#define NDROOT_URL1             @"http://183.230.108.112"
#define NDPORT1                 @"8099"
//MARK: -
#define NDROOT_URL2             @"http://www.cqdzjc.com"
#define NDPORT2                 @"8090"
//MARK: -
#define NDROOT_URL3             @"http://183.230.108.112"
#define NDPORT3                 @"8090"

#define NDAPI_LOGIN             @"/meteor/findFunCfg.do"         //登录
#define NDAPI_UPLAOD_LOCATION   @"/meteor/uploadMeteorLongitudeAndLatitude.do"   //群测群防人员定位
#define NDAPI_UPLAOD_LOCATION2  @"/meteor/receiveLonLat.do"                      //驻守人员及片区专管员定位
#define NDAPI_UPLAOD_LOCATION3  @"/meteor/uploadAreaAdminLonLat.do"                      //片区专管员定位
#define NDAPI_HOTLINE_URL       @"/meteor/getHelpMobile.do"
#define NDAPI_CHECK_UPADTE      @"/meteor/haveNewVersion.do"
#define NDAPI_VIDEO_UPLOAD      @"/meteor/saveSurveyVideo.do"                    //视频上传
//MARK: - 群测群防
#define NDAPI_FIND_MACRO        @"/meteor/findMacro.do"                          //灾害点列表
#define NDAPI_FIND_MONITOR      @"/meteor/findMonitor.do"                        //监测点列表
#define NDAPI_UPLOAD_DATA       @"/meteor/saveMonDate.do"                        //宏观观测数据上报 监测点数据上报
#define NDAPI_QCQF_HISTORY      @"/meteor/findHistoryData.do"                    //上报历史
//MARK: - 驻守员
#define NDAPI_GARRISON_SAVE_DAILY   @"/meteor/DailyApp/saveWorkLog.do"           //日报上传
#define NDAPI_GARRISON_SAVE_DISATER @"/meteor/DailyApp/saveDisater.do"           //灾情速报
//MARK: - 片区专管
#define NDAPI_AREAOFFICER_SAVE_WEEK @"/meteor/DailyApp/saveWeekLog.do"           //周报上报接口
//MARK: - 日志、周报列表
#define NDAPI_DAILY_WEEK_LIST       @"/meteor/listByMobile.do"                   //日志、周报列表

//MARK: - COLOR
#define NDCOLOR_RGB(r,g,b,a) [UIColor colorWithRed: (r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]


#endif /* NDDefine_h */
