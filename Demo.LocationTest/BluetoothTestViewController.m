//
//  BluetoothTestViewController.m
//  Demo.LocationTest
//
//  Created by Ninespring on 16/4/15.
//  Copyright © 2016年 Ninespring. All rights reserved.
//

#import "BluetoothTestViewController.h"

@implementation BluetoothTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.


    [self.beaconScan addTarget:self action:@selector(beaconScanButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.UUIDScan addTarget:self action:@selector(UUIDScanButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(backFromBluetoothTest:) forControlEvents:UIControlEventTouchUpInside];
}


- (IBAction)beaconScanButtonPressed:(id)sender{
    if (self.cbManager != nil) {
        NSLog(@"Stop Periphal Manager");
        [self stopPeriphalManager];
    }
    NSArray *uuid_list = [NSArray arrayWithObjects:@"EA01CD23-A1B2-C3D4-E5F6-C08B30FB15B0",@"F2C845E6-9AED-24F9-6C6E-887725D19116",@"E91143DE-ED63-903D-BCDB-1E672599A8E5",@"92A01577-A054-9ECC-57F5-7CABE6736241", nil];
    [self initBeaconScan:uuid_list];
}

- (IBAction)UUIDScanButtonPressed:(id)sender{
    if (self.clocationManager != nil) {
        NSLog(@"Stop Beacon Scan");
        [self stopBeaconScan];
    }
    [self initPeriphalScan];
}


- (IBAction)backFromBluetoothTest:(id)sender{
    [self stopBluetoothTest];
}


- (void) initPeriphalScan{
    self.cbManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void) centralManagerDidUpdateState:(CBCentralManager *)central{
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@">>>CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@">>>CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@">>>CBCentralManagerStateUnsupported");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@">>>CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@">>>CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@">>>CBCentralManagerStatePoweredOn");
            //开始扫描周围的外设
            /*
             第一个参数nil就是扫描周围所有的外设，扫描到外设后会进入
             - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
             */
            [self.cbManager scanForPeripheralsWithServices:nil options:nil];
            
            break;
        default:
            break;
    }
}

//扫描到设备会进入方法
- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    NSString *temp = [NSString stringWithFormat:@"Device Found:%@\nRSSI:%@\nUUID:%@\n", peripheral.name, RSSI, peripheral.identifier.UUIDString];
    //接下来可以连接设备
    for (NSString *key in advertisementData.allKeys) {
        temp = [temp stringByAppendingString:[NSString stringWithFormat:@"Key: %@, Value:%@\n", key, [advertisementData objectForKey:key]]];
    }
//    NSLog(temp);
    self.textView.text = temp;
    NSLog(@"Got Update Periphal Messgae");
}

- (void) stopPeriphalManager{
    [self.cbManager stopScan];
    self.cbManager = nil;
}







- (void) initBeaconScan:(NSArray *)uuid_list{
    self.clocationManager = [[CLLocationManager alloc] init];
    self.clocationManager.delegate = self;
    
    [self beaconScanAuthorizationDetection];
    
    NSString *uuid_string = uuid_list[0];
    NSLog(@"Start With UUID: %@", uuid_string);
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:uuid_string];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:uuid.UUIDString];
    [self.clocationManager startMonitoringForRegion:self.beaconRegion];
}

- (void) beaconScanAuthorizationDetection{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    NSLog(@"Location Service Status: %d", status);
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"Location Service Not Decided");
        [self.clocationManager requestWhenInUseAuthorization];
        NSLog(@"Location Service In Use");
    }else if(status == kCLAuthorizationStatusDenied){
        NSLog(@"Location Service Denied");
    }else if([CLLocationManager locationServicesEnabled] == NO){
        NSLog(@"Location Service Disabled");
    }else if(status == kCLAuthorizationStatusAuthorizedWhenInUse){
        NSLog(@"Location Service Authorized When In USE");
    }else if(status == kCLAuthorizationStatusAuthorizedAlways){
        NSLog(@"Location Service Authorized Always");
    }
    
    [self.clocationManager requestAlwaysAuthorization];
}

/*
 我们把locationManager初始化为CLLocationManager的新实例，然后把我们设置为它的委托，这样当更新时就会通知我们。
 
 我们通过同样的UUID设置了NSUUID对象，作为一个被app（先前创建的那个）广播的对象。
 
 最后我们把region传递给location manager 以便于监视。
 */
//

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{

    [self.clocationManager startRangingBeaconsInRegion:self.beaconRegion];
}


- (void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{

    [self.clocationManager stopRangingBeaconsInRegion:self.beaconRegion];

    
}


- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    [self.clocationManager startRangingBeaconsInRegion:self.beaconRegion];
}



- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region{
    
    NSLog(@"Found Beacon!");
    NSString *temp = @"Found Beacon!\n";
    for (CLBeacon *foundBeacon in beacons) {
//    
//        
//
//        NSLog(@"UUID:%@\n",foundBeacon.proximityUUID.UUIDString);
//        NSLog(@"RSSI:%ld\n",(long)foundBeacon.rssi);
//        NSLog(@"Major:%@",foundBeacon.major);
//        NSLog(@"Minor:%@",foundBeacon.minor);
        
        temp = [temp stringByAppendingString:[NSString stringWithFormat:@"UUID:%@\n",foundBeacon.proximityUUID.UUIDString]];
        temp = [temp stringByAppendingString:[NSString stringWithFormat:@"RSSI:%ld\t",(long)foundBeacon.rssi]];
        temp = [temp stringByAppendingString:[NSString stringWithFormat:@"Major:%@\t",foundBeacon.major]];
        temp = [temp stringByAppendingString:[NSString stringWithFormat:@"Minor:%@\n",foundBeacon.minor]];
    }
    self.textView.text = temp;
}


- (void) stopBeaconScan{
    [self.clocationManager stopMonitoringForRegion:self.beaconScan];
    [self.clocationManager stopRangingBeaconsInRegion:self.beaconScan];
    [self.clocationManager stopUpdatingLocation];
    self.clocationManager = nil;
}

/*
- (void) initBeaconScan:(NSArray *)uuid_list{
    self.clocationManager = [[CLLocationManager alloc] init];
    self.clocationManager.delegate = self;
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    NSLog(@"Location Service Status: %d", status);
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"Location Service Not Decided");
        [self.clocationManager requestWhenInUseAuthorization];
        NSLog(@"Location Service In Use");
    }else if(status == kCLAuthorizationStatusDenied){
        NSLog(@"Location Service Denied");
    }else if([CLLocationManager locationServicesEnabled] == NO){
        NSLog(@"Location Service Disabled");
    }else if(status == kCLAuthorizationStatusAuthorizedWhenInUse){
        NSLog(@"Location Service Authorized When In USE");
    }else if(status == kCLAuthorizationStatusAuthorizedAlways){
        NSLog(@"Location Service Authorized Always");
    }
    
    [self.clocationManager requestAlwaysAuthorization];
    
    self.regions = [NSMutableArray arrayWithCapacity:uuid_list.count];

    
    for (NSString *uuid in uuid_list) {
        NSLog(@"Start UUID Scan: %@", uuid);
        NSUUID *uuid_ns = [[NSUUID alloc] initWithUUIDString:uuid];
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid_ns identifier:uuid_ns.UUIDString];
        [self.regions addObject:region];
        [self.clocationManager startMonitoringForRegion:region];
    }
}


//

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    for (CLBeaconRegion *beaconRegion in self.regions) {
        [self.clocationManager startRangingBeaconsInRegion:beaconRegion];
    }
}


- (void) locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    for (CLBeaconRegion *beaconRegion in self.regions) {
        [self.clocationManager stopRangingBeaconsInRegion:beaconRegion];
    }

}


- (void) locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region{
    for (CLBeaconRegion *beaconRegion in self.regions) {
        [self.clocationManager startRangingBeaconsInRegion:beaconRegion];
    }
}



- (void) locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region{
    
    NSLog(@"Found Beacon!");
    
    NSLog(@"Found %lu Beacons", (unsigned long)beacons.count);
    
    CLBeacon *foundBeacon = [beacons firstObject];
//    NSLog(region.proximityUUID);
    NSLog(foundBeacon.proximityUUID.UUIDString);
    
//    NSLog(@"RSSI:%ld\n",(long)foundBeacon.rssi);
//    NSLog(@"Major:%@",foundBeacon.major);

}

*/


- (void) stopBluetoothTest{
    [self stopBeaconScan];
    [self stopPeriphalManager];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
