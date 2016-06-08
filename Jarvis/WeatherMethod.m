//
//  WeatherMethod.m
//  Jarvis
//
//  Created by Gabriel Ulici on 7/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "WeatherMethod.h"

@implementation WeatherMethod

-(NSDictionary *) retrieveWeather {
    // reading from the plist file
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //Weather conditions
    __block NSString *outputWeatherText = [[NSString alloc] init];
    NSString *localityWeather = [defaults stringForKey: @"Locality"];
    NSString *temperatureType = [defaults stringForKey: @"TemperatureStyle"];
    __block NSData *weatherImage = NULL;
    
    NSDictionary *userCoordinate=[[NSUserDefaults standardUserDefaults] objectForKey:@"userCoordinate"];
    NSNumber *userLatitude = [userCoordinate objectForKey:@"lat"];
    NSNumber *userLongitude = [userCoordinate objectForKey:@"long"];
	
    if (userLatitude != nil && userLongitude != nil) {
        JSWeather *weather = [JSWeather sharedInstance];
        
        if ([temperatureType isEqualToString:@"Celsius"]) {
            [weather setTemperatureMetric:kJSCelsius];
        } else if ([temperatureType isEqualToString:@"Kelvin"]) {
            [weather setTemperatureMetric:kJSKelvin];
        } else if ([temperatureType isEqualToString:@"Fahrenheit"]) {
            [weather setTemperatureMetric:kJSFahrenheit];
        }

        [weather setDelegate:self];

        [weather queryForCurrentWeatherWithCoordinate:userLatitude longitude:userLongitude block:^(JSCurrentWeatherObject *object, NSError *error) {
            if (error) {
                outputWeatherText = [NSString stringWithFormat:NSLocalizedString(@"\nWeather %@ \n", @""),error];
                return;
            } else {
                NSString *filePath = [[NSBundle mainBundle] pathForResource:[object.objects objectForKey:@"image"] ofType:@"png"];
                weatherImage = [[NSData alloc] initWithContentsOfFile:filePath];
                
                NSString *currentWeather = [object.objects objectForKey:@"weather"];
                NSString *currentTemperature = [object.objects objectForKey:@"current_temp"];
                outputWeatherText = [outputWeatherText stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"\n%@ in %@ with current temperature %@ ˚.", @""), currentWeather, localityWeather, currentTemperature]];
            }
        }];

        [weather queryForDailyForecastCoordWithNumberOfDays:1 latitude:userLatitude longitude:userLongitude block:^(NSArray *objects, NSError *error) {
            if (error) {
                outputWeatherText = [NSString stringWithFormat:NSLocalizedString(@"\Error retrieving min and max temp with error: %@ \n", @""),error];
                return;
            } else {
                for (JSDailyForecastObject * obj in objects) {
                    NSString *todayMin = [obj.objects objectForKey:@"min"];
                    NSString *todayMax = [obj.objects objectForKey:@"max"];
                    outputWeatherText = [outputWeatherText stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"\nToday High is %@˚ and Low is %@˚.\n", @""), todayMax, todayMin]];
                }
            }
        }];
	} else {
        outputWeatherText = [outputWeatherText stringByAppendingString:NSLocalizedString(@"\nPlease setup the weather!\n", @"")];
	}
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    return [[NSDictionary alloc] initWithObjectsAndKeys:outputWeatherText, @"outputWeatherText", weatherImage, @"weatherImage", nil];
}

@end