//
//  JSDailyForecastObject.h
//  JSWeatherAPI
//
//  Created by John Setting on 12/4/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

@interface JSDailyForecastObject : NSObject
- (id)initWithData:(NSDictionary *)dict;
- (id)initWithData:(NSDictionary *)dict temperatureConversion:(NSInteger)conversion;

@property (nonatomic) NSDictionary *objects;
//@property (nonatomic, copy) UIImage *JSWeatherImage;
@property (nonatomic, copy) NSImage *JSWeatherImage;
@property (nonatomic) NSString *JSWindDirection;
@property (nonatomic) float JSWindDirectionFloat;
@property (nonatomic) NSDate *JSForecastDate;
@property (nonatomic) float JSCloudiness;
@property (nonatomic) int JSHumidity;
@property (nonatomic) float JSPressure;
@property (nonatomic) float JSRain;
@property (nonatomic) float JSWindSpeed;
@property (nonatomic) float JSDayForecastDayTemperature;
@property (nonatomic) float JSDayForecastEveningTemperature;
@property (nonatomic) float JSDayForecastMaxTemperature;
@property (nonatomic) float JSDayForecastMinTemperature;
@property (nonatomic) float JSDayForecastMorningTemperature;
@property (nonatomic) float JSDayForecastNightTemperature;
@property (nonatomic) NSString *JSWeatherDescription;
@end
