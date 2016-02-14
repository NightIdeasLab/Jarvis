//
//  TimeAndDateMethod.m
//  Jarvis
//
//  Created by Gabriel Ulici on 7/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "TimeAndDateMethod.h"

@implementation TimeAndDateMethod

- (NSString *) retrieveTimeAndDate {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // Time and date
    NSString *outputTimeAndDateText = [[NSString alloc] init];
    NSCalendarDate *date = [NSCalendarDate calendarDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *userNameChoise = [defaults stringForKey: @"UserName"];
    NSString *timeStyle = [defaults stringForKey: @"TimeStyle"];
    NSString *userName = @"";
    if([date hourOfDay]<4) outputTimeAndDateText = NSLocalizedString(@"Good night", @"Greeting in the night");
    else if([date hourOfDay]<12) outputTimeAndDateText = NSLocalizedString(@"Good morning", @"Greeting in the morning");
    else if([date hourOfDay]<18) outputTimeAndDateText = NSLocalizedString(@"Good afternoon", @"Greeting in the afternoon");
    else outputTimeAndDateText = NSLocalizedString(@"Good evening", @"Greeting in the evening");

    if ([userNameChoise isNotEqualTo:@"None"]) {
        if ([userNameChoise isEqualToString:@"Short"]) {
            userName = NSUserName();
        } else if ([userNameChoise isEqualToString:@"Full"]) {
            userName = NSFullUserName();
        } else {
            userName = userNameChoise;
        }

        outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:@", "];
        outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString: userName];
    }
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:@". "];

    if ([timeStyle isEqualToString:@"24"]) {
        [dateFormatter setDateFormat:@"H:mm"]; // 24h style
    } else if ([timeStyle isEqualToString:@"am/pm"]) {
        [dateFormatter setDateFormat:@"h:mm a"];  // am/pm style
    }
	
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString: NSLocalizedString(@"The current time is ", @"Declares the time. Ex. It is 19:30")];

    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:[dateFormatter stringFromDate:[NSDate date]]];
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:@".\n"];
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:NSLocalizedString(@"Today is ", @"Declares the day")];
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:[[dateFormatter standaloneWeekdaySymbols] objectAtIndex:[date dayOfWeek]%7]];
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:@", "];
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:[[dateFormatter standaloneMonthSymbols] objectAtIndex:[date monthOfYear]-1]];
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:[NSString stringWithFormat:@" %ld", [date dayOfMonth]]];
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:@".\n"];

    return outputTimeAndDateText;
}

@end