//
//  JSWeatherUtility.h
//  JSWeatherAPI
//
//  Created by John Setting on 12/4/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//
//  Modified by Gabriel Ulici on 10/4/15.
//  Copyright (c) 2015 Night Ideas Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSWeatherUtility : NSObject

/*!
 @asbtract Converts a given direction (0 - 360) to a string (N,NWN, E, etc.)
 @discusson Refered to link : http://www.climate.umn.edu/snow_fence/components/winddirectionanddegreeswithouttable3.htm
 */
+ (NSString *)handleWindDirection:(float)dir;

@end