//
//  JSWeatherObject.h
//  JSWeatherAPI
//
//  Created by John Setting on 12/4/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

@interface JSCurrentWeatherObject : NSObject
- (id)initWithData:(NSDictionary *)dict;
- (id)initWithData:(NSDictionary *)dict temperatureConversion:(NSInteger)conversion;

@property (nonatomic) NSDictionary *objects;
//@property (nonatomic, copy) UIImage *JSWeatherImage;
@property (nonatomic) NSString *JSWeatherImage;
@property (nonatomic) NSString *JSLocationName;
@property (nonatomic) float JSCloudiness;
@property (nonatomic) int JSHumidity;
@property (nonatomic) int JSPressure;
@property (nonatomic) float JSCurrentTemperature;
@property (nonatomic) float JSTemporaryMaxTemperature;
@property (nonatomic) float JSTemporaryMinTemperature;
@property (nonatomic) NSString *JSWeatherDescription;
@property (nonatomic) NSString *JSWindDirection;
@property (nonatomic) float JSWindDirectionFloat;
@property (nonatomic) float JSWindSpeed;
@property (nonatomic) NSDate *JSSunriseDate;
@property (nonatomic) NSDate *JSSunsetDate;
@property (nonatomic) float JSLocationLongitude;
@property (nonatomic) float JSLocationLatitude;
@end
