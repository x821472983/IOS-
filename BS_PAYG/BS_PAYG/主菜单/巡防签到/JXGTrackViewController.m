//
//  JXGTrackViewController.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/9.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "JXGTrackViewController.h"
//百度地图
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface JXGTrackViewController ()<BMKMapViewDelegate>{
    BMKPolyline *pathPolyline;
    BMKPointAnnotation *sportAnnotation1;//一个大头针
    BMKPointAnnotation *sportAnnotation2;//一个大头针
    
    NSInteger currentIndex;//当前结点
}

//是否完成数据上传？
@property(nonatomic, assign)BOOL didFinish;
//网络
@property(nonatomic, strong)YCManager *manager;
//百度地图
@property(nonatomic, strong)BMKMapView *mapView;

@end

@implementation JXGTrackViewController


#pragma mark - [界面初始化]
- (void)viewDidLoad {
    [super viewDidLoad];
    _score_label.text = [NSString stringWithFormat:@"%d", [_timeCount intValue]*10];
    // Do any additional setup after loading the view.
    [self layout];
}

- (void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)layout{
    
    //默认隐藏右上角按钮，只在失败时提供给用户手动上传
    self.navigationItem.rightBarButtonItem = nil;
    
    int min = [_timeCount intValue]/60;
    int sec = [_timeCount intValue]%60;
    //时间文本
    _time_label.text = [NSString stringWithFormat:@"%02d:%02d",min,sec];
    //距离文本
    _distance_label.text = [NSString stringWithFormat:@"%.2f", [_distance floatValue]];
    
    //安装百度地图控件
    [self.view addSubview:self.mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view);
        make.bottom.equalTo(self->_topLabel.mas_top).offset(-30);
    }];
}

#pragma mark - [懒加载]
- (YCManager *)manager{
    if (!_manager) {
        _manager = [YCManager getInstance];
    }
    return _manager;
}
- (BMKMapView *)mapView{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] init];
        _mapView.delegate = self;
    }
    return _mapView;
}

#pragma mark - [事件]
//上传数据至服务器
- (void)uploadData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"巡防记录上传中...";
    

    [self.manager Guard_uploadPatrols_userId : (NSString *)[UserModel getInstance].userId intergral : (NSString *)[UserModel getInstance].intergral timeCount : (NSString *)_timeCount successHandle:^(id data) {

        [hud hideAnimated:YES];
        NSLog(@"%@", data);
        
        //成功
        if ([data[@"result"] isEqualToNumber:@0]) {
            [[UIAlertTool alloc] showAlertViewOn:self title:@"" message:data[@"message"] otherButtonTitle:@"确定" cancelButtonTitle:nil confirmHandle:^{
                
            } cancleHandle:^{
            }];
        }
        else{
            [UIAlertTool showHUDToViewTop:self.view message:data[@"message"]];
        }
        
        
    } failureHandle:^(id error) {
        [hud hideAnimated:YES];
        [UIAlertTool showHUDToViewCenter:self.view message:@"网络异常,请稍后重试"];
        NSLog(@"设置密码_失败: %@", error);
    }];
}
- (IBAction)goHome:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)uploadAction:(UIBarButtonItem *)sender {
    self.navigationItem.rightBarButtonItem = nil;
    [self uploadData];//数据上传到服务器
}

//开始绘制轨迹
- (void)start {
    CLLocationCoordinate2D paths[_sportNodes.count];
    for (NSInteger i = 0; i < _sportNodes.count; i++) {
        BMKSportNode *node = _sportNodes[i];
        paths[i] = node.coordinate;
    }
    
    pathPolyline = [BMKPolyline polylineWithCoordinates:paths count:
//                    2];
                    [_sportNodeNum intValue]];
    
    /// 返回区域外接矩形
    BMKMapRect rect = [pathPolyline boundingMapRect];
    rect.origin.x -= 100;//适当放大区域
    rect.origin.y -= 100;
    rect.size.width += 200;
    rect.size.height += 200;
    
    /// 返回区域中心坐标
    CLLocationCoordinate2D coordinate = [pathPolyline coordinate];
    [_mapView setVisibleMapRect:rect animated:YES];
    _mapView.centerCoordinate = coordinate;
    
    [_mapView addOverlay:pathPolyline];
    
    //放置一个起点大头针
    sportAnnotation1 = [[BMKPointAnnotation alloc]init];
    sportAnnotation1.coordinate = paths[0];
    sportAnnotation1.title = @"起点";
    [_mapView addAnnotation:sportAnnotation1];
    
    //放置一个终点大头针
    sportAnnotation2 = [[BMKPointAnnotation alloc]init];
    sportAnnotation2.coordinate = paths[1];
    sportAnnotation2.title = @"终点";
    [_mapView addAnnotation:sportAnnotation2];
    
    currentIndex = 0;
}
#pragma mark - [百度地图代理]
//地图完成初始化
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    [self start];
}


//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0.5 blue:0.0 alpha:0.6];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews{
    //绘制结束后，自动截屏上传服务器
    //    [self uploadData];
    [self performSelector:@selector(uploadData) withObject:nil afterDelay:1];
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
