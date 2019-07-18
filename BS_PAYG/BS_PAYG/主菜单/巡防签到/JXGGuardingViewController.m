//
//  JXGGuardingViewController.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/9.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "JXGGuardingViewController.h"
#import "JXGTrackViewController.h"
//地图
#import <BaiduTraceSDK/BaiduTraceSDK.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
//模型
#import "BMKSportNode.h"
#import "MBProgressHUD.h"

@interface JXGGuardingViewController ()<BTKTraceDelegate, BTKTrackDelegate, BMKLocationServiceDelegate>{

    BOOL timingOut;//是否超时
    int test;
    BOOL checkOuting;//正在签出
    //从JXGTrackViewController中取得并且修改值
    int timeCount;//计时

    //轨迹数据，需要传递至下页
    NSMutableArray *sportNodes;//轨迹点
    NSInteger sportNodeNum;//轨迹点数

    MBProgressHUD *hud;
    NSTimer *timer;

    float totalDistance;//移动的距离

    CLLocation *currentLocation;//如果为nil，则尚未定位成功

}

//定位管理
@property(nonatomic, strong)BMKLocationService *locService;
@end

@implementation JXGGuardingViewController

#pragma mark - [界面初始化]
- (void)viewDidLoad {
    test=0;
    [super viewDidLoad];

    //初始化轨迹节点数组
    sportNodes = [[NSMutableArray alloc] init];

    timeCount = 0;
    sportNodeNum = 2;
    BMKSportNode *sportNode = [[BMKSportNode alloc] init];
    sportNode.coordinate = CLLocationCoordinate2DMake(30.726475969187277, 120.71691511373905);
    sportNode.angle = 0;
    sportNode.speed = 0;
    [sportNodes addObject:sportNode];

    BMKSportNode *sportNode2 = [[BMKSportNode alloc] init];
    sportNode2.coordinate = CLLocationCoordinate2DMake(30.739490999999994, 120.72338100000002);
    sportNode2.angle = 0;
    sportNode2.speed = 0;
    [sportNodes addObject:sportNode2];
    self->totalDistance = 20.0;

    [self layout];
    //启动百度鹰眼
    [self initBaiduMapService];
    //开始采集
    [[BTKAction sharedInstance] startGather:self];


    //启动定时器，每秒执行一次runTimer函数
    timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(runTimer:) userInfo:nil repeats:YES];
}

//界面布局初始化
- (void)layout{

    //隐藏返回按钮
    self.navigationItem.hidesBackButton = YES;
    //签出按钮样式位置设定
    _finishBtn.layer.cornerRadius = _finishBtn.frame.size.width/2;
    _finishBtn.layer.borderWidth = 5;
    _finishBtn.layer.borderColor = [UIColor whiteColor].CGColor;
}

//初始化百度地图服务
- (void)initBaiduMapService{
    //设置SDK运行时需要的基础信息
    BTKServiceOption *sop = [[BTKServiceOption alloc] initWithAK:BAIDUMAP_KEY mcode:BUNDLE_ID serviceID:BAIDUMAP_serviceID keepAlive:false];
    //服务初始化
    [[BTKAction sharedInstance] initInfo:sop];
    // 设置开启轨迹服务时的服务选项，指定本次服务以“Name_ID”的名义开启
    BTKStartServiceOption *op = [[BTKStartServiceOption alloc] initWithEntityName:[NSString stringWithFormat:@"%@_%@",[UserModel getInstance].name, [UserModel getInstance].phone]];

    // 开启服务
    [[BTKAction sharedInstance] startService:op delegate:self];
}

#pragma mark - [懒加载]
- (BMKLocationService *)locService{
    if (!_locService) {
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        //设置定位精度
        _locService.desiredAccuracy = kCLLocationAccuracyBest;
        _locService.distanceFilter = 10;
    }
    return _locService;
}

#pragma mark - [定时器]
- (void)runTimer : (NSTimer *)timer{
    timeCount++;
    //分
    int min = timeCount/60;
    //秒
    int sec = timeCount%60;
    //xx分xx秒
    _time_label.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];

    //每半分钟执行一次,记录当前位置的经纬度以及里程
    if(timeCount%30==0){

        //查询里程
        //设置纠偏选项
        BTKQueryTrackProcessOption *option = [[BTKQueryTrackProcessOption alloc] init];
        option.denoise = YES;//去噪
        option.vacuate = YES;//抽稀
        option.mapMatch = YES;//绑路
        option.radiusThreshold = 20;
        option.transportMode = BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_WALKING;

        NSUInteger endTime = [[NSDate date] timeIntervalSince1970];

//        BTKQueryHistoryTrackRequest *request = [[BTKQueryHistoryTrackRequest alloc] initWithEntityName:[NSString stringWithFormat:@"%@_%@", [UserModel getInstance].name,[UserModel getInstance].phone] startTime:endTime - timeCount - 30 endTime:endTime isProcessed:TRUE processOption:option supplementMode:BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_WALKING outputCoordType:BTK_COORDTYPE_BD09LL sortType:BTK_TRACK_SORT_TYPE_DESC pageIndex:0 pageSize:PAGE_MAXSIZE serviceID:BAIDUMAP_serviceID tag:123];
//        [[BTKTrackAction sharedInstance] queryHistoryTrackWith:request delegate:self];

        BTKQueryTrackDistanceRequest *request = [[BTKQueryTrackDistanceRequest alloc] initWithEntityName:[UserModel getInstance].phone?[NSString stringWithFormat:@"%@_%@", [UserModel getInstance].name, [UserModel getInstance].phone]:@"平安义工" startTime:endTime - timeCount - 30 endTime:endTime isProcessed:TRUE processOption:option supplementMode:BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_WALKING serviceID:BAIDUMAP_serviceID tag:123];

        [[BTKTrackAction sharedInstance] queryTrackDistanceWith:request delegate:self];

    }
}

/**
 里程查询的回调方法
 */
-(void)onQueryTrackDistance:(NSData *)response{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];

    float distance = [dic[@"distance"] doubleValue]/1000.0;

    //回归主线程
    dispatch_async(dispatch_get_main_queue(), ^(){
        self->_distance_label.text = [NSString stringWithFormat:@"%.2f", distance];
    });
}
#pragma mark - [事件]
//点击签出
- (IBAction)finish:(UIButton *)sender {

    //加载指示器
    hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"签出中...";

    checkOuting = YES;

    //启动跟踪定位
    [self.locService startUserLocationService];
    [self->hud hideAnimated:YES];
    //进入下一页
    [self performSegueWithIdentifier:@"gotoNext" sender:nil];
}

//点击首页按钮
- (IBAction)backHome:(UIBarButtonItem *)sender {
    [[UIAlertTool alloc] showAlertViewOn:self title:@"是否要停止巡防？" message:@"本次巡防记录将无效" otherButtonTitle:@"确定" cancelButtonTitle:@"取消" confirmHandle:^{
        //定时器停止
        [self->timer invalidate];
        self->timer = nil;

        //停止采集
        [[BTKAction sharedInstance] stopGather:self];
        //停止服务
        [[BTKAction sharedInstance] stopService:self];
        [self.navigationController popViewControllerAnimated:YES];

    } cancleHandle:^{

    }];
}

- (void)readPage:(int)pageIndex{
    // 查询一段时间内的轨迹（必须在服务开启后调用）
    BTKQueryTrackProcessOption *option = [[BTKQueryTrackProcessOption alloc] init];
    option.denoise = YES;//去噪
    option.vacuate = YES;//抽稀
    option.mapMatch = YES;//绑路
    option.radiusThreshold = 20;//定位精度过滤阀值
    option.transportMode = BTK_TRACK_PROCESS_OPTION_TRANSPORT_MODE_WALKING;//交通方式

    NSUInteger endTime = [[NSDate date] timeIntervalSince1970];

    BTKQueryHistoryTrackRequest *request = [[BTKQueryHistoryTrackRequest alloc] initWithEntityName:[UserModel getInstance].phone?[NSString stringWithFormat:@"%@_%@",[UserModel getInstance].name,[UserModel getInstance].phone]:@"平安义工" startTime:endTime - timeCount - 30 endTime:endTime isProcessed:TRUE processOption:option supplementMode:BTK_TRACK_PROCESS_OPTION_SUPPLEMENT_MODE_WALKING outputCoordType:BTK_COORDTYPE_BD09LL sortType:BTK_TRACK_SORT_TYPE_DESC pageIndex:pageIndex pageSize:PAGE_MAXSIZE serviceID:BAIDUMAP_serviceID tag:123];
    [[BTKTrackAction sharedInstance] queryHistoryTrackWith:request delegate:self];
}

/**
 轨迹查询回调方法
 */
- (void)onQueryHistoryTrack:(NSData *)response{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:nil];
    [self initSportNodes:dic];
}

//初始化轨迹点
- (void)initSportNodes : (NSDictionary *)_dic{
    int status = [_dic[@"status"] intValue];
    if (status != 0) {
        NSLog(@"查询历史轨迹数据失败");
        return;
    }else{
        NSLog(@"查询历史轨迹数据成功");
    }
    NSArray *points = [_dic[@"points"] copy];
    if (points.count == 0) {
        NSLog(@"points没数据%d",test);
        test++;
        return;
    }
    //读取数据
    NSArray *array = _dic[@"points"];
    if (array.count > 0) {
        for (NSDictionary *dic in array) {
            BMKSportNode *sportNode = [[BMKSportNode alloc] init];
            sportNode.coordinate = CLLocationCoordinate2DMake([dic[@"latitude"] doubleValue], [dic[@"longitude"] doubleValue]);
            sportNode.angle = [dic[@"direction"] doubleValue];
            sportNode.speed = [dic[@"speed"] doubleValue];
            [sportNodes addObject:sportNode];
        }
    }
    sportNodeNum += sportNodes.count;

//    //回归主线程
//    dispatch_async(dispatch_get_main_queue(), ^(){
//
//        //如果能被 PAGE_SIZE 整除
//        //并且当前读取数据 不是0
//        //需要请求下一页, 否则表示已获取所有数据
//        if (self->sportNodeNum % PAGE_MAXSIZE == 0 && array.count != 0) {
//            [self readPage:(int)self->sportNodeNum/10+1];
//        }
//        else{
//            [self->hud hideAnimated:YES];
//
//            //停止采集
//            [[BTKAction sharedInstance] stopGather:self];
//            //停止服务
//            [[BTKAction sharedInstance] stopService:self];
//
//            self->totalDistance = [_dic[@"distance"] doubleValue]/1000.0;
//
//            //进入下一页
//            [self performSegueWithIdentifier:@"gotoNext" sender:nil];
//        }
//    });
}

#pragma mark - [百度鹰眼代理]
- (void)onStartService:(BTKServiceErrorCode) error{
    NSLog(@"启动服务: %lu", (unsigned long)error);
}

- (void)onStartGather:(BTKGatherErrorCode)error{
    NSLog(@"开始采集: %lu", (unsigned long)error);
}

- (void)onStopGather:(BTKGatherErrorCode)error{
    NSLog(@"停止采集: %lu", (unsigned long)error);
}

- (void)onStopService:(BTKServiceErrorCode)error{
    NSLog(@"停止服务: %lu", (unsigned long)error);
}

#pragma mark - [百度地图代理]
/**
 *在地图View将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *地图渲染完毕后会调用此接口
 */
- (void)mapViewDidFinishRendering:(BMKUserLocation *)userLocation{

}

/**
 *用户方向更新后，会调用此函数
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    if (checkOuting) {
        currentLocation = userLocation.location;
        [self checkOut];

        checkOuting = NO;
    }
}

/**
 *用户位置更新后，会调用此函数
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (checkOuting) {
        currentLocation = userLocation.location;
        [self checkOut];

        checkOuting = NO;
    }
}

- (void)checkOut{
    //定时器停止
    [timer invalidate];
    timer = nil;
//    //初始化轨迹节点数组
//    sportNodes = [[NSMutableArray alloc] init];
    //读第一页
    [self readPage:1];
}
/**
 *在地图View停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

//
#pragma mark - [杂乱]
    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
    }
#pragma mark - [页面传值]
    - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

        if([segue.identifier isEqualToString:@"gotoNext"]){
            JXGTrackViewController *destination = [segue destinationViewController];

            //所有轨迹点
            if ([destination respondsToSelector:@selector(setSportNodes:)]) {
                [destination setValue:sportNodes forKey:@"sportNodes"];
            }

            //轨迹点数量
            if ([destination respondsToSelector:@selector(setSportNodeNum:)]) {
                [destination setValue:@(sportNodeNum) forKey:@"sportNodeNum"];
            }

            //所用时间
            if ([destination respondsToSelector:@selector(setTimeCount:)]) {
                [destination setValue:@(timeCount) forKey:@"timeCount"];
            }

            //所用时间
            if ([destination respondsToSelector:@selector(setDistance:)]) {
                [destination setValue:@(totalDistance) forKey:@"distance"];
            }
        }
    }
@end
