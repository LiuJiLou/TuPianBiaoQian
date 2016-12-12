//
//  PositioningViewController.m
//  XiaoHongShuBQ
//
//  Created by 刘吉楼 on 16/11/2.
//  Copyright © 2016年 刘吉楼. All rights reserved.
//

#import "PositioningViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface PositioningViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) UIButton * button;
@property (nonatomic, strong) UILabel * addLabel;

@end

@implementation PositioningViewController
//
//-(UIButton *)button
//{
//    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.button.frame = CGRectMake(0, 100, 100, 30);
//    [_button setTitle:@"定位" forState:(UIControlStateNormal)];
//    [_button addTarget:self action:@selector(_startLocation) forControlEvents:(UIControlEventTouchUpInside)];
//    _button.backgroundColor = [UIColor redColor];
//    _button.showsTouchWhenHighlighted = YES;
//    return _button;
//}

-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake((SCREEN_WIDTH-100)/2, 100, 100, 30);
    [_button setTitle:@"定位" forState:(UIControlStateNormal)];
    [_button addTarget:self action:@selector(_startLocation) forControlEvents:(UIControlEventTouchUpInside)];
    _button.backgroundColor = [UIColor redColor];
    _button.showsTouchWhenHighlighted = YES;

    [self.view addSubview:self.button];
    
    self.addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, SCREEN_WIDTH, 30)];
    _addLabel.textAlignment = 1;
    _addLabel.font = GetFont(BFONT_16);
    [self.view addSubview:_addLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)_startLocation
{
    if([CLLocationManager locationServicesEnabled])
    {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        _locationManager = [[CLLocationManager alloc] init];
        //设置定位的精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationManager.distanceFilter = 10.0f;
        _locationManager.delegate = self;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)
        {
            [_locationManager requestAlwaysAuthorization];
            [_locationManager requestWhenInUseAuthorization];
        }
        
        //开始实时定位
        [_locationManager startUpdatingLocation];
    }else {
        NSLog(@"请开启定位功能！");
    }
}

//代理,定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation * newLoaction = locations[0];
//    CLLocationCoordinate2D oCoordinate = newLoaction.coordinate;
//    NSLog(@"旧的经度：%f，旧的维度：%f",oCoordinate.longitude,oCoordinate.latitude);
    
    [self.locationManager stopUpdatingLocation];
//创建地理位置解码编码器对象
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLoaction completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        for (CLPlacemark * place in placemarks) {
//            NSDictionary * location = [place addressDictionary];
//            NSLog(@"国家：%@",[location objectForKey:@"Country"]);
//            NSLog(@"城市：%@",[location objectForKey:@"State"]);
//            NSLog(@"区：%@",[location objectForKey:@"SubLocality"]);
            
            NSLog(@"位置：%@",place.name);
            _addLabel.text = place.name;
//            NSLog(@"国家：%@",place.country);
//            NSLog(@"城市：%@",place.locality);
//            NSLog(@"区：%@",place.subLocality);
//            NSLog(@"街道：%@",place.thoroughfare);
//            NSLog(@"子街道：%@",place.subThoroughfare);
        }
    }];
}

//-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
//{
//    NSLog(@"Longitude = %f", manager.location.coordinate.longitude);
//    NSLog(@"Latitude = %f", manager.location.coordinate.latitude);
//    [_locationManager stopUpdatingLocation];
//    
//    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
//    [geoCoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
//        for (CLPlacemark * placemark in placemarks) {
//            NSDictionary *test = [placemark addressDictionary];
//            //  Country(国家)  State(城市)  SubLocality(区)
//            NSLog(@"%@", [test objectForKey:@"Country"]);
//            NSLog(@"%@", [test objectForKey:@"State"]);
//            NSLog(@"%@", [test objectForKey:@"SubLocality"]);
//            NSLog(@"%@", [test objectForKey:@"Street"]);
//        }
//        
//        NSLog(@"\n失败原因：%@",error);
//    }];
//}

// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
//    NSLog(@"Longitude = %f", newLocation.coordinate.longitude);
//    NSLog(@"Latitude = %f", newLocation.coordinate.latitude);
//    
//    // 获取当前所在的城市名
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    //根据经纬度反向地理编译出地址信息
//    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error)
//     {
//         if (array.count > 0)
//         {
//             CLPlacemark *placemark = [array objectAtIndex:0];
//             
//             //将获得的所有信息显示到label上
//             NSLog(@"位置：%@",placemark.name);
//             NSLog(@"国家：%@",placemark.country);
//             NSLog(@"城市：%@",placemark.locality);
//             NSLog(@"区：%@",placemark.subLocality);
//             NSLog(@"街道：%@",placemark.thoroughfare);
//             NSLog(@"子街道：%@",placemark.subThoroughfare);
//             //获取城市
//             NSString *city = placemark.locality;
//             if (!city) {
//                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
//                 city = placemark.administrativeArea;
//             }
//             NSLog(@"city = %@", city);
//             
//         }
//         else if (error == nil && [array count] == 0)
//         {
//             NSLog(@"No results were returned.");
//         }
//         else if (error != nil)
//         {
//             NSLog(@"An error occurred = %@", error);
//         }
//     }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}


// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
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
