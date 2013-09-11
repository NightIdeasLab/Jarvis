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
    NSString *outputCalendarText = [[NSString alloc] init];
    NSCalendarDate *date = [NSCalendarDate calendarDate];
    NSCalendarDate *endDate = [NSCalendarDate dateWithYear:[date yearOfCommonEra] month:[date monthOfYear] day:[date dayOfMonth] hour:23 minute:59 second:59 timeZone:nil];
    NSPredicate *predicate = [CalCalendarStore eventPredicateWithStartDate:date endDate:endDate calendars:[[CalCalendarStore defaultCalendarStore] calendars]];
    NSArray *events = [[CalCalendarStore defaultCalendarStore] eventsWithPredicate:predicate];
    if ([events count] == 0)
    {
        outputCalendarText = [outputCalendarText stringByAppendingString:NSLocalizedString(@"You do not have any apoiments today!!!\n\n", @"This message will appear if you do not have any apoiments")];
    }
    else
    {
        for(int i=0; i<[events count]; i++)
        {
            if([[events objectAtIndex:i] isAllDay])
            {
                outputCalendarText = [outputCalendarText stringByAppendingString:NSLocalizedString(@"There is, ", @"")];
                outputCalendarText = [outputCalendarText stringByAppendingString:[[events objectAtIndex:i] title]];
                outputCalendarText = [outputCalendarText stringByAppendingString:NSLocalizedString(@", all day", @"")];
            }
            else
            {
                outputCalendarText = [outputCalendarText stringByAppendingString:NSLocalizedString(@"There is, ", @"")];
                outputCalendarText = [outputCalendarText stringByAppendingString:[[events objectAtIndex:i] title]];
                outputCalendarText = [outputCalendarText stringByAppendingString:NSLocalizedString(@", at ", @"")];
                NSCalendarDate *eventDate = [[[events objectAtIndex:i] startDate] dateWithCalendarFormat:nil timeZone:nil];
                if([eventDate minuteOfHour]<10)
                    outputCalendarText = [outputCalendarText stringByAppendingString:[NSString stringWithFormat:@"%ld:0%ld", [eventDate hourOfDay], [eventDate minuteOfHour]]];
                else
                    outputCalendarText = [outputCalendarText stringByAppendingString:[NSString stringWithFormat:@"%ld:%ld", [eventDate hourOfDay], [eventDate minuteOfHour]]];
            }
            outputCalendarText = [outputCalendarText stringByAppendingString:@"\n\n"]; // Added double spaces for formating reasons
        }
    }
    

    return outputCalendarText;
    
}

- (NSString *) retriveReminders {
    
    // Reminders
    NSString *outputRemindersText = [[NSString alloc] init];
    NSPredicate *predicate = [CalCalendarStore taskPredicateWithCalendars:[[CalCalendarStore defaultCalendarStore] calendars]];
    NSArray *tasks = [[CalCalendarStore defaultCalendarStore] tasksWithPredicate:predicate];
    if ([tasks count] == 0)
    {
        outputRemindersText = [outputRemindersText stringByAppendingString:NSLocalizedString(@"You do not have any reminders today!!!\n", @"")];
    }
    else
    {
        for(int i=0; i<[tasks count]; i++)
        {
            outputRemindersText = [outputRemindersText stringByAppendingString:NSLocalizedString(@"You need to ", @"")];
            outputRemindersText = [outputRemindersText stringByAppendingString:[[tasks objectAtIndex:i] title]];
            outputRemindersText = [outputRemindersText stringByAppendingString:@".\n"];
        }
    }
    
    return outputRemindersText;
    
}

@end
