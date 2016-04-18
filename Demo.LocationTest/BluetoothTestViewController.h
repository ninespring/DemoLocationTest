//
//  BluetoothTestViewController.h
//  Demo.LocationTest
//
//  Created by Ninespring on 16/4/15.
//  Copyright © 2016年 Ninespring. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
@import CoreBluetooth;

@interface BluetoothTestViewController : UIViewController<CBCentralManagerDelegate>
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *beaconScan;
@property (strong, nonatomic) IBOutlet UIButton *UUIDScan;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (strong, nonatomic) CBCentralManager *cbManager;
@property (strong, nonatomic) CLLocationManager *clocationManager;
@property (strong, nonatomic) NSMutableArray *regions;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@end
