//
//  JSHourlyForecastObject.h
//  JSWeatherAPI
//
//  Created by John Setting on 12/4/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

@interface JSHourlyForecastObject : NSObject
- (id)initWithData:(NSDictionary *)dict;
- (id)initWithData:(NSDictionary *)dict temperatureConversion:(NSInteger)conversion;

@property (nonatomic) NSDictionary *objects;
//@property (nonatomic) UIImage *JSWeatherImage;
@property (nonatomic) NSImage *JSWeatherImage;
@property (nonatomic) NSDate *JSWeatherDate;
@property (nonatomic) float JSCloudiness;
@property (nonatomic) float JSGroundLevel;
@property (nonatomic) int JSHumidity;
@property (nonatomic) float JSPressure;
@property (nonatomic) float JSSealevel;
@property (nonatomic) float JSCurrentTemperature;
@property (nonatomic) float JSPossibleMaxTemperature;
@property (nonatomic) float JSPossibleMinTemperature;
@property (nonatomic) float JSRain;
@property (nonatomic) NSString *JSWeatherDescription;
@property (nonatomic) NSString *JSWindDirection;
@property (nonatomic) float JSWindDirectionFloat;
@property (nonatomic) float JSWindSpeed;
@end
