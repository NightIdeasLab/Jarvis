//
//  WeatherMethod.m
//  Jarvis
//
//  Created by Gabriel Ulici on 7/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "WeatherMethod.h"

@implementation WeatherMethod

//- (NSString *) retrieveWeather {
-(NSDictionary *) retrieveWeather {
	// reading from the plist file
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
    //Weather conditions
    __block NSString *outputWeatherText = [[NSString alloc] init];
	NSString *localityWeather = [defaults stringForKey: @"Locality"];
	NSString *countryCodeWeather = [defaults stringForKey: @"CountryCode"];
	NSString *temperatureType = [defaults stringForKey: @"TemperatureStyle"];
	__block NSData *weatherImage = NULL;
	//BOOL forecastState = [defaults boolForKey:@"ForecastWeather"];
	
	if(localityWeather != nil && countryCodeWeather != nil) {
		JSWeather *weather = [JSWeather sharedInstance];
		if ([temperatureType isEqualToString:@"Celsius"]) {
			[weather setTemperatureMetric:kJSCelsius];
		} else 	if ([temperatureType isEqualToString:@"Kelvin"]) {
			[weather setTemperatureMetric:kJSKelvin];
		} else 	if ([temperatureType isEqualToString:@"Fahrenheit"]) {
			[weather setTemperatureMetric:kJSFahrenheit];
		}
		[weather setDelegate:self];
		
		NSString *city = localityWeather;
		NSString *state = countryCodeWeather;
		
		[weather queryForCurrentWeatherWithCity:city state:state block:^(JSCurrentWeatherObject *object, NSError *error) {
			if (error) {
				outputWeatherText = [NSString stringWithFormat:NSLocalizedString(@"\nWeather %@ \n", @""),error];
				return;
			}
			NSString *filePath = [[NSBundle mainBundle] pathForResource:[object.objects objectForKey:@"image"] ofType:@"tiff"];
			weatherImage = [[NSData alloc] initWithContentsOfFile:filePath];
			
			NSString *currentWeather = [object.objects objectForKey:@"weather"];
			NSString *currentTemperature = [object.objects objectForKey:@"current_temp"];
			outputWeatherText = [outputWeatherText stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"\n%@ in %@ with current temperature %@", @""), currentWeather, localityWeather, currentTemperature]];
			
			NSString *todayMin = [object.objects objectForKey:@"min_temp"];
			NSString *todayMax = [object.objects objectForKey:@"max_temp"];
			
			outputWeatherText = [outputWeatherText stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"\nToday High is: %@ and Low is %@ \n", @""), todayMax, todayMin]];
		}];
		
		[weather queryForDailyForecastWithNumberOfDays:1 city:city state:state block:^(NSArray *objects, NSError *error) {
			if (error) {
				outputWeatherText = [NSString stringWithFormat:NSLocalizedString(@"\Error retrieving min and max temp with error: %@ \n", @""),error];
				return;
			}
			
			for (JSDailyForecastObject * obj in objects) {
				NSLog(@"%@", obj.objects);
			}
		}];
		
		// i need to get the forecast of current day to get the high and low temp
		/*
		if (forecastState == YES) {
			//Forecast for the next 5 days
			weatherContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@&u=%@", woeidCodeWeather, temperatureType]] encoding: NSUTF8StringEncoding error:nil];

			outputWeatherText = [outputWeatherText stringByAppendingString:NSLocalizedString(@"Forecast for the next 5 days: \n", @"")];
			if(weatherContent != nil)
			{
				if ([[weatherContent componentsSeparatedByString:@"<BR /><b>Forecast:</b><BR />"] count]>1)
				{
					weatherText = [[weatherContent componentsSeparatedByString:@"<BR /><b>Forecast:</b><BR />"] objectAtIndex:1];
					weatherText = [[weatherText componentsSeparatedByString:@"<a href="] objectAtIndex:0];

					//Removing white spaces from the beginning or end of the string retrieved
					NSString *trimmedString = [weatherText stringByTrimmingCharactersInSet:
											   [NSCharacterSet whitespaceAndNewlineCharacterSet]];

					//removing the <br /> from the text
					NSString *trimmedString1 = [trimmedString
												stringByReplacingOccurrencesOfString:@"<br />" withString:@""];

					outputWeatherText = [outputWeatherText stringByAppendingString:trimmedString1];
				}
			}
		}
		*/
    } else {
		outputWeatherText = [outputWeatherText stringByAppendingString:NSLocalizedString(@"\nPlease setup the weather!!!\n", @"")];
	}
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

	return [[NSDictionary alloc] initWithObjectsAndKeys:outputWeatherText, @"outputWeatherText", weatherImage, @"weatherImage", nil];

    //return outputWeatherText;
}

@end
