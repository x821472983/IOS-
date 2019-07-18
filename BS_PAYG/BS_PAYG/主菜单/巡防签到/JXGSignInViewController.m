//
//  JXGSignInViewController.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "JXGSignInViewController.h"
//百度地图
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
//视图相关
#import "YCPickerView.h"
//模型
#import "JDModel.h"
#import "SQModel.h"

@interface JXGSignInViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, CLLocationManagerDelegate, YCPickerViewDelegate>{
    UIButton *currentBtn;//当前点击的按钮
    
    CLLocation *currentLocation;//如果为nil，则尚未定位成功
}

//百度地图
@property(nonatomic, strong)BMKMapView *mapView;
//定位管理
@property(nonatomic, strong)BMKLocationService *locService;
//选择器
@property(nonatomic, strong)YCPickerView *pickerView;
//网络
@property(nonatomic, strong)YCManager *manager;
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象
//模型
@property(nonatomic, strong)NSArray<JDModel *> *jdModels;
@property(nonatomic, strong)NSArray<SQModel *> *sqModels;
@end

@implementation JXGSignInViewController

#pragma mark - [懒加载]
- (YCManager *)manager{
    if (!_manager) {
        _manager = [YCManager getInstance];
    }
    return _manager;
}

//地图加载
- (BMKMapView *)mapView{
    if (!_mapView) {
        //地图初始化
        _mapView = [[BMKMapView alloc] init];
        //显示定位图层
        _mapView.showsUserLocation = YES;
         _mapView.userTrackingMode = BMKUserTrackingModeHeading;//设置定位的状态

    }
    return _mapView;
}


//定位加载
- (BMKLocationService *)locService{
    if (!_locService) {
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
        
        //设置定位精度
        _locService.desiredAccuracy = kCLLocationAccuracyBest;
        _locService.distanceFilter = 10;
        //启动LocationService
        [_locService startUserLocationService];
        //iOS 9（不包含iOS 9） 之前设置允许后台定位参数，保持不会被系统挂起
        [_locService setPausesLocationUpdatesAutomatically:NO];
        
    }
    return _locService;
}
//选择器加载
- (YCPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[YCPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _pickerView.delegate = self;
        [self.tabBarController.view addSubview:_pickerView];
    }
    return _pickerView;
}

#pragma mark - [界面初始化]
- (void)viewDidLoad {
    [super viewDidLoad];

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"数据读取中...";
    
    
    //请求公安局数据
    [self.manager selectStreet_successHandle:^(id data) {
        NSLog(@"%@",data);
        if([data[@"result"] isEqualToNumber:@0]){
            //转模型
            self->_jdModels = [JDModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            NSLog(@"%@",self->_jdModels);
                [hud hideAnimated:YES];
        }else{
            [hud hideAnimated:YES];
            [UIAlertTool showHUDToViewCenter:self.view message:data[@"message"]];
        }
        
        
    } failureHandle:^(id error) {
        [hud hideAnimated:YES];
        [UIAlertTool showHUDToViewCenter:self.view message:@"街道、社区数据获取失败，请稍后重试"];
        NSLog(@"街道、社区数据_失败: %@", error);
    }];
    
    //布局 创建地图
    [self layout];
    //启动定位
    [self beginLocation];
}

//视图加载时
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}
//视图不加载时
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;

    [_pickerView hideWithAnimate];
    [_pickerView removeFromSuperview];
    _pickerView = nil;
}

//层
- (void)layout{
    _btn1.layer.borderWidth = 1;
    _btn2.layer.borderWidth = 1;
    _beginBtn.layer.cornerRadius = _beginBtn.frame.size.width/2;
    _beginBtn.layer.borderWidth = 5;
    _beginBtn.layer.borderColor = [UIColor whiteColor].CGColor;

    //安装百度地图控件
    [self.view addSubview:self.mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self->_btn1.mas_top).offset(-20);
    }];
}

- (IBAction)selectLocation:(UIButton *)sender {
    
    //如果已经显示，则隐藏
    if (_pickerView.frame.origin.y < SCREEN_HEIGHT && _pickerView.frame.origin.y != 0) {
        [_pickerView hideWithAnimate];
        return;
    }
    
    switch (sender.tag) {
        case 1:{
            //获取所有街道名称
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i < self.jdModels.count; i++) {
                [dataArray addObject:_jdModels[i].streetName];
            }
//            NSMutableArray *dataArray = [NSMutableArray array];
//            for (int i = 0; i < 5; i++) {
//                NSString *res = [NSString stringWithFormat:@"街道%d",i];
//                [dataArray addObject:res];
//            }
            
            [self.pickerView updateData:dataArray];
            currentBtn = _btn1;
            //每当街道选择器点击时，社区选择器归零
            [_btn2 setTitle:@"请选择社区" forState:UIControlStateNormal];
            [self.pickerView show];
            break;
        }
            
        case 2:{
            if ([_btn1.titleLabel.text containsString:@"请选择"]) {
                [UIAlertTool showHUDToViewCenter:self.view message:@"请先选择街道"];
                break;
            }
            //获取当前街道里所有社区名称
            NSMutableArray *dataArray = [NSMutableArray array];
            for (int i = 0; i < self.jdModels.count; i++) {
                if ([_btn1.titleLabel.text isEqualToString:_jdModels[i].streetName]) {
                    NSLog(@"%@", _jdModels[i].com);
                    NSLog(@"%lu", (unsigned long)_jdModels[i].com.count);
                    for (int j = 0; j < _jdModels[i].com.count; j++) {
                        [dataArray addObject:_jdModels[i].com[j].communityName];
                    }
                    break;
                }
            }
//            //获取当前街道里所有社区名称
//            NSMutableArray *dataArray = [NSMutableArray array];
//            for (int i = 0; i < 5; i++) {
//                NSString *res = [NSString stringWithFormat:@"社区%d",i];
//                [dataArray addObject:res];
//            }
            
            [self.pickerView updateData:dataArray];
            currentBtn = _btn2;
            [self.pickerView show];
            break;
        }
        default:
            break;
    }
}


//启动定位服务
- (BOOL)beginLocation{

    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse) {
        [[UIAlertTool alloc] showAlertViewOn:self title:@"" message:@"检测到您定位服务尚未始终开启\n无法使用巡防功能" otherButtonTitle:@"前往开启" cancelButtonTitle:@"暂不" confirmHandle:^{
            // 跳转到设置界面
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                if (@available(iOS 10.0, *)) {
                    OPEN_URL(url);
                } else {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        } cancleHandle:^{
            nil;
        }];
        return false;
    }

    //启动跟踪定位
    [self.locService startUserLocationService];

    return true;
}

#pragma mark - [事件]
- (void)YCPickerView_confirmed : (NSString *_Nonnull)info{
    [currentBtn setTitle:info forState:UIControlStateNormal];
}


//开始采集轨迹
- (IBAction)begin:(UIButton *)sender {

    //判断用户是否开启定位服务
    if (![self beginLocation]) {
        return;
    }

    //判断用户是否选择街道
    if ([_btn1.titleLabel.text containsString:@"请选择"]) {
        [UIAlertTool showHUDToViewCenter:self.view message:@"请选择街道"];
        return;
    }

    //判断用户是否选择社区
    if ([_btn2.titleLabel.text containsString:@"请选择"]) {
        [UIAlertTool showHUDToViewCenter:self.view message:@"请选择社区"];
        return;
    }

    //判断当前定位是否成功
    if (!currentLocation) {
        [UIAlertTool showHUDToViewCenter:self.view message:@"定位尚未成功，请稍后尝试"];
        return;
    }

    [[UIAlertTool alloc] showAlertViewOn:self title:@"平安义工提醒您" message:@"巡防开始后，请保持网络畅通，并不要关闭app（您依然可以正常使用您手机的其他功能，例如拍照，电话等！）" otherButtonTitle:@"我知道了" cancelButtonTitle:@"再想想" confirmHandle:^{

//        //储存当前时间
//        NSDateFormatter *format = [NSDateFormatter new];
//        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//        NSString *now = [format stringFromDate:[NSDate new]];


//        //获取当前社区名称和社区id
//        //获取社区模型
//        SQModel *currentModel;
//        //遍历街道
//        for (int i = 0; i < self.jdModels.count; i++) {
//            //遍历社区
//            for (int j = 0; j < _jdModels[i].com.count; j++) {
//                if ([_jdModels[i].com[j].name isEqualToString:_btn2.titleLabel.text]) {
//                    currentModel = _jdModels[i].com[j];
//                    break;
//                }
//            }
//        }
//        [UserModel getInstance].sqName = currentModel.name;
//        [UserModel getInstance].sqId = currentModel.comId;

          //加载中，并且弹框显示
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//        hud.mode = MBProgressHUDModeIndeterminate;
//        hud.label.text = @"签到中...";

        [self->_pickerView removeFromSuperview];
        self->_pickerView = nil;
        [self performSegueWithIdentifier:@"gotoNext" sender:nil];

    } cancleHandle:^{

    }];
}

#pragma mark - [CLLocationManager代理]
// 代理方法中监听授权的改变,被拒绝有两种情况,一是真正被拒绝,二是服务关闭了
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户未决定");
            break;
        }
            // 系统预留字段,暂时还没用到
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"受限制");
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            // 被拒绝有两种情况 1.设备不支持定位服务 2.定位服务被关闭
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"真正被拒绝");
            }
            else {
                NSLog(@"没有开启此功能");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"前后台定位授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"前台定位授权");
            break;
        }
            
        default:
            break;
    }
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
 *用户方向更新后，会调用此函数
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    
    currentLocation = userLocation.location;
    
    BMKCoordinateRegion region;//表示范围的结构体
    region.center = userLocation.location.coordinate;//中心点
    region.span.latitudeDelta = 0.002;//经度范围（设置为0.1表示显示范围为0.2的纬度范围）
    region.span.longitudeDelta = 0.002;//纬度范围
    [_mapView setRegion:region animated:YES];
}

/**
 *用户位置更新后，会调用此函数
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];

    currentLocation = userLocation.location;
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
- (void)didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"location error");
}

#pragma mark - [杂乱]
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

@end
