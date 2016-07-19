//
//  PositionTestViewController.m
//  Demo.LocationTest
//
//  Created by Ninespring on 16/4/15.
//  Copyright © 2016年 Ninespring. All rights reserved.
//

#import "PositionTestViewController.h"
#import "LocationController.h"

@implementation PositionTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testCompiledLibrary];
    //    [self testOverWifiList];
}


- (void)testCompiledLibrary{
    
    NSString *bid = @"101001200002";
    
    LocationController *locationController = [[LocationController alloc] initWithDefaultBuildingID:bid];
    
    
    double *input_test = (double *)malloc(locationController.getEngine.col * sizeof(double));
    int i = 0;
    for (i = 0; i<locationController.getEngine.col; i++) {
        input_test[i] = 0.0;
    }
    
    double *res = [locationController locatePositionWithInputArray:input_test];
    NSLog(@"Result = %f, %f", res[0], res[1]);
    
    [locationController freeParams];
}




- (void) testOverWifiList{
    NSURL *wifilistFileUrl = [[NSBundle mainBundle] URLForResource:@"101001200002" withExtension:@"wifilist"];
    NSString *wifilistLine = [NSString stringWithContentsOfURL:wifilistFileUrl encoding:NSUTF8StringEncoding error:nil];
    NSArray *wifilist = [wifilistLine componentsSeparatedByString:@","];
    for (int i = 0; i < wifilist.count; i++) {
        NSLog(wifilist[i]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
