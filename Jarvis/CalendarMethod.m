//
//  CalendarMethod.m
//  Jarvis
//
//  Created by Gabriel Ulici on 7/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "CalendarMethod.h"

@implementation CalendarMethod

- (NSString *) retriveiCalEvents {
    
    // iCal events
    NSString *text = [[NSString alloc] init];
    NSCalendarDate *date = [NSCalendarDate calendarDate];
    NSCalendarDate *endDate = [[NSCalendarDate dateWithYear:[date yearOfCommonEra] month:[date monthOfYear] day:[date dayOfMonth] hour:23 minute:59 second:59 timeZone:nil] retain];
    NSPredicate *predicate = [CalCalendarStore eventPredicateWithStartDate:date endDate:endDate calendars:[[CalCalendarStore defaultCalendarStore] calendars]];
    NSArray *events = [[CalCalendarStore defaultCalendarStore] eventsWithPredicate:predicate];
    if ([events count] == 0)
    {
        text = [text stringByAppendingString:NSLocalizedString(@"You do not have any apoiments today!!!\n\n", @"This message will appear if you do not have any apoiments")];
    }
    else
    {
        for(int i=0; i<[events count]; i++)
        {
            if([[events objectAtIndex:i] isAllDay])
            {
                text = [text stringByAppendingString:NSLocalizedString(@"There is, ", @"")];
                text = [text stringByAppendingString:[[events objectAtIndex:i] title]];
                text = [text stringByAppendingString:NSLocalizedString(@", all day", @"")];
            }
            else
            {
                text = [text stringByAppendingString:NSLocalizedString(@"There is, ", @"")];
                text = [text stringByAppendingString:[[events objectAtIndex:i] title]];
                text = [text stringByAppendingString:NSLocalizedString(@", at ", @"")];
                NSCalendarDate *eventDate = [[[events objectAtIndex:i] startDate] dateWithCalendarFormat:nil timeZone:nil];
                if([eventDate minuteOfHour]<10)
                    text = [text stringByAppendingString:[NSString stringWithFormat:@"%ld:0%ld", [eventDate hourOfDay], [eventDate minuteOfHour]]];
                else
                    text = [text stringByAppendingString:[NSString stringWithFormat:@"%ld:%ld", [eventDate hourOfDay], [eventDate minuteOfHour]]];
            }
            text = [text stringByAppendingString:@"\n\n"]; // Added double spaces for formating reasons
        }
    }
    
    [text autorelease];
    return text;
    
}

- (NSString *) retriveReminders {
    
    // iCal Reminders
    NSString *text = [[NSString alloc] init];
    NSPredicate *predicate = [CalCalendarStore taskPredicateWithCalendars:[[CalCalendarStore defaultCalendarStore] calendars]];
    NSArray *tasks = [[CalCalendarStore defaultCalendarStore] tasksWithPredicate:predicate];
    if ([tasks count] == 0)
    {
        text = [text stringByAppendingString:NSLocalizedString(@"You do not have any reminders today!!!\n", @"")];
    }
    else
    {
        for(int i=0; i<[tasks count]; i++)
        {
            text = [text stringByAppendingString:NSLocalizedString(@"You need to ", @"")];
            text = [text stringByAppendingString:[[tasks objectAtIndex:i] title]];
            text = [text stringByAppendingString:@".\n"];
        }
    }
    
    [text autorelease];
    return text;
    
}

@end
