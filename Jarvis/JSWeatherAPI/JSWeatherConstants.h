//
//  JSWeatherConstants.h
//  JSWeatherAPI
//
//  Created by John Setting on 12/4/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//
//  Modified by Gabriel Ulici on 10/4/15.
//  Copyright (c) 2015 Night Ideas Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kJSWeatherURL;
extern NSString * const kJSWeatherAPIURL;
extern NSString * const kJSWeatherAPIAPPIDURL;
extern NSString * const kJSWeatherAPIAPPID;
extern NSString * const kJSWeatherAPITypeData;
extern NSString * const kJSWeatherAPITypeImage;
extern NSString * const kJSWeatherAPITypeHistory;
extern NSString * const kJSWeatherAPIVersion;
extern NSString * const kJSWeatherAPIQueryWeather;
extern NSString * const kJSWeatherAPIQueryCoordinates;
extern NSString * const kJSWeatherAPIQueryLatitude;
extern NSString * const kJSWeatherAPIQueryLongitude;
extern NSString * const kJSWeatherAPIQueryDailyForecast;
extern NSString * const kJSWeatherAPIQueryDailyForecastCoord;
extern NSString * const kJSWeatherAPIQueryDailyForecastCount;
extern NSString * const kJSWeatherAPIQueryHourlyForecast;
extern NSString * const kJSWeatherAPIQueryHistoricalData;

typedef void (^JSWeatherBlock)(NSArray *objects, NSError *error);