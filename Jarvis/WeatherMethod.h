//
//  WeatherMethod.h
//  Jarvis
//
//  Created by Gabriel Ulici on 7/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSWeather.h"

@interface WeatherMethod : NSObject <JSWeatherDelegate>


//- (NSString *) retrieveWeather;
-(NSDictionary *) retrieveWeather;

@end
