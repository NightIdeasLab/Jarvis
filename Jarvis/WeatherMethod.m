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
    NSString *outputWeatherText = [[NSString alloc] init];
	NSString *weatherContent = @"";
	NSString *localityWeather = [defaults stringForKey: @"Locality"];
	NSString *countryCodeWeather = [defaults stringForKey: @"CountryCode"];
	NSString *openweathermapAPPID = [defaults stringForKey: @"openweathermapAPPID"];
	NSString *temperatureType = [defaults stringForKey: @"TemperatureStyle"];
	NSData *weatherImage = NULL;
	//BOOL forecastState = [defaults boolForKey:@"ForecastWeather"];
	
	if(localityWeather != nil && countryCodeWeather != nil) {
		JSWeather *weather = [JSWeather sharedInstance];
		[weather setTemperatureMetric:kJSFahrenheit];
		[weather setDelegate:self];
		
		NSString *city = localityWeather;
		NSString *state = countryCodeWeather;
		
		[weather queryForCurrentWeatherWithCity:city state:state block:^(JSCurrentWeatherObject *object, NSError *error) {
			if (error) {
				//[[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
				//return;
				NSLog(@"error: %@", [error localizedDescription]);
			}
			
			NSLog(@"%@", object.objects);
		}];
		
		//weatherContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@,%@&units=%@&APPID=%@&mode=xml", localityWeather, countryCodeWeather, temperatureType, openweathermapAPPID]] encoding: NSUTF8StringEncoding error:nil];
		NSDictionary *weatherResponse = nil;
		if (weatherResponse == NULL) {
			NSError *error = NULL;
			NSData *currentResponse = [weatherContent dataUsingEncoding:NSUTF8StringEncoding];
			NSDictionary *weatherJson = [NSJSONSerialization
										 JSONObjectWithData:currentResponse
										 options:kNilOptions
										 error:&error];
			outputWeatherText = [NSString stringWithFormat:NSLocalizedString(@"\nWeather %@ \n", @""),[weatherJson objectForKey:@"message"]];
		} else {			
			NSString *currentIcon = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png", [[weatherResponse objectForKey:@"weather"] objectForKey:@"_icon"]];
			weatherImage = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: currentIcon]];
			
			NSString *currentWeather = [[weatherResponse objectForKey:@"weather"] objectForKey:@"_value"];
			NSString *currentTemperature = [[weatherResponse objectForKey:@"temperature"] objectForKey:@"_value"];
			outputWeatherText = [outputWeatherText stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"\n%@ in %@ with current temperature %@", @""), currentWeather, localityWeather, currentTemperature]];
			
			NSString *todayMin = [[weatherResponse objectForKey:@"temperature"] objectForKey:@"_min"];
			NSString *todayMax = [[weatherResponse objectForKey:@"temperature"] objectForKey:@"_max"];
			
			outputWeatherText = [outputWeatherText stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"\nToday High is: %@ and Low is %@ \n", @""), todayMax, todayMin]];
		}
		// i need to get the forecast of current day to get the high and low temp
		/*
		if (forecastState == YES) {
			//Forecast for the next 5 days
			// FIXME: the forcast is really ugly, redo it :)
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
