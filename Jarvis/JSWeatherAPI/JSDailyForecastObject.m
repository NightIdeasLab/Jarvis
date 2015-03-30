//
//  JSDailyForecastObject.m
//  JSWeatherAPI
//
//  Created by John Setting on 12/4/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import "JSDailyForecastObject.h"
#import "JSWeatherUtility.h"
#import "JSWeather.h"

@implementation JSDailyForecastObject

- (id)initWithData:(NSDictionary *)dict {
    return [self initWithData:dict temperatureConversion:kJSKelvin];
}

- (id)initWithData:(NSDictionary *)dict temperatureConversion:(NSInteger)conversion
{
    if (!(self = [super init])) return nil;
        
    self.JSWeatherImage = [[[dict objectForKey:@"weather"] firstObject] objectForKey:@"icon"];
    self.JSWindDirection = [JSWeatherUtility handleWindDirection:[[dict objectForKey:@"deg"] floatValue]];
    self.JSWindDirectionFloat = [[dict objectForKey:@"deg"] floatValue];
    self.JSForecastDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"dt"] intValue]];
    self.JSHumidity = [[dict objectForKey:@"humidity"] intValue];
    self.JSPressure = [[dict objectForKey:@"pressure"] floatValue];
    self.JSRain = [[dict objectForKey:@"rain"] floatValue];
    self.JSWindSpeed = [[dict objectForKey:@"speed"] floatValue];
    self.JSCloudiness = [[dict objectForKey:@"clouds"]floatValue];

    if (conversion == kJSKelvin || !conversion) {
        self.JSDayForecastDayTemperature = [[[dict objectForKey:@"temp"] objectForKey:@"day"] floatValue];
        self.JSDayForecastEveningTemperature = [[[dict objectForKey:@"temp"] objectForKey:@"eve"] floatValue];
        self.JSDayForecastMaxTemperature = [[[dict objectForKey:@"temp"] objectForKey:@"max"] floatValue];
        self.JSDayForecastMinTemperature = [[[dict objectForKey:@"temp"] objectForKey:@"min"] floatValue];
        self.JSDayForecastMorningTemperature = [[[dict objectForKey:@"temp"] objectForKey:@"morn"] floatValue];
        self.JSDayForecastNightTemperature = [[[dict objectForKey:@"temp"] objectForKey:@"night"] floatValue];
    } else if (conversion == kJSCelsius) {
        self.JSDayForecastDayTemperature = [[[dict objectForKey:@"temp"] objectForKey:@"day"] floatValue] - 273.15;
        self.JSDayForecastEveningTemperature = [[[dict objectForKey:@"temp"] objectForKey:@"eve"] floatValue] - 273.15;
        self.JSDayForecastMaxTemperature = [[[dict objectForKey:@"temp"] objectForKey:@"max"] floatValue] - 273.15;
        self.JSDayForecastMinTemperature = [[[dict objectForKey:@"temp"] objectForKey:@"min"] floatValue] - 273.15;
        self.JSDayForecastMorningTemperature = [[[dict objectForKey:@"temp"] objectForKey:@"morn"] floatValue] - 273.15;
        self.JSDayForecastNightTemperature = [[[dict objectForKey:@"temp"] objectForKey:@"night"] floatValue] - 273.15;
    } else if (conversion == kJSFahrenheit) {
        self.JSDayForecastDayTemperature = ([[[dict objectForKey:@"temp"] objectForKey:@"day"] floatValue] - 273.15) * 1.800 + 32.00;
        self.JSDayForecastEveningTemperature = ([[[dict objectForKey:@"temp"] objectForKey:@"eve"] floatValue] - 273.15) * 1.800 + 32.00;
        self.JSDayForecastMaxTemperature = ([[[dict objectForKey:@"temp"] objectForKey:@"max"] floatValue] - 273.15) * 1.800 + 32.00;
        self.JSDayForecastMinTemperature = ([[[dict objectForKey:@"temp"] objectForKey:@"min"] floatValue] - 273.15) * 1.800 + 32.00;
        self.JSDayForecastMorningTemperature = ([[[dict objectForKey:@"temp"] objectForKey:@"morn"] floatValue] - 273.15) * 1.800 + 32.00;
        self.JSDayForecastNightTemperature = ([[[dict objectForKey:@"temp"] objectForKey:@"night"] floatValue] - 273.15) * 1.800 + 32.00;
    }
	
    self.JSWeatherDescription = [[[[dict objectForKey:@"weather"] firstObject] objectForKey:@"description"] capitalizedString];
    self.objects = [NSDictionary dictionaryWithObjects:@[self.JSWeatherImage,
                                                         self.JSWindDirection,
                                                         [NSString stringWithFormat:@"%.2f", self.JSWindDirectionFloat],
                                                         self.JSForecastDate,
                                                         [NSString stringWithFormat:@"%.2f", self.JSCloudiness],
                                                         [NSString stringWithFormat:@"%i", self.JSHumidity],
                                                         [NSString stringWithFormat:@"%.2f", self.JSPressure],
                                                         [NSString stringWithFormat:@"%.2f", self.JSRain],
                                                         [NSString stringWithFormat:@"%.2f", self.JSWindSpeed],
                                                         [NSString stringWithFormat:@"%.2f", self.JSDayForecastDayTemperature],
                                                         [NSString stringWithFormat:@"%.2f", self.JSDayForecastEveningTemperature],
                                                         [NSString stringWithFormat:@"%.2f", self.JSDayForecastMaxTemperature],
                                                         [NSString stringWithFormat:@"%.2f", self.JSDayForecastMinTemperature],
                                                         [NSString stringWithFormat:@"%.2f", self.JSDayForecastMorningTemperature],
                                                         [NSString stringWithFormat:@"%.2f", self.JSDayForecastNightTemperature],
                                                         self.JSWeatherDescription]
                                               forKeys:@[@"image",
                                                         @"wind_direction",
                                                         @"wind_direction_float",
                                                         @"date",
                                                         @"cloudiness",
                                                         @"humidity",
                                                         @"pressure",
                                                         @"rain",
                                                         @"wind_speed",
                                                         @"day",
                                                         @"evening",
                                                         @"max",
                                                         @"min",
                                                         @"morning",
                                                         @"night",
                                                         @"weather_description"]];
    return self;
}

@end
