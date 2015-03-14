//
//  JSCurrentLocation.h
//  JSWeatherAPI
//
//  Created by John Setting on 12/4/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol JSCurrentLocationDelegate;

@interface JSCurrentLocation : NSObject
@property (nonatomic, weak)id<JSCurrentLocationDelegate>delegate;
+ (id)sharedInstance;
- (void)getCurrentLocation;
@end

@protocol JSCurrentLocationDelegate <NSObject>
- (void)JSCurrentLocation:(JSCurrentLocation *)object didFailToReceiveLocation:(NSError *)error;
- (void)JSCurrentLocation:(JSCurrentLocation *)object didReceiveLocation:(NSDictionary *)location;
@end
