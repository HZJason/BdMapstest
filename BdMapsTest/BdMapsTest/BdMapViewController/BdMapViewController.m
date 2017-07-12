//
//  BdMapViewController.m
//  BdMapsTest
//
//  Created by 黄泽 on 2017/7/12.
//  Copyright © 2017年 黄泽. All rights reserved.
//

#import "BdMapViewController.h"
#import "MyModel.h"
#import "MyAnnotation.h"
#import "CustomPinAnnotationView.h"
#import "TwoViewController.h"

@interface BdMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property(nonatomic,strong) BMKMapView *mapView;//地图对象
@property(nonatomic,strong) BMKLocationService *locationService; //定位
@property(nonatomic,strong) BMKUserLocation *userLocation;//用户的位置
@property (nonatomic, strong) NSMutableArray * annotationArray;//标注数组
@property (nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch; //反编码

@property(nonatomic,strong)MyAnnotation *MyAnnotation;//自定义大头针
@end

@implementation BdMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载地图
    [self.view addSubview:self.mapView];
    //开始定位
    [self.locationService startUserLocationService];
}


#pragma mark 百度地图定位
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLoP(@"heading is %@",userLocation.heading);
    
    
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{

    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    userLocation.title = nil;
    self.userLocation = userLocation;
    
    /*******************************设置定位中心************************************************/
    [_mapView updateLocationData:userLocation];
    
    [_mapView setCenterCoordinate:userLocation.location.coordinate];
    
    [_locationService stopUserLocationService];
    
    /*******************************设置我的位置************************************************/
    
    BMKPointAnnotation* userAnnotation = [[BMKPointAnnotation alloc]init];
    
    userAnnotation.coordinate = userLocation.location.coordinate;
    
    [_mapView addAnnotation:userAnnotation];
    
    /*******************************geo检索信息类,获取当前城市数据***********************************/
    BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeOption.reverseGeoPoint = userLocation.location.coordinate;
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
}

#pragma mark 数据显示
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        BMKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"userLocation"];
        
        if(annotationView == nil){
            
            annotationView = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"UserLocation"];


        }
        
        annotationView.image = [UIImage imageNamed:@"LOGO.png"];
        return annotationView;
    }
    
    CustomPinAnnotationView *annotationView = (CustomPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"otherAnnotationView"];
    if (annotationView == nil) {
        annotationView = [[CustomPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"otherAnnotationView"];
    }
    
    MyAnnotation *myAnnotation = (id)annotation;
    
    
    switch ([myAnnotation.model.isvalid intValue]) {
        case 0://断线
            
            annotationView.image = [UIImage imageNamed:@"gps_me"];
            
            break;
        case 1:
            
            //判断是否有车位
            
            if([myAnnotation.model.remainder intValue] <= 0){
                
                annotationView.image = [UIImage imageNamed:@"gps_close"];
                
            }else{
                annotationView.image = [UIImage imageNamed:@"gps_open"];
                
            }
            break;
        default:
            break;
    }
    
    NSLog(@"车位:%@" ,myAnnotation.model.remainder);
    
    annotationView.canShowCallout = NO;
    return annotationView;
}

#pragma mark 区域滑动
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    //装换坐标
    CLLocationCoordinate2D carLocation = [_mapView convertPoint:self.view.center toCoordinateFromView:self.view];
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = CLLocationCoordinate2DMake(carLocation.latitude, carLocation.longitude);
    NSLog(@"%f - %f", option.reverseGeoPoint.latitude, option.reverseGeoPoint.longitude);
    //调用发地址编码方法，让其在代理方法onGetReverseGeoCodeResult中输出
    
    
    [self.annotationArray removeAllObjects];
    
//    //删除指定的标注
        NSArray* array = [NSArray arrayWithArray:mapView.annotations];
        for (int i = 0; i < [array count]; i ++) {
            if ([array[i] isKindOfClass:[MyAnnotation class]]) {
                [mapView removeAnnotation:array[i]];
            }
        }
    
    
       [_mapView removeAnnotation: _MyAnnotation];
    
     [self getData:option.reverseGeoPoint];
    
    
}

#pragma mark --private Method--当点击大头针时
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    if ([ view isKindOfClass:[CustomPinAnnotationView class ]])
    {
        _MyAnnotation = (id)view.annotation;
        
        TwoViewController *detailCtr = [[TwoViewController alloc]init];
        detailCtr.parkingId = _MyAnnotation.model.ID;
        
        [self presentViewController:detailCtr animated:YES completion:nil];
    }
    
    
}

#pragma mark 根据坐标返回反地理编码搜索结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    
    BMKAddressComponent *addressComponent = result.addressDetail;
    
    NSLog(@"%@",addressComponent.city);

}

#pragma mark 获取停车场数据
- (void)getData:(CLLocationCoordinate2D)coordinate
{
    
    NSString *latitude = [NSString stringWithFormat:@"%lf",coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%lf",coordinate.longitude];
    //封装传参
    NSDictionary * locationDic = @{@"latitude":latitude,@"longitude":longitude};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:locationDic options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *str1 = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *paras = @{@"parkXY":str1};
    
    [HZReuqest requestWithURL:@"/parkinfo/selectXY.do" parameters:paras success:^(id response) {
        
        NSDictionary *dict = response;
        NSArray *dictArray = dict[@"data"];
        
        if(dictArray.count == 0)return ;
        
        
        for ( NSDictionary *Detaildict in dictArray) {
            
            MyModel *model = [[MyModel alloc]init];
            
            [model setValuesForKeysWithDictionary:Detaildict];
            
            //添加其他大头针
            MyAnnotation* annotation = [[MyAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor = CLLocationCoordinate2DMake([model.latitude doubleValue], [model.longitude doubleValue]);
            
            // annotation.title = model.name;
            annotation.coordinate = coor;
            annotation.model = model;
            
            [self.annotationArray addObject:annotation];
            [_mapView addAnnotations:self.annotationArray];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark 懒加载
//地图
- (BMKMapView *)mapView
{
    if(!_mapView){
        
        _mapView = [[BMKMapView alloc]initWithFrame:[UIScreen mainScreen].bounds];
       _mapView.backgroundColor = [UIColor whiteColor];
        _mapView.mapType = BMKMapTypeStandard ;//标准地图
        _mapView.userTrackingMode = BMKUserTrackingModeFollow ;//定位跟随模式
        _mapView.zoomLevel = 14;
        _mapView.minZoomLevel = 10;
        _mapView.delegate = self;
        _mapView.showsUserLocation = NO;
        _mapView.overlookEnabled = YES; //设定地图View能否支持俯仰角
        _mapView.buildingsEnabled = YES;//设定地图是否现显示3D楼块效果
        
        
//        /***动态定制我的位置样式        */
//        
//        BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc] init];
//        
//        displayParam.locationViewOffsetX=0;//定位偏移量(经度)
//        
//        displayParam.locationViewOffsetY=0;//定位偏移量（纬度）
//        
//        displayParam.isAccuracyCircleShow=NO;//经度圈是否显示
//        
//        //这里替换自己的图标路径，必须把图片放到百度地图SDK的Resources/mapapi.bundle/images 下面
//        
//        //还有一种方法就是获取到_locationView之后直接设置图片
//        
//        displayParam.locationViewImgName=@"hzb_dtdw_dw";
//        
//        [_mapView updateLocationViewWithParam:displayParam];
//        
        
        
    }
    return _mapView;
}
//定位
- (BMKLocationService *)locationService
{
    if(!_locationService){
        
        _locationService=[[BMKLocationService alloc] init];
        _locationService.desiredAccuracy=kCLLocationAccuracyBest;
        _locationService.delegate=self;
        _locationService.distanceFilter = 200;//设定定位的最小更新距离，这里设置 200m 定位一次，频繁定位
        _locationService.desiredAccuracy = kCLLocationAccuracyBest;//设定定位精度
        
    }
    return _locationService;
}

//标注数组
- (NSMutableArray *)annotationArray {
    if (!_annotationArray) {
        _annotationArray = [NSMutableArray array];
    }
    return _annotationArray;
}


#pragma mark   即将进入和即将退出
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    _mapView.delegate = self;
    _locationService.delegate = self;
    //    _geoCodeSearch.delegate = self;
    
    [_mapView viewWillAppear];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate=nil;
    _locationService.delegate = nil;
    //    _geoCodeSearch.delegate = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
