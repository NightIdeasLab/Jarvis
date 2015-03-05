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
	NSString *weatherText = @"";
   	NSString *cityName = @"";
    NSString *stateName = @"";
    NSString *countryName = @"";
	NSString *weatherContent = @"";
	NSString *woeidCodeWeather = [defaults stringForKey: @"woeidCode"];
	NSString *temperatureType = [defaults stringForKey: @"TemperatureStyle"];
	NSString *weatherImage = @"";
	BOOL forecastState = [defaults boolForKey:@"ForecastWeather"];
	
	if(woeidCodeWeather != nil) {
		weatherContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@&u=%@", woeidCodeWeather, temperatureType]] encoding: NSUTF8StringEncoding error:nil];
		if(weatherContent != nil)
		{
			if ([[weatherContent componentsSeparatedByString:@"<b>Current Conditions:</b><br />"] count]>1)
			{
				weatherImage = [[weatherContent componentsSeparatedByString:@"<img src=\""] objectAtIndex:1];
				weatherImage = [[weatherImage componentsSeparatedByString:@"\"/><br />"] objectAtIndex:0];
	
				cityName = [[weatherContent componentsSeparatedByString:@"<title>Yahoo! Weather - "] objectAtIndex:1];
				cityName = [[cityName componentsSeparatedByString:@","] objectAtIndex:0];
                stateName = [[weatherContent componentsSeparatedByString:@"region=\""] objectAtIndex:1];
                stateName = [[stateName componentsSeparatedByString:@"\" "] objectAtIndex:0];
				countryName = [[weatherContent componentsSeparatedByString:@"country=\""] objectAtIndex:1];
				countryName = [[countryName componentsSeparatedByString:@"\"/>"] objectAtIndex:0];
				weatherText = [[weatherContent componentsSeparatedByString:@"<b>Current Conditions:</b><br />"] objectAtIndex:1];
				weatherText = [[weatherText componentsSeparatedByString:@"<BR />"] objectAtIndex:0];

				if ([countryName isEqualToString:@"United States"]) {
					outputWeatherText = [outputWeatherText stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"\nThe weather in %@, %@ is : ", @""),cityName, stateName]];
				} else {
					outputWeatherText = [outputWeatherText stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"\nThe weather in %@, %@ is : ", @""),cityName, countryName]];
				}
				
				//Removing white spaces from the beginning or end of the string retrieved
				NSString *trimmedString = [weatherText stringByTrimmingCharactersInSet:
										   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
				
				outputWeatherText = [outputWeatherText stringByAppendingString:trimmedString];
				outputWeatherText = [outputWeatherText stringByAppendingString:@".\n"];
			}
		}
		
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
		
    } else {
		outputWeatherText = [outputWeatherText stringByAppendingString:NSLocalizedString(@"\nPlease setup the weather!!!\n", @"")];
	}
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

	return [[NSDictionary alloc] initWithObjectsAndKeys:outputWeatherText, @"outputWeatherText", weatherImage, @"weatherImage", nil];

    //return outputWeatherText;
}

@end
