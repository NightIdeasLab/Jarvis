//
//  JSWeather.m
//  JSWeatherAPI
//
//  Created by John Setting on 12/4/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//
//  Modified by Gabriel Ulici on 10/4/15.
//  Copyright (c) 2015 Night Ideas Lab. All rights reserved.
//

#import "JSWeather.h"
#import "JSWeatherConstants.h"
#import "JSWeather.h"
#import "JSWeatherUtility.h"

#define WEATHER_REFRESH_TIME 900 //(60 * 60 * 24 * 7)

@interface JSWeather() <JSCurrentLocationDelegate>
@property (nonatomic, strong) JSCurrentLocation *JSLocation;
@end

@implementation JSWeather

+(id)sharedInstance {
    static dispatch_once_t once;
    static JSWeather *instance;
    dispatch_once(&once, ^{ instance = [[JSWeather alloc] init]; });
    return instance;
}

- (void)getCurrentLocation {
    self.JSLocation = [JSCurrentLocation sharedInstance];
    [self.JSLocation setDelegate:self];
    [self.JSLocation getCurrentLocation];
}

- (void)queryForCurrentWeatherWithCity:(NSString *)city state:(NSString *)state block:(void (^)(JSCurrentWeatherObject *object, NSError *error))completionBlock {

    NSData *data = nil;
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSUserDefaults *fDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastRefreshDate = [fDefaults objectForKey: @"JSCurrentWeatherRefreshDate"];
    const BOOL timePassed = !lastRefreshDate || (-1 * [lastRefreshDate timeIntervalSinceNow]) >= WEATHER_REFRESH_TIME;

    if (timePassed) {
        NSString *query = [[NSString stringWithFormat:@"%@%@%@%@%@,%@", kJSWeatherAPIURL, kJSWeatherAPITypeData, kJSWeatherAPIVersion, kJSWeatherAPIQueryWeather,city, state] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:query] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

        if (error) {
            completionBlock(nil, error);
            return;
        } else {
            [fDefaults setObject: data forKey: @"JSCurrentWeatherData"];
		}
        [fDefaults setObject: [NSDate date] forKey: @"JSCurrentWeatherRefreshDate"];
        [fDefaults synchronize];
    } else {
        data = [fDefaults objectForKey: @"JSCurrentWeatherData"];
    }

    if (data != nil) {
        NSMutableDictionary * json = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]];
        if ([[json objectForKey:@"cod"] intValue] == 404) {
            NSString *reason = @"Apparently, the city queried for has no data to return";
            NSError *error = [NSError errorWithDomain:@"com.JSWeather.api" code:301 userInfo:@{NSLocalizedFailureReasonErrorKey:reason, NSLocalizedFailureReasonErrorKey:reason, NSLocalizedRecoverySuggestionErrorKey:@"Change the city"}];
            completionBlock(nil, error);
            return;
        }
        JSCurrentWeatherObject *object = [[JSCurrentWeatherObject alloc] initWithData:json temperatureConversion:self.temperatureMetric];
        completionBlock(object, nil);
        return;
    }
}

- (void)queryForCurrentWeatherWithCoordinate:(NSNumber *)latitude longitude:(NSNumber *)longitude block:(void (^)(JSCurrentWeatherObject *object, NSError *error))completionBlock {

    NSData *data = nil;
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSUserDefaults *fDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastRefreshDate = [fDefaults objectForKey: @"JSCurrentWeatherRefreshDate"];
    const BOOL timePassed = !lastRefreshDate || (-1 * [lastRefreshDate timeIntervalSinceNow]) >= WEATHER_REFRESH_TIME;

    if (timePassed) {
        NSString *query = [[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@", kJSWeatherAPIURL, kJSWeatherAPITypeData, kJSWeatherAPIVersion, kJSWeatherAPIQueryCoordinates, kJSWeatherAPIQueryLatitude, latitude, kJSWeatherAPIQueryLongitude, longitude, kJSWeatherAPIAPPIDURL, kJSWeatherAPIAPPID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:query] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

        if (error) {
            completionBlock(nil, error);
            return;
        } else {
            [fDefaults setObject: data forKey: @"JSCurrentWeatherData"];
        }
        [fDefaults setObject: [NSDate date] forKey: @"JSCurrentWeatherRefreshDate"];
        [fDefaults synchronize];
    } else {
        data = [fDefaults objectForKey: @"JSCurrentWeatherData"];
    }

    if (data != nil) {
        NSMutableDictionary * json = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]];
        if ([[json objectForKey:@"cod"] intValue] == 404) {
            NSString *reason = @"Apparently, the city queried for has no data to return";
            NSError *error = [NSError errorWithDomain:@"com.JSWeather.api" code:301 userInfo:@{NSLocalizedFailureReasonErrorKey:reason, NSLocalizedFailureReasonErrorKey:reason, NSLocalizedRecoverySuggestionErrorKey:@"Change the city"}];
            completionBlock(nil, error);
            return;
        }
        JSCurrentWeatherObject *object = [[JSCurrentWeatherObject alloc] initWithData:json temperatureConversion:self.temperatureMetric];
        completionBlock(object, nil);
        return;
    }
}

- (void)queryForDailyForecastWithNumberOfDays:(NSInteger)numberOfDays city:(NSString *)city state:(NSString *)state block:(void (^)(NSArray *objects, NSError *error))completionBlock {

    if (numberOfDays > 16 || numberOfDays < 1) {
        NSString *reason = [NSString stringWithFormat:@"Cannot ask for %li days of daily forecast information. It must be greater than 1 and less than 17.", (long)numberOfDays];
        NSError *error = [NSError errorWithDomain:@"com.JSWeather.api" code:301 userInfo:@{ NSLocalizedFailureReasonErrorKey:reason, NSLocalizedFailureReasonErrorKey:reason, NSLocalizedRecoverySuggestionErrorKey:@"Make sure the numberOfDays passed is between 1 and 16"}];
        completionBlock(nil, error);
        return;
    }
    NSUserDefaults *fDefaults = [NSUserDefaults standardUserDefaults];
    NSString *keyForForecastRefreshDate = [NSString stringWithFormat:@"JSDailyForecastRefreshDate%ld", (long)numberOfDays];
    NSString *keyForForecastData = [NSString stringWithFormat:@"JSDailyForecastData%ld", (long)numberOfDays];
    NSDate *lastRefreshDate = [fDefaults objectForKey:keyForForecastRefreshDate];
    const BOOL timePassed = !lastRefreshDate || (-1 * [lastRefreshDate timeIntervalSinceNow]) >= WEATHER_REFRESH_TIME;

    if (timePassed) {
        NSString *query = [[NSString stringWithFormat:@"%@%@%@%@%@,%@&%@%li", kJSWeatherAPIURL, kJSWeatherAPITypeData, kJSWeatherAPIVersion, kJSWeatherAPIQueryDailyForecast,city, state, kJSWeatherAPIQueryDailyForecastCount, (long)numberOfDays] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [self executeQuery:query block:^(NSData *queryResponse, NSError *error) {
            if (error) {
                completionBlock(nil, error);
                return;
			}

            [fDefaults setObject: queryResponse forKey:keyForForecastData];
            [fDefaults setObject: [NSDate date] forKey:keyForForecastRefreshDate];
            [fDefaults synchronize];
            [self transformWeatherData:queryResponse forClassType:[JSDailyForecastObject class] block:^(NSArray *theObjects, NSError *error) { completionBlock(theObjects, nil); }];
        }];
    } else {
        NSData *cachedData = [fDefaults objectForKey:keyForForecastData];
        [self transformWeatherData:cachedData forClassType:[JSDailyForecastObject class] block:^(NSArray *theObjects, NSError *error) { completionBlock(theObjects, nil); }];
    }
}

- (void)queryForDailyForecastCoordWithNumberOfDays:(NSInteger)numberOfDays latitude:(NSNumber *)latitude longitude:(NSNumber *)longitude block:(void (^)(NSArray *objects, NSError *error))completionBlock {

    if (numberOfDays > 16 || numberOfDays < 1) {
        NSString *reason = [NSString stringWithFormat:@"Cannot ask for %li days of daily forecast information. It must be greater than 1 and less than 17.", (long)numberOfDays];
        NSError *error = [NSError errorWithDomain:@"com.JSWeather.api" code:301 userInfo:@{ NSLocalizedFailureReasonErrorKey:reason, NSLocalizedFailureReasonErrorKey:reason, NSLocalizedRecoverySuggestionErrorKey:@"Make sure the numberOfDays passed is between 1 and 16"}];
        completionBlock(nil, error);
        return;
    }
    NSUserDefaults *fDefaults = [NSUserDefaults standardUserDefaults];
    NSString *keyForForecastRefreshDate = [NSString stringWithFormat:@"JSDailyForecastRefreshDate%ld", (long)numberOfDays];
    NSString *keyForForecastData = [NSString stringWithFormat:@"JSDailyForecastData%ld", (long)numberOfDays];
    NSDate *lastRefreshDate = [fDefaults objectForKey:keyForForecastRefreshDate];
    const BOOL timePassed = !lastRefreshDate || (-1 * [lastRefreshDate timeIntervalSinceNow]) >= WEATHER_REFRESH_TIME;
    if (timePassed) {
        NSString *query = [[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@&%@%li%@%@", kJSWeatherAPIURL, kJSWeatherAPITypeData, kJSWeatherAPIVersion, kJSWeatherAPIQueryDailyForecastCoord, kJSWeatherAPIQueryLatitude, latitude, kJSWeatherAPIQueryLongitude, longitude, kJSWeatherAPIQueryDailyForecastCount, (long)numberOfDays, kJSWeatherAPIAPPIDURL, kJSWeatherAPIAPPID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        [self executeQuery:query block:^(NSData *queryResponse, NSError *error) {
             if (error) {
                 completionBlock(nil, error);
                 return;
             }
             [fDefaults setObject: queryResponse forKey:keyForForecastData];
             [fDefaults setObject: [NSDate date] forKey:keyForForecastRefreshDate];
             [fDefaults synchronize];
             [self transformWeatherData:queryResponse forClassType:[JSDailyForecastObject class] block:^(NSArray *theObjects, NSError *error) {completionBlock(theObjects, nil); }];
         }];
    } else {
        NSData *cachedData = [fDefaults objectForKey:keyForForecastData];
        [self transformWeatherData:cachedData forClassType:[JSDailyForecastObject class] block:^(NSArray *theObjects, NSError *error) { completionBlock(theObjects, nil); }];
    }
}

- (void)queryForHourlyForecastWithCity:(NSString *)city state:(NSString *)state block:(void (^)(NSArray *objects, NSError *error))completionBlock {
//    NSString *query = [[NSString stringWithFormat:@"%@%@%@%@%@,%@",
//                        kJSWeatherAPIURL, kJSWeatherAPITypeData, kJSWeatherAPIVersion, kJSWeatherAPIQueryHourlyForecast,city, state] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    [self executeQuery:query forClassType:[JSHourlyForecastObject class] block:^(NSArray *theObjects, NSError *error) {
//        if (error) {
//            completionBlock(nil, error);
//            return;
//        }
//        
//        completionBlock(theObjects, nil);
//    }];
}

- (void)queryForHistoricalDataWithCity:(NSString *)city state:(NSString *)state block:(void(^)(NSArray *objects, NSError *error))completionBlock {
//    NSString *query = [[NSString stringWithFormat:@"%@%@%@%@%@%@,%@",
//                        kJSWeatherAPIURL, kJSWeatherAPITypeData, kJSWeatherAPIVersion, kJSWeatherAPITypeHistory, kJSWeatherAPIQueryHistoricalData,city, state] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

//    [self executeQuery:query forClassType:[JSHistoricalDataObject class] block:^(NSArray *theObjects, NSError *error) {
//        if (error) {
//            completionBlock(nil, error);
//            return;
//        }
//        
//        completionBlock(theObjects, nil);
//    }];
}

- (void)executeQuery:(NSString *)query block:(void(^)(NSData *queryResponse, NSError *error))completionBlock {
    NSData *data = nil;
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:query] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (error) {
        completionBlock(nil, error);
        return;
    } else {
        completionBlock(data, error);
    }
}

- (void)transformWeatherData:(NSData *)data forClassType:(id)classType block:(void(^)(NSArray *theObjects, NSError *error))completionBlock {
    NSError *error = nil;
    NSMutableDictionary * json = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]];
    NSMutableArray *arr = [NSMutableArray array];
	
    if ([[json objectForKey:@"list"] count] == 0) {
        NSString *reason = @"Apparently, the city queried for has no data to return";
        NSError *error = [NSError errorWithDomain:@"com.JSWeather.api" code:301 userInfo:@{NSLocalizedFailureReasonErrorKey:reason, NSLocalizedFailureReasonErrorKey:reason, NSLocalizedRecoverySuggestionErrorKey:@"Change the city"}];
        completionBlock(nil, error);
        return;
    }

    for (NSDictionary * dict in [json objectForKey:@"list"]) {
        NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:dict];
        id object;

        if ([classType isEqual:[JSHistoricalDataObject class]])
            object = [[JSHistoricalDataObject alloc] initWithData:d temperatureConversion:self.temperatureMetric];
        else if ([classType isEqual:[JSHourlyForecastObject class]])
            object = [[JSHourlyForecastObject alloc] initWithData:d temperatureConversion:self.temperatureMetric];
        else if ([classType isEqual:[JSDailyForecastObject class]])
            object = [[JSDailyForecastObject alloc] initWithData:d temperatureConversion:self.temperatureMetric];

        [arr addObject:object];
        if ([arr count] == [[json objectForKey:@"list"] count]) {
            [arr sortUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"objects.date"  ascending:YES]]];
            completionBlock(arr, nil);
            return;
        }
    }
}

- (void)JSCurrentLocation:(JSCurrentLocation *)object didFailToReceiveLocation:(NSError *)error {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JSWeather:didReceiveCurrentLocationError:)])
        [self.delegate JSWeather:self didReceiveCurrentLocationError:error];
}

- (void)JSCurrentLocation:(JSCurrentLocation *)object didReceiveLocation:(NSDictionary *)location {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JSWeather:didReceiveCurrentLocation:)])
        [self.delegate JSWeather:self didReceiveCurrentLocation:location];
}

@end