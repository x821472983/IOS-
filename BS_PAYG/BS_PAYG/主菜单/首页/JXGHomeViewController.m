//
//  JXGHomeViewController.m
//  pro_jiaxing
//
//  Created by 梁志华 on 2019/3/4.
//  Copyright © 2019 梁志华. All rights reserved.
//

#import "JXGHomeViewController.h"
//视图
#import "SDCycleScrollView.h"//轮播图插件
#import "MenuButtonCell.h"//主菜单按钮插件

//宏定义
#define MARGIN 5//边距
#define NUM_IN_ROW 4//每行个数
#define ITEM_WIDTH ([UIScreen mainScreen].bounds.size.width-MARGIN*(NUM_IN_ROW+1))/NUM_IN_ROW
#define ITEM_HEIGHT ITEM_WIDTH

@interface JXGHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SDCycleScrollViewDelegate>


//菜单数据
@property (nonatomic, strong)NSArray *modelArray;

//轮播视图
@property (nonatomic, strong)SDCycleScrollView *cycleScrollView;

//二维码视图
@property (nonatomic, strong)UIImageView *barcodeImageView;

//本地图片
@property (strong,nonatomic)NSArray *localImages;


@end

@implementation JXGHomeViewController

#pragma mark - [懒加载]

//懒加载本地图片数据
-(NSArray *)localImages{
    
    if (!_localImages) {
        _localImages = @[@"0",@"1",@"2",@"3",@"4",@"5"];
    }
    return _localImages;
}

//轮播网络图片
- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        //添加本地层图片，设置显示框位置和大小
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, SCREEN_WIDTH, SCREEN_WIDTH*2/3) shouldInfiniteLoop:YES imageNamesGroup:self.localImages];
        //背景颜色
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        //背景图片
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"payg_whitebg"];
        //显示层
        _cycleScrollView.delegate = self;
        //控制格式
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        //自动无限循环播放
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        //五秒自动换一次
        _cycleScrollView.autoScrollTimeInterval = 5;
    }
    return _cycleScrollView;
}

#pragma mark - [界面初始化]
- (void)viewDidLoad {
    _modelArray = @[
                    @"巡防签到",
                    @"巡防预约",
                    @"治安举报",
                    @"社情街拍",
                    @"风采展示",
                    @"巡防统计",
                    //                    @"积分兑换",
                    @"个人中心",
                    @"工具",
                    @"二维码",
                    @"操作手册"
                    ];

    //使用MenuButtonCell插件的图标样式作为每个cell的样式
    [_collectionView registerNib:[UINib nibWithNibName:@"MenuButtonCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    //???
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    //播放轮播图
    [self.view addSubview:self.cycleScrollView];
    [super viewDidLoad];
}

#pragma mark - [采集视图相关]
//显示几个section——（一个）
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//获取cell的总数量count
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _modelArray.count;
}

//每个cell的初始化
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    MenuButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.imageView.image = [UIImage imageNamed:_modelArray[indexPath.row]];
    cell.imageView.layer.cornerRadius = 5;
    cell.imageView.layer.masksToBounds = YES;

    cell.titleLabel.text = _modelArray[indexPath.row];

    return cell;
}

//定义cell的框度和高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ITEM_WIDTH, ITEM_HEIGHT);
}

//行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//每个cell之间的边距为5
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return MARGIN;
}

//调整内容的边距(cell的左右上下缩进)
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, MARGIN, 0, MARGIN);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    //如果存在头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*3/5);
        
        //创建轮播图
        //[header addSubview:self.cycleScrollView];
        
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*3/5);
}

//点击cell后执行的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    NSLog(@"%@", _modelArray[indexPath.row]);
    //performSegueWithIdentifier，页面跳转,通过指定的ID链接
    if ([_modelArray[indexPath.row] isEqualToString:@"巡防预约"]) {
        [self performSegueWithIdentifier:@"xfyy" sender:nil];
    }
    else if ([_modelArray[indexPath.row] isEqualToString:@"巡防统计"]) {
        [self performSegueWithIdentifier:@"xftj" sender:nil];
    }
    else if ([_modelArray[indexPath.row] isEqualToString:@"治安举报"]) {
        [self performSegueWithIdentifier:@"xsjb" sender:nil];
    }
    else if ([_modelArray[indexPath.row] isEqualToString:@"社情街拍"]) {
        [self performSegueWithIdentifier:@"wtsb" sender:nil];
    }
    else if ([_modelArray[indexPath.row] isEqualToString:@"巡防签到"]) {
        [self performSegueWithIdentifier:@"xfqd" sender:nil];
    }
    else if ([_modelArray[indexPath.row] isEqualToString:@"风采展示"]) {
        [self performSegueWithIdentifier:@"fczs" sender:nil];
    }
    else if ([_modelArray[indexPath.row] isEqualToString:@"工具"]) {
        [self performSegueWithIdentifier:@"gj" sender:nil];
    }
    else if ([_modelArray[indexPath.row] isEqualToString:@"个人中心"]) {
        [self performSegueWithIdentifier:@"self" sender:nil];
    }
    else if ([_modelArray[indexPath.row] isEqualToString:@"积分兑换"]) {
        [self performSegueWithIdentifier:@"jfdh" sender:nil];
    }
    else if ([_modelArray[indexPath.row] isEqualToString:@"二维码"]) {
        [self performSegueWithIdentifier:@"ewm" sender:nil];
    }
    else if ([_modelArray[indexPath.row] isEqualToString:@"操作手册"]) {
        [self performSegueWithIdentifier:@"czsc" sender:nil];
    }
    else{
        [UIAlertTool showHUDToViewCenter:self.view message:@"功能开发中，敬请期待"];
    }
}

#pragma mark - [杂乱]
//释放controller的resouse，不释放view
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"xfqd"] || [segue.identifier isEqualToString:@"gj"] || [segue.identifier isEqualToString:@"self"]) {
        UIViewController *viewController = segue.destinationViewController;
        viewController.hidesBottomBarWhenPushed = YES;
    }
}

@end
