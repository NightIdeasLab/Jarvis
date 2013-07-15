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
    NSString *text = [[NSString alloc] init];
    NSCalendarDate *date = [NSCalendarDate calendarDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if([date hourOfDay]<4) text = NSLocalizedString(@"Good night", @"Greeting in the night");
    else if([date hourOfDay]<12) text = NSLocalizedString(@"Good morning", @"Greeting in the morning");
    else if([date hourOfDay]<18) text = NSLocalizedString(@"Good afternoon", @"Greeting in the afternoon");
    else text = NSLocalizedString(@"Good evening", @"Greeting in the evening");
    
    //Reading the username
    // TODO: read this only if the user want it
    text = [text stringByAppendingString:@", "];
    text = [text stringByAppendingString: NSUserName()];
    text = [text stringByAppendingString:@". "];
    
    
    text = [text stringByAppendingString: NSLocalizedString(@"It is ", @"Declares the time. Ex. It is 19:30")];
    if([date minuteOfHour]<10)
        text = [text stringByAppendingString:[NSString stringWithFormat:@"%ld:0%ld.\n", [date hourOfDay], [date minuteOfHour]]];
    else
        text = [text stringByAppendingString:[NSString stringWithFormat:@"%ld:%ld.\n", [date hourOfDay], [date minuteOfHour]]];
    
    text = [text stringByAppendingString:NSLocalizedString(@"Today is ", @"Declares the day")];
    text = [text stringByAppendingString:[[dateFormatter standaloneMonthSymbols] objectAtIndex:[date monthOfYear]-1]];
    text = [text stringByAppendingString:[NSString stringWithFormat:@" %ld, ", [date dayOfMonth]]];
    text = [text stringByAppendingString:[[dateFormatter standaloneWeekdaySymbols] objectAtIndex:[date dayOfWeek]%7]];
    text = [text stringByAppendingString:@".\n\n"];
    
    return text;
    
}
@end
