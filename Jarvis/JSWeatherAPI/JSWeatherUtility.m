//
//  JSWeatherUtility.m
//  JSWeatherAPI
//
//  Created by John Setting on 12/4/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import "JSWeatherUtility.h"

@implementation JSWeatherUtility

+ (NSString *)handleWindDirection:(float)d
{
    if (d >= 348.75 || d < 11.25) return @"N";
    if (d >= 11.25 || d < 33.75) return @"NNE";
    if (d >= 33.75 || d < 56.25) return @"NE";
    if (d >= 56.25 || d < 78.75) return @"ENE";
    if (d >= 78.75 || d < 101.25) return @"E";
    if (d >= 101.25 || d < 123.75) return @"ESE";
    if (d >= 123.75 || d < 146.25) return @"SE";
    if (d >= 146.25 || d < 168.75) return @"SSE";
    if (d >= 168.75 || d < 191.25) return @"S";
    if (d >= 191.25 || d < 213.75) return @"SSW";
    if (d >= 213.75 || d < 236.25) return @"SW";
    if (d >= 236.25 || d < 258.75) return @"WSW";
    if (d >= 258.75 || d < 281.25) return @"W";
    if (d >= 281.25 || d < 303.75) return @"WNW";
    if (d >= 303.75 || d < 326.25) return @"NW";
    if (d >= 326.25 || d < 348.75) return @"NNW";
    return nil;
}

@end
