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

- (NSString *) retriveWeather {

	// reading from the plist file
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
    //Weather conditions
    NSString *outputWeatherText = [[NSString alloc] init];
	NSString *weatherText = @"";
   	NSString *cityName = @"";
    NSString *countryName = @"";
	NSString *weatherContent = @"";
	NSString *woeidCodeWeather = [defaults stringForKey: @"woeidCode"];
	if(woeidCodeWeather != nil) {
		weatherContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@&u=c",woeidCodeWeather]] encoding: NSUTF8StringEncoding error:nil];
		if(weatherContent != nil)
		{
			if ([[weatherContent componentsSeparatedByString:@"<b>Current Conditions:</b><br />"] count]>1)
			{
				cityName = [[weatherContent componentsSeparatedByString:@"<title>Yahoo! Weather - "] objectAtIndex:1];
				cityName = [[cityName componentsSeparatedByString:@","] objectAtIndex:0];
				countryName = [[weatherContent componentsSeparatedByString:@"country=\""] objectAtIndex:1];
				countryName = [[countryName componentsSeparatedByString:@"\"/>"] objectAtIndex:0];
				weatherText = [[weatherContent componentsSeparatedByString:@"<b>Current Conditions:</b><br />"] objectAtIndex:1];
				weatherText = [[weatherText componentsSeparatedByString:@"<BR />"] objectAtIndex:0];
				
				outputWeatherText = [outputWeatherText stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"\nWeather in %@, %@ is : ", @""),cityName, countryName]];
				
				//Removing white spaces from the begining or end of the sting retrived
				NSString *trimmedString = [weatherText stringByTrimmingCharactersInSet:
										   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
				
				outputWeatherText = [outputWeatherText stringByAppendingString:trimmedString];
				outputWeatherText = [outputWeatherText stringByAppendingString:@".\n\n"];
			}
		}
		
		
		//Forecast for the next 5 days
		// FIXME: the forcast is really ugly, redo it :)
		weatherContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@&u=c",woeidCodeWeather]] encoding: NSUTF8StringEncoding error:nil];
		
		outputWeatherText = [outputWeatherText stringByAppendingString:NSLocalizedString(@"Forecast for the next 5 days: \n", @"")];
		if(weatherContent != nil)
		{
			if ([[weatherContent componentsSeparatedByString:@"<BR /><b>Forecast:</b><BR />"] count]>1)
			{
				weatherText = [[weatherContent componentsSeparatedByString:@"<BR /><b>Forecast:</b><BR />"] objectAtIndex:1];
				weatherText = [[weatherText componentsSeparatedByString:@"<a href="] objectAtIndex:0];

				//Removing white spaces from the begining or end of the sting retrived
				NSString *trimmedString = [weatherText stringByTrimmingCharactersInSet:
										   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
				
				//removing the <br /> from the text
				NSString *trimmedString1 = [trimmedString
											stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
				
				outputWeatherText = [outputWeatherText stringByAppendingString:trimmedString1];
			}
		}
    } else {
		outputWeatherText = [outputWeatherText stringByAppendingString:NSLocalizedString(@"\nPlease setup the weather!!!\n", @"")];
	}
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
	
    //[outputWeatherText autorelease];
    return outputWeatherText;
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
