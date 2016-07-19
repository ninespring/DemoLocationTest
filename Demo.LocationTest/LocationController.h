//
//  LocationController.h
//  Demo.LocationTest
//
//  Created by Ninespring on 16/7/19.
//  Copyright © 2016年 Ninespring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "locate_code_base.h"

@interface LocationController : NSObject {
    struct Matrix wp;
    struct Matrix opt;
    struct Matrix engine;
    NSArray *identifierList;
    BOOL initialized;
}

- (instancetype)initWithContentOfModelFiles:(NSString *)WPFilePath OptParamFile:(NSString *)OPTFilePath IDFilePath:(NSString *)IDFilePath;
- (instancetype)initWithDefaultBuildingID:(NSString *)buildingIdentifier;

- (double *) locatePositionWithInputArray:(double *)inputArray;

- (struct Matrix)getWayPoint;
- (struct Matrix)getEngine;

- (void) freeParams;

@end
