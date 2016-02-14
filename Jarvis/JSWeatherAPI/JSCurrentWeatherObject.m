//
//  JSWeatherObject.m
//  JSWeatherAPI
//
//  Created by John Setting on 12/4/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//
//  Modified by Gabriel Ulici on 10/4/15.
//  Copyright (c) 2015 Night Ideas Lab. All rights reserved.
//

#import "JSCurrentWeatherObject.h"
#import "JSWeatherUtility.h"
#import "JSWeather.h"

@implementation JSCurrentWeatherObject

- (id)initWithData:(NSDictionary *)dict temperatureConversion:(NSInteger)conversion {
    if (!(self = [super init])) return nil;

    self.JSWeatherImage = [[[dict objectForKey:@"weather"] firstObject] objectForKey:@"icon"];
    self.JSLocationName = [dict objectForKey:@"name"];
    self.JSHumidity = [[[dict objectForKey:@"main"] objectForKey:@"humidity"] intValue];
    self.JSPressure = [[[dict objectForKey:@"main"] objectForKey:@"pressure"] intValue];
    self.JSCloudiness = [[[dict objectForKey:@"clouds"] objectForKey:@"all"] floatValue];

    if (conversion == kJSKelvin || !conversion) {
        self.JSCurrentTemperature = [[[dict objectForKey:@"main"] objectForKey:@"temp"] floatValue];
        self.JSTemporaryMaxTemperature = [[[dict objectForKey:@"main"] objectForKey:@"temp_max"] floatValue];
        self.JSTemporaryMinTemperature = [[[dict objectForKey:@"main"] objectForKey:@"temp_min"] floatValue];
    } else if (conversion == kJSCelsius) {
        self.JSCurrentTemperature = [[[dict objectForKey:@"main"] objectForKey:@"temp"] floatValue] - 273.15;
        self.JSTemporaryMaxTemperature = [[[dict objectForKey:@"main"] objectForKey:@"temp_max"] floatValue] - 273.15;
        self.JSTemporaryMinTemperature = [[[dict objectForKey:@"main"] objectForKey:@"temp_min"] floatValue] - 273.15;
    } else if (conversion == kJSFahrenheit) {
        self.JSCurrentTemperature = ([[[dict objectForKey:@"main"] objectForKey:@"temp"] floatValue] - 273.15) * 1.800 + 32.00;
        self.JSTemporaryMaxTemperature = ([[[dict objectForKey:@"main"] objectForKey:@"temp_max"] floatValue] - 273.15) * 1.800 + 32.00;
        self.JSTemporaryMinTemperature = ([[[dict objectForKey:@"main"] objectForKey:@"temp_min"] floatValue] - 273.15) * 1.800 + 32.00;
    }

    self.JSWeatherDescription = [[[[dict objectForKey:@"weather"] firstObject] objectForKey:@"description"] capitalizedString];
    self.JSWindDirection = [JSWeatherUtility handleWindDirection:[[[dict objectForKey:@"wind"] objectForKey:@"speed"] floatValue]];
    self.JSWindDirectionFloat = [[[dict objectForKey:@"wind"] objectForKey:@"speed"] floatValue];
    self.JSWindSpeed = [[[dict objectForKey:@"wind"] objectForKey:@"speed"] floatValue];
    self.JSLocationLatitude = [[[dict objectForKey:@"coord"] objectForKey:@"lat"] floatValue];
    self.JSLocationLongitude = [[[dict objectForKey:@"coord"] objectForKey:@"lon"] floatValue];
    self.JSSunriseDate = [NSDate dateWithTimeIntervalSince1970:[[[dict objectForKey:@"sys"] objectForKey:@"sunrise"] intValue]];
    self.JSSunsetDate = [NSDate dateWithTimeIntervalSince1970:[[[dict objectForKey:@"sys"] objectForKey:@"sunset"] intValue]];
    self.objects = [NSDictionary dictionaryWithObjects:@[self.JSWeatherImage,
                                                         self.JSLocationName,
                                                         [NSString stringWithFormat:@"%.0f", self.JSCloudiness],
                                                         [NSString stringWithFormat:@"%i", self.JSHumidity],
                                                         [NSString stringWithFormat:@"%i", self.JSPressure],
                                                         [NSString stringWithFormat:@"%.0f", self.JSCurrentTemperature],
                                                         [NSString stringWithFormat:@"%.0f", self.JSTemporaryMaxTemperature],
                                                         [NSString stringWithFormat:@"%.0f", self.JSTemporaryMinTemperature],
                                                         self.JSWeatherDescription,
                                                         self.JSWindDirection,
                                                         [NSString stringWithFormat:@"%.0f", self.JSWindDirectionFloat],
                                                         [NSString stringWithFormat:@"%.0f", self.JSWindSpeed],
                                                         [NSString stringWithFormat:@"%.0f", self.JSLocationLatitude],
                                                         [NSString stringWithFormat:@"%.0f", self.JSLocationLongitude],
                                                         self.JSSunriseDate,
                                                         self.JSSunsetDate]
                                               forKeys:@[@"image",
                                                         @"name",
                                                         @"cloudiness",
                                                         @"humidity",
                                                         @"pressure",
                                                         @"current_temp",
                                                         @"max_temp",
                                                         @"min_temp",
                                                         @"weather",
                                                         @"wind_direction",
                                                         @"wind_direction_float",
                                                         @"wind_speed",
                                                         @"location_latitude",
                                                         @"location_longitude",
                                                         @"sunrise_datetime",
                                                         @"sunset_datetime"]];
    return self;
}

- (id)initWithData:(NSDictionary *)dict {
    return [self initWithData:dict temperatureConversion:kJSKelvin];
}

@end