//
//  ViewController.m
//  BaiduMap
//
//  Created by Edward on 16/9/28.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "ViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<BMKMapViewDelegate>
/**
 *  存储annotation的数组
 */
@property (nonatomic) NSMutableArray<BMKPointAnnotation *> *annotationsArr;
/**
 *  测试按钮
 */
@property (nonatomic) UIButton *testButton;

@end

@implementation ViewController{
    BMKMapView * _mapView;
    CLLocationCoordinate2D annotationCoor[4];
    
    //记录当前的polygon
    BMKPolygon *currentPolygon;
    //记录上次的polygon
    BMKPolygon *lastPolygon;
}

#pragma mark - BMKMapView Delegate
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    [self getAnnotations:coordinate];
}

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0 blue:0.5 alpha:1];
        polygonView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:0.2];
        polygonView.lineWidth =2.0;
        return polygonView;
    }
    return nil;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
    newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示
    newAnnotationView.draggable = YES;
    newAnnotationView.selected = YES;
    return newAnnotationView;
}

//拖动实时获取坐标，并且实时更新
- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState
   fromOldState:(BMKAnnotationViewDragState)oldState{
    if ([view.reuseIdentifier isEqualToString:@"myAnnotation"]) {
        CLLocationCoordinate2D coor;
        coor.longitude = view.annotation.coordinate.longitude;
        coor.latitude = view.annotation.coordinate.latitude;
        [view.annotation setCoordinate:coor];
        lastPolygon = currentPolygon;
        [self createOverlay];
    }
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    [self.view addSubview:_mapView];
    [self annotationsArr];
    [self testButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 方法 methods
/**
 *  生成标注
 *
 *  @param coordinate 传入点击所在的coordinate，生成标注
 */
- (void)getAnnotations:(CLLocationCoordinate2D)coordinate{
        if (self.annotationsArr.count < 4) {
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
            annotation.title = [NSString stringWithFormat:@"%f %f",coordinate.latitude, coordinate.longitude];
            annotation.coordinate = coordinate;
            [self.annotationsArr addObject:annotation];
            [_mapView addAnnotation:annotation];
        }else{
            NSLog(@"只允许画4个点");
        }
}

/**
 *  创建4个点所形成的view
 */
- (void)createOverlay{
    BMKPolygon * polygon;
    for (int i = 0; i < self.annotationsArr.count; i ++ ) {
        annotationCoor[i].longitude = self.annotationsArr[i].coordinate.longitude ;
        annotationCoor[i].latitude = self.annotationsArr[i].coordinate.latitude ;
    }
    if (polygon == nil) {
        polygon = [BMKPolygon polygonWithCoordinates:annotationCoor count:self.annotationsArr.count];
        currentPolygon = polygon;
    }
    [_mapView removeOverlay:lastPolygon];
    [_mapView addOverlay:currentPolygon];
}

#pragma mark - lazy load

- (NSMutableArray<BMKPointAnnotation *> *)annotationsArr {
	if(_annotationsArr == nil) {
		_annotationsArr = [[NSMutableArray<BMKPointAnnotation *> alloc] init];
	}
	return _annotationsArr;
}

- (UIButton *)testButton {
	if(_testButton == nil) {
		_testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(10, 30, 100, 50);
        _testButton.frame = frame;
        [self.view addSubview:_testButton];
        [_testButton setTitle:@"添加overlay" forState:UIControlStateNormal];
        [_testButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_testButton setBackgroundColor:[UIColor purpleColor]];
        [_testButton addTarget:self action:@selector(createOverlay) forControlEvents:UIControlEventTouchUpInside];
	}
	return _testButton;
}

@end
