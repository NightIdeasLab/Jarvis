//
//  JSHistoricalDataObject.m
//  Example
//
//  Created by John Setting on 12/5/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//
//  Modified by Gabriel Ulici on 10/4/15.
//  Copyright (c) 2015 Night Ideas Lab. All rights reserved.
//

#import "JSHistoricalDataObject.h"
#import "JSWeatherUtility.h"
#import "JSWeather.h"

@implementation JSHistoricalDataObject
- (id)initWithData:(NSDictionary *)dict {
    return [self initWithData:dict temperatureConversion:kJSKelvin];
}

- (id)initWithData:(NSDictionary *)dict temperatureConversion:(NSInteger)conversion
{
    if (!(self = [super init])) return nil;
    
    self.JSCloudiness = [[[dict objectForKey:@"clouds"] objectForKey:@"all"] floatValue];
    self.JSWeatherDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"dt"] intValue]];
    self.JSHumidity = [[[dict objectForKey:@"main"] objectForKey:@"humidity"] intValue];
    self.JSPressure = [[[dict objectForKey:@"main"] objectForKey:@"pressure"] floatValue];
    self.JSWeatherImage = [dict objectForKey:@"image"];
    
    if (conversion == kJSKelvin || !conversion) {
        self.JSCurrentTemperature = [[[dict objectForKey:@"main"] objectForKey:@"temp"] floatValue];
        self.JSPossibleMaxTemperature = [[[dict objectForKey:@"main"] objectForKey:@"temp_max"] floatValue];
        self.JSPossibleMinTemperature = [[[dict objectForKey:@"main"] objectForKey:@"temp_min"] floatValue];
    } else if (conversion == kJSCelsius) {
        self.JSCurrentTemperature = [[[dict objectForKey:@"main"] objectForKey:@"temp"] floatValue] - 273.15;
        self.JSPossibleMaxTemperature = [[[dict objectForKey:@"main"] objectForKey:@"temp_max"] floatValue] - 273.15;
        self.JSPossibleMinTemperature = [[[dict objectForKey:@"main"] objectForKey:@"temp_min"] floatValue] - 273.15;
    } else if (conversion == kJSFahrenheit) {
        self.JSCurrentTemperature = ([[[dict objectForKey:@"main"] objectForKey:@"temp"] floatValue] - 273.15) * 1.800 + 32.00;
        self.JSPossibleMaxTemperature = ([[[dict objectForKey:@"main"] objectForKey:@"temp_max"] floatValue] - 273.15) * 1.800 + 32.00;
        self.JSPossibleMinTemperature = ([[[dict objectForKey:@"main"] objectForKey:@"temp_min"] floatValue] - 273.15) * 1.800 + 32.00;
    }
    
    self.JSWeatherDescription = [[[[dict objectForKey:@"weather"] firstObject] objectForKey:@"description"] capitalizedString];
    self.JSWindSpeed = [[[dict objectForKey:@"wind"] objectForKey:@"speed"] floatValue];
    self.JSCurrentWindDirection = [JSWeatherUtility handleWindDirection:[[[dict objectForKey:@"wind"] objectForKey:@"deg"] floatValue]];
    self.JSCurrentWindDirectionBeginning = [JSWeatherUtility handleWindDirection:[[[dict objectForKey:@"wind"] objectForKey:@"var_beg"] floatValue]];
    self.JSCurrentWindDirectionEnding = [JSWeatherUtility handleWindDirection:[[[dict objectForKey:@"wind"] objectForKey:@"var_end"] floatValue]];
    self.JSCurrentWindDirectionFloat = [[[dict objectForKey:@"wind"] objectForKey:@"deg"] floatValue];
    self.JSCurrentWindDirectionBeginningFloat =[[[dict objectForKey:@"wind"] objectForKey:@"var_beg"] floatValue];
    self.JSCurrentWindDirectionEndingFloat = [[[dict objectForKey:@"wind"] objectForKey:@"var_end"] floatValue];

    self.objects = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%.0f", self.JSCloudiness],
                                                         self.JSWeatherDate,
                                                         [NSString stringWithFormat:@"%i", self.JSHumidity],
                                                         [NSString stringWithFormat:@"%.0f", self.JSPressure],
                                                         self.JSWeatherImage,
                                                         [NSString stringWithFormat:@"%.0f", self.JSCurrentTemperature],
                                                         [NSString stringWithFormat:@"%.0f", self.JSPossibleMaxTemperature],
                                                         [NSString stringWithFormat:@"%.0f", self.JSPossibleMinTemperature],
                                                         self.JSWeatherDescription,
                                                         [NSString stringWithFormat:@"%.0f", self.JSWindSpeed],
                                                         self.JSCurrentWindDirection,
                                                         self.JSCurrentWindDirectionBeginning,
                                                         self.JSCurrentWindDirectionEnding,
                                                         [NSString stringWithFormat:@"%.0f", self.JSCurrentWindDirectionFloat],
                                                         [NSString stringWithFormat:@"%.0f", self.JSCurrentWindDirectionBeginningFloat],
                                                         [NSString stringWithFormat:@"%.0f", self.JSCurrentWindDirectionEndingFloat]]
                                               forKeys:@[@"cloudiness",
                                                         @"date",
                                                         @"humidity",
                                                         @"pressure",
                                                         @"image",
                                                         @"current_temp",
                                                         @"max_temp",
                                                         @"min_temp",
                                                         @"weather_description",
                                                         @"wind_speed",
                                                         @"wind_direction",
                                                         @"beginning_wind_direction",
                                                         @"ending_wind_direction",
                                                         @"wind_direction_float",
                                                         @"beginning_wind_direction_float",
                                                         @"ending_wind_direction_float"
                                                         ]];
    return self;
}

@end