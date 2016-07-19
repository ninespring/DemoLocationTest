//
//  LocationController.m
//  Demo.LocationTest
//
//  Created by Ninespring on 16/7/19.
//  Copyright © 2016年 Ninespring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocationController.h"



@implementation LocationController


- (instancetype)initWithContentOfModelFiles:(NSString *)WPFilePath OptParamFile:(NSString *)OPTFilePath IDFilePath:(NSString *)IDFilePath{
    if (self = [super init]) {
        NSLog(WPFilePath);
        NSLog(OPTFilePath);
        self->wp = loadToStruct([WPFilePath cStringUsingEncoding:NSUTF8StringEncoding]);
        self->opt = loadToStruct([OPTFilePath cStringUsingEncoding:NSUTF8StringEncoding]);
        self->identifierList = [self loadIdentifierListWithFilePath:IDFilePath];
        self->engine = generateEngine(self->wp, self->opt);
        self->initialized = TRUE;
    }
    return self;
}

- (instancetype)initWithDefaultBuildingID:(NSString *)buildingIdentifier{
    if (self = [super init]) {
        NSURL *wpFileUrl = [[NSBundle mainBundle] URLForResource:buildingIdentifier withExtension:@"wp"];
        NSURL *optFileUrl = [[NSBundle mainBundle] URLForResource:buildingIdentifier withExtension:@"optparam"];
        NSURL *idListFileUrl = [[NSBundle mainBundle] URLForResource:buildingIdentifier withExtension:@"wifilist"];
        
        self->wp = loadToStruct(wpFileUrl.fileSystemRepresentation);
        self->opt = loadToStruct(optFileUrl.fileSystemRepresentation);
        self->engine = generateEngine(self->wp, self->opt);
        self->initialized = TRUE;
        self->identifierList = [self loadIdentifierListWithURL:idListFileUrl];
    }
    return self;
}

- (NSArray *)loadIdentifierListWithURL:(NSURL *)idListFilePath{
    NSString *wifilistLine = [NSString stringWithContentsOfURL:idListFilePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *wifilist = [wifilistLine componentsSeparatedByString:@","];
    for (int i = 0; i < wifilist.count; i++) {
        NSLog(wifilist[i]);
    }
    return wifilist;
}

- (NSArray *)loadIdentifierListWithFilePath:(NSString *)idListFilePath{
    NSString *wifilistLine = [NSString stringWithContentsOfFile:idListFilePath encoding:NSUTF8StringEncoding error:nil];
    NSArray *wifilist = [wifilistLine componentsSeparatedByString:@","];
    
    for (int i = 0; i < wifilist.count; i++) {
        NSLog(wifilist[i]);
    }
    return wifilist;
}


- (struct Matrix)getWayPoint{
    return self->wp;
}

- (struct Matrix)getEngine{
    return self->engine;
}



- (double *) locatePositionWithInputArray:(double *)inputArray{
    if (self->initialized) {
        int index = locatePosIndex(self->engine, self->opt, inputArray);
        //        double *res = (double *) malloc(sizeof(double) * 2);
        return self->wp.matrix[index];
    }
    return nil;
}

- (void) freeParams{
    if (self->initialized) {
        freeMatrix(wp);
        freeMatrix(opt);
        freeMatrix(engine);
    }
}


@end
