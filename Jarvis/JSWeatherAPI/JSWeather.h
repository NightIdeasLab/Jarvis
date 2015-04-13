//
//  JSWeather.h
//  JSWeatherAPI
//
//  Created by John Setting on 12/4/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//
//  Modified by Gabriel Ulici on 10/4/15.
//  Copyright (c) 2015 Night Ideas Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSCurrentLocation.h"
#import "JSCurrentWeatherObject.h"
#import "JSDailyForecastObject.h"
#import "JSHourlyForecastObject.h"
#import "JSWeatherConstants.h"
#import "JSHistoricalDataObject.h"

enum {
    kJSKelvin = 0,
    kJSCelsius = 1,
    kJSFahrenheit
}; NSInteger kJSTemperatureMetrics;

@protocol JSWeatherDelegate;

@interface JSWeather : NSObject

/*!
 @abstract The legitimate way to instantiate the object
 */
+ (id) sharedInstance;

/*!
 @abstract Only become the delegate of this class if you want to receive the users current location
 */
@property (nonatomic, weak) id <JSWeatherDelegate>delegate;

/*!
 @abstract The Temperature metric 
 
 @discussion If the temperature metric is not set, it will default to Kelvins
 */
@property (nonatomic) NSInteger temperatureMetric;

/*!
 @abstract Handles getting the users current location.
 
 @discussion It is required that you ensure your info.plist has the following fields 
 'NSLocationWhenInUseUsageDescription', 'privacy - location usage description', and/or 
 'NSLocationAlwaysUsageDescription' filled with a user friendly message.
 
 Conform as the delegate of this class to further query for weather data
 */
- (void)getCurrentLocation;

/*!
 @abstract Queries the OpenWeatherMap API for the locations current weather.
 
 @discussion The current weather of the location passed will be returned within the block. The state parameter is very flexible.
 
 @param city The city that the client is wanting to receive weather for (e.g 'San Francisco')
 @param state The state/country/region that the client is wanting to receive weather for 
 (e.g 'CA' for Canada, 'CA' for California, or 'GB' for Great Britain)
 */
- (void)queryForCurrentWeatherWithCity:(NSString *)city state:(NSString *)state
                                 block:(void (^)(JSCurrentWeatherObject *object, NSError *error))completionBlock;

/*!
 @abstract Queries the OpenWeatherMap API for the locations daily forecast weather.
 
 @discussion The daily forecast weather of the location passed will be returned within the block. The state parameter is very flexible.
 
 @param numberOfDays Specify the number of days you would like to receive forecasts for. You may only specify a number between 1 and 16. (e.g 9 will get you the next 8 days' forecasts for those days including the current day
 @param city The city that the client is wanting to receive weather for (e.g 'San Francisco')
 @param state The state/country/region that the client is wanting to receive weather for
 (e.g 'CA' for Canada, 'CA' for California, or 'GB' for Great Britain)
 */
- (void)queryForDailyForecastWithNumberOfDays:(NSInteger)numberOfDays city:(NSString *)city state:(NSString *)state
                                        block:(JSWeatherBlock)block;

/*!
 @abstract Queries the OpenWeatherMap API for the locations hourly forecast weather.
 
 @discussion The hourly forecast weather of the location passed will be returned within the block. The state parameter is very flexible.
 
 @param city The city that the client is wanting to receive weather for (e.g 'San Francisco')
 @param state The state/country/region that the client is wanting to receive weather for
 (e.g 'CA' for Canada, 'CA' for California, or 'GB' for Great Britain)
 */
- (void)queryForHourlyForecastWithCity:(NSString *)city state:(NSString *)state
                                 block:(JSWeatherBlock)block;

/*!
 @abstract Queries the OpenWeatherMap API for the locations historical data weather.
 
 @discussion The historical weather of the location passed will be returned within the block. The state parameter is very flexible.
 
 @param city The city that the client is wanting to receive weather for (e.g 'San Francisco')
 @param state The state/country/region that the client is wanting to receive weather for
 (e.g 'CA' for Canada, 'CA' for California, or 'GB' for Great Britain)
 */
- (void)queryForHistoricalDataWithCity:(NSString *)city state:(NSString *)state
                                 block:(JSWeatherBlock)block;
@end

@protocol JSWeatherDelegate <NSObject>
@optional

- (void)JSWeather:(JSWeather *)weather didReceiveCurrentLocation:(NSDictionary *)dict;
- (void)JSWeather:(JSWeather *)weather didReceiveCurrentLocationError:(NSError *)error;

@end