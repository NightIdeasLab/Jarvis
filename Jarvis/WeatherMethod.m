//
//  WeatherMethod.m
//  Jarvis
//
//  Created by Gabriel Ulici on 7/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "WeatherMethod.h"
#define woeidCode @"721943" //this is the code for weather you can find yours at http://sigizmund.info/woeidinfo/

@implementation WeatherMethod

- (NSString *) retriveWeather {
    
    //Weather conditions
    NSString *text = [[NSString alloc] init];
	NSString *weatherText = [[NSString alloc] initWithString:@""];
	NSString *weatherPage = [[NSString alloc] initWithString:@""];
   	NSString *cityName = [[NSString alloc] initWithString:@""];
    NSString *countryName = [[NSString alloc] initWithString:@""];
	NSString *weatherContent = [[NSString alloc] initWithString:@""];
	weatherPage = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@&u=c",woeidCode]] encoding: NSUTF8StringEncoding error:nil];
	weatherContent = weatherPage;
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
            
            text = [text stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"\nWeather in %@, %@ is : ", @""),cityName, countryName]];
            
            //Removing white spaces from the begining or end of the sting retrived
            NSString *trimmedString = [weatherText stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            text = [text stringByAppendingString:trimmedString];
            text = [text stringByAppendingString:@".\n\n"];
		}
	}
    
    
    //Forecast for the next 5 days
	weatherPage = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@&u=c",woeidCode]] encoding: NSUTF8StringEncoding error:nil];
	weatherContent = weatherPage;
    
    text = [text stringByAppendingString:NSLocalizedString(@"Forecast for the next 5 days: \n", @"")];
    if(weatherContent != nil)
	{
		if ([[weatherContent componentsSeparatedByString:@"<BR /><b>Forecast:</b><BR />"] count]>1)
		{
            weatherText = [[weatherContent componentsSeparatedByString:@"<BR /><b>Forecast:</b><BR />"] objectAtIndex:1];
            weatherText = [[weatherText componentsSeparatedByString:@"<a href="] objectAtIndex:0];
            
            NSLog(@"text from website: %@", weatherText);
            
            //Removing white spaces from the begining or end of the sting retrived
            NSString *trimmedString = [weatherText stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //removing the <br /> from the text
            NSString *trimmedString1 = [trimmedString
                                        stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
            
            text = [text stringByAppendingString:trimmedString1];
		}
	}
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
    [text autorelease];
    return text;
}

@end
