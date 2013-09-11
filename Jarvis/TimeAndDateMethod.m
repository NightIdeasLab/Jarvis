//
//  TimeAndDateMethod.m
//  Jarvis
//
//  Created by Gabriel Ulici on 7/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "TimeAndDateMethod.h"

@implementation TimeAndDateMethod

- (NSString *) retriveTimeAndDate {
    
    // Time and date
    NSString *outputTimeAndDateText = [[NSString alloc] init];
    NSCalendarDate *date = [NSCalendarDate calendarDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if([date hourOfDay]<4) outputTimeAndDateText = NSLocalizedString(@"Good night", @"Greeting in the night");
    else if([date hourOfDay]<12) outputTimeAndDateText = NSLocalizedString(@"Good morning", @"Greeting in the morning");
    else if([date hourOfDay]<18) outputTimeAndDateText = NSLocalizedString(@"Good afternoon", @"Greeting in the afternoon");
    else outputTimeAndDateText = NSLocalizedString(@"Good evening", @"Greeting in the evening");
    
    //Reading the username
    // TODO: read this only if the user want it
    NSString *userName = NSUserName();
    //NSString *fullUserName = NSFullUserName();
    
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:@", "];
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString: userName];
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:@". "];
    
    
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString: NSLocalizedString(@"It is ", @"Declares the time. Ex. It is 19:30")];
    if([date minuteOfHour]<10)
        outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:[NSString stringWithFormat:@"%ld:0%ld.\n", [date hourOfDay], [date minuteOfHour]]];
    else
        outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:[NSString stringWithFormat:@"%ld:%ld.\n", [date hourOfDay], [date minuteOfHour]]];
    
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:NSLocalizedString(@"Today is ", @"Declares the day")];
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:[[dateFormatter standaloneMonthSymbols] objectAtIndex:[date monthOfYear]-1]];
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:[NSString stringWithFormat:@" %ld, ", [date dayOfMonth]]];
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:[[dateFormatter standaloneWeekdaySymbols] objectAtIndex:[date dayOfWeek]%7]];
    outputTimeAndDateText = [outputTimeAndDateText stringByAppendingString:@".\n\n"];
    
    
    return outputTimeAndDateText;
    
}
@end
