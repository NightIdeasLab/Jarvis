//
//  JSHourlyForecastObject.m
//  JSWeatherAPI
//
//  Created by John Setting on 12/4/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//

#import "JSHourlyForecastObject.h"
#import "JSWeatherUtility.h"
#import "JSWeather.h"

@implementation JSHourlyForecastObject
- (id)initWithData:(NSDictionary *)dict
{
    return [self initWithData:dict temperatureConversion:kJSKelvin];
}

- (id)initWithData:(NSDictionary *)dict temperatureConversion:(NSInteger)conversion
{
    if (!(self = [super init])) return nil;
    self.JSWeatherImage = [dict objectForKey:@"image"];
    self.JSCloudiness = [[[dict objectForKey:@"clouds"] objectForKey:@"all"] floatValue];
    self.JSWeatherDate = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"dt"] intValue]];
    self.JSGroundLevel = [[[dict objectForKey:@"main"] objectForKey:@"grnd_level"] floatValue];
    self.JSHumidity = [[[dict objectForKey:@"main"] objectForKey:@"humidity"] intValue];
    self.JSPressure = [[[dict objectForKey:@"main"] objectForKey:@"pressure"] floatValue];
    self.JSSealevel = [[[dict objectForKey:@"main"] objectForKey:@"sea_level"] floatValue];
    
    if (conversion == kJSKelvin || !conversion) {
        self.JSCurrentTemperature = [[[dict objectForKey:@"main"] objectForKey:@"temp"] floatValue];
        self.JSPossibleMaxTemperature = [[[dict objectForKey:@"main"] objectForKey:@"temp_max"] floatValue];
        self.JSPossibleMinTemperature = [[[dict objectForKey:@"main"] objectForKey:@"temp_min"] floatValue];
    } else if (conversion == kJSCelsius) {
        self.JSCurrentTemperature = ([[[dict objectForKey:@"main"] objectForKey:@"temp"] floatValue] - 273.15);
        self.JSPossibleMaxTemperature = ([[[dict objectForKey:@"main"] objectForKey:@"temp_max"] floatValue] - 273.15);
        self.JSPossibleMinTemperature = ([[[dict objectForKey:@"main"] objectForKey:@"temp_min"] floatValue] - 273.15);
    } else if (conversion == kJSFahrenheit) {
        self.JSCurrentTemperature = ([[[dict objectForKey:@"main"] objectForKey:@"temp"] floatValue] - 273.15) * 1.800 + 32.00;;
        self.JSPossibleMaxTemperature = ([[[dict objectForKey:@"main"] objectForKey:@"temp_max"] floatValue] - 273.15) * 1.800 + 32.00;
        self.JSPossibleMinTemperature = ([[[dict objectForKey:@"main"] objectForKey:@"temp_min"] floatValue] - 273.15) * 1.800 + 32.00;
    }
    
    self.JSRain = [[[dict objectForKey:@"rain"] objectForKey:@"3h"] floatValue];
    self.JSWeatherDescription = [[[[dict objectForKey:@"weather"] firstObject] objectForKey:@"description"] capitalizedString];
    self.JSWindDirection = [JSWeatherUtility handleWindDirection:[[[dict objectForKey:@"wind"] objectForKey:@"deg"] floatValue]];
    self.JSWindDirectionFloat = [[[dict objectForKey:@"wind"] objectForKey:@"deg"] floatValue];
    self.JSWindSpeed = [[[dict objectForKey:@"wind"] objectForKey:@"speed"] floatValue];
    self.objects = [NSDictionary dictionaryWithObjects:@[self.JSWeatherImage,
                                                         [NSString stringWithFormat:@"%f", self.JSCloudiness],
                                                         self.JSWeatherDate,
                                                         [NSString stringWithFormat:@"%f", self.JSGroundLevel],
                                                         [NSString stringWithFormat:@"%i", self.JSHumidity],
                                                         [NSString stringWithFormat:@"%f", self.JSPressure],
                                                         [NSString stringWithFormat:@"%f", self.JSSealevel],
                                                         [NSString stringWithFormat:@"%f", self.JSCurrentTemperature],
                                                         [NSString stringWithFormat:@"%f", self.JSPossibleMaxTemperature],
                                                         [NSString stringWithFormat:@"%f", self.JSPossibleMinTemperature],
                                                         [NSString stringWithFormat:@"%f", self.JSRain],
                                                         self.JSWeatherDescription,
                                                         self.JSWindDirection,
                                                         [NSString stringWithFormat:@"%f", self.JSWindDirectionFloat],
                                                         [NSString stringWithFormat:@"%f", self.JSWindSpeed]]
                                               forKeys:@[@"image",
                                                         @"cloudiness",
                                                         @"date",
                                                         @"ground_level",
                                                         @"humidity",
                                                         @"pressure",
                                                         @"sea_level",
                                                         @"current_temp",
                                                         @"max_temp",
                                                         @"min_temp",
                                                         @"percipitaton",
                                                         @"description",
                                                         @"wind_direction",
                                                         @"wind_direction_float",
                                                         @"wind_speed"]];
    return self;
}

/*
@property (nonatomic) float JSCloudiness;
@property (nonatomic) float JSGroundLevel;
@property (nonatomic) int JSHumidity;
@property (nonatomic) float JSPressure;
@property (nonatomic) float JSSealevel;
@property (nonatomic) float JSCurrentTemperature;
@property (nonatomic) float JSPossibleMaxTemperature;
@property (nonatomic) float JSPossibleMinTemperature;
@property (nonatomic) float JSRain;
@property (nonatomic) NSString *JSWeatherDescription;
@property (nonatomic) NSString *JSWindDirection;
@property (nonatomic) float JSWindSpeed;
*/
@end
