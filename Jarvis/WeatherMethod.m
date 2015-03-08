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
		//api.openweathermap.org/data/2.5/weather?q=London,uk
		//weatherContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@,%@&units=%@&APPID=%@", localityWeather, countryCodeWeather, temperatureType, openweathermapAPPID]] encoding: NSUTF8StringEncoding error:nil];
		weatherContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@,%@&units=metric", localityWeather, countryCodeWeather]] encoding: NSUTF8StringEncoding error:nil];
		//NSLog(@"weather: %@", weatherContent);
		if(weatherContent != nil)
		{			
			NSError *error = NULL;
			NSData *data = [weatherContent dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:&error];
			//NSArray *resultArray = [json objectForKey:@"weather"];
			//NSLog(@"weather: %@",resultArray);
			NSString *currentTemperature = [[json objectForKey:@"main"] objectForKey:@"temp"];
		//	NSString *currentTemperature = [[json objectForKey:@"main"] objectForKey:@"temp"];
			NSData	*weatherData = [[json objectForKey:@"weather"] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *weatherJson = [NSJSONSerialization
                                  JSONObjectWithData:weatherData
                                  options:kNilOptions
                                  error:&error];
			NSLog(@"weather: %@",weatherJson);
			
			
			NSString *currentWeather = @"";
			NSString *countryName = @"";
			
			//currentWeather = [[weather componentsSeparatedByString:@"<title>Yahoo! Weather - "] objectAtIndex:1];
			//currentWeather = [[currentWeather componentsSeparatedByString:@","] objectAtIndex:0];
			
			
			outputWeatherText = [outputWeatherText stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"\nThe weather in %@ is : %@", @""),localityWeather, currentTemperature]];
			
			NSLog(@"weather: %@", [[json objectForKey:@"main"] objectForKey:@"temp"]);
			
			weatherImage = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"http://openweathermap.org/img/w/10d.png"]];
			
			/*
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
			*/
		}
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
