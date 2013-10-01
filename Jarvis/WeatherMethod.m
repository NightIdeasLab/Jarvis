//
//  WeatherMethod.m
//  Jarvis
//
//  Created by Gabriel Ulici on 7/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "WeatherMethod.h"
//#define woeidCodeWeather @"12843574" //this is the code for weather you can find yours at http://sigizmund.info/woeidinfo/

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

/* OLD CODE FOR THE WEATHER
 //Weather conditions
 NSString * weatherText = [[NSString alloc] init];
 NSString * weatherPage = [[NSString alloc] init];
 NSString * weatherContent = [[NSString alloc] init];
 weatherPage = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.accuweather.com/en-us/it/lazio/rome/quick-look.aspx?cityid=",zipCode]] encoding: NSUTF8StringEncoding error:nil];
 weatherContent = weatherPage;
 if(weatherContent!=nil)
 {
 if ([[weatherContent componentsSeparatedByString:@"<div id=\"quicklook_current_temps\">"] count]>1)
 {
 weatherText = [[weatherContent componentsSeparatedByString:@"<div id=\"quicklook_current_temps\">"] objectAtIndex:1];
 weatherText = [[weatherText componentsSeparatedByString:@"&"] objectAtIndex:0];
 text = [text stringByAppendingString:[NSString stringWithFormat:@"\nWeather in %@ is ",locationName]];
 text = [text stringByAppendingString:weatherText];
 text = [text stringByAppendingString:@" degrees.\n"];
 }
 }
 weatherPage = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.accuweather.com/en-us/it/lazio/rome/quick-look.aspx?cityid=",zipCode]] encoding: NSUTF8StringEncoding error:nil];
 weatherContent = weatherPage;
 if(weatherContent!=nil)
 {
 weatherContent = [[weatherContent componentsSeparatedByString:@"Low:&nbsp;"] objectAtIndex:0];
 if([[weatherContent componentsSeparatedByString:@"High:"] count]>1)
 {
 weatherText = [[weatherContent componentsSeparatedByString:@"High:"] objectAtIndex:1];
 weatherText = [[weatherText componentsSeparatedByString:@";\">"] objectAtIndex:1];
 weatherText = [[weatherText componentsSeparatedByString:@"</div>"] objectAtIndex:0];
 text = [text stringByAppendingString:weatherText];
 text = [text stringByAppendingString:@".\n"];
 
 
 text = [text stringByAppendingString:@"Temperature, will raise up to "];
 weatherText = [[weatherContent componentsSeparatedByString:@"High:"] objectAtIndex:1];
 weatherText = [[weatherText componentsSeparatedByString:@"&"] objectAtIndex:0];
 text = [text stringByAppendingString:weatherText];
 text = [text stringByAppendingString:@" degrees.\n"];
 }
 else
 {
 weatherContent = weatherPage;
 if(weatherContent!=nil)
 {
 weatherText = [[weatherContent componentsSeparatedByString:@"Low:&nbsp;"] objectAtIndex:1];
 weatherText = [[weatherText componentsSeparatedByString:@";\">"] objectAtIndex:1];
 weatherText = [[weatherText componentsSeparatedByString:@"</div>"] objectAtIndex:0];
 text = [text stringByAppendingString:weatherText];
 text = [text stringByAppendingString:@".\n"];
 
 text = [text stringByAppendingString:@"Temperature, will fall down to "];
 weatherText = [[weatherContent componentsSeparatedByString:@"Low:&nbsp;"] objectAtIndex:1];
 weatherText = [[weatherText componentsSeparatedByString:@"&"] objectAtIndex:0];
 text = [text stringByAppendingString:weatherText];
 text = [text stringByAppendingString:@" degrees.\n"];
 }
 }
 }
 */

@end
