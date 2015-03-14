//
//  JSHistoricalDataObject.h
//  Example
//
//  Created by John Setting on 12/5/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKit.h>

@interface JSHistoricalDataObject : NSObject
- (id)initWithData:(NSDictionary *)dict;
- (id)initWithData:(NSDictionary *)dict temperatureConversion:(NSInteger)conversion;

@property (nonatomic) NSDictionary *objects;
@property (nonatomic) float JSCloudiness;
@property (nonatomic) NSDate *JSWeatherDate;
@property (nonatomic) int JSHumidity;
@property (nonatomic) float JSPressure;
@property (nonatomic) float JSCurrentTemperature;
@property (nonatomic) float JSPossibleMaxTemperature;
@property (nonatomic) float JSPossibleMinTemperature;
@property (nonatomic) NSString *JSWeatherDescription;
//@property (nonatomic) UIImage *JSWeatherImage;
@property (nonatomic) NSImage *JSWeatherImage;
@property (nonatomic) NSString *JSCurrentWindDirection;
@property (nonatomic) NSString *JSCurrentWindDirectionBeginning;
@property (nonatomic) NSString *JSCurrentWindDirectionEnding;
@property (nonatomic) float JSCurrentWindDirectionFloat;
@property (nonatomic) float JSCurrentWindDirectionBeginningFloat;
@property (nonatomic) float JSCurrentWindDirectionEndingFloat;
@property (nonatomic) float JSWindSpeed;
@end
