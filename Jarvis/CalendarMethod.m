//
//  CalendarMethod.m
//  Jarvis
//
//  Created by Gabriel Ulici on 7/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "CalendarMethod.h"

@implementation CalendarMethod

- (NSString *) retrieveiCalEvents {
    // iCal events
    NSString *outputCalendarText = [[NSString alloc] init];
    NSCalendarDate *date = [NSCalendarDate calendarDate];
    NSCalendarDate *endDate = [NSCalendarDate dateWithYear:[date yearOfCommonEra] month:[date monthOfYear] day:[date dayOfMonth] hour:23 minute:59 second:59 timeZone:nil];
    NSPredicate *predicate = [CalCalendarStore eventPredicateWithStartDate:date endDate:endDate calendars:[[CalCalendarStore defaultCalendarStore] calendars]];
    NSArray *events = [[CalCalendarStore defaultCalendarStore] eventsWithPredicate:predicate];
    if ([events count] == 0) {
        outputCalendarText = [outputCalendarText stringByAppendingString:NSLocalizedString(@"\nYou have no events scheduled for today!\n", @"This message will appear if the user does not have any events today")];
    } else {
        unsigned long eventsCount = [events count];
        if (eventsCount==1) outputCalendarText = [outputCalendarText stringByAppendingString:NSLocalizedString(@"\nYou have one event today:\n", @"This message will appear if you have only one event.")];
        else if (eventsCount>1) outputCalendarText = [outputCalendarText stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"\nYou have %ld events today:\n", @""), eventsCount]];

        for (int i=0; i<eventsCount; i++) {
            if ([[events objectAtIndex:i] isAllDay]) {
                outputCalendarText = [outputCalendarText stringByAppendingString:NSLocalizedString(@"All day ", @"")];
                outputCalendarText = [outputCalendarText stringByAppendingString:[[events objectAtIndex:i] title]];
                // if the title has a dot at the end
                if(![[[events objectAtIndex:i] title] hasSuffix:@"."])
                    outputCalendarText = [outputCalendarText stringByAppendingString:NSLocalizedString(@".", @"")];
            } else {
                NSCalendarDate *eventDate = [[[events objectAtIndex:i] startDate] dateWithCalendarFormat:nil timeZone:nil];
                outputCalendarText = [outputCalendarText stringByAppendingString:NSLocalizedString(@"At ", @"")];
                if ([eventDate minuteOfHour]<10) outputCalendarText = [outputCalendarText stringByAppendingString:[NSString stringWithFormat:@"%ld:0%ld", [eventDate hourOfDay], [eventDate minuteOfHour]]];
                else outputCalendarText = [outputCalendarText stringByAppendingString:[NSString stringWithFormat:@"%ld:%ld", [eventDate hourOfDay], [eventDate minuteOfHour]]];
                outputCalendarText = [outputCalendarText stringByAppendingString:NSLocalizedString(@" there is ", @"")];
                outputCalendarText = [outputCalendarText stringByAppendingString:[[events objectAtIndex:i] title]];
                // if the title has a dot at the end
                if(![[[events objectAtIndex:i] title] hasSuffix:@"."])
                    outputCalendarText = [outputCalendarText stringByAppendingString:NSLocalizedString(@".", @"")];
            }
            outputCalendarText = [outputCalendarText stringByAppendingString:@"\n"];
        }
    }
    return outputCalendarText;
}

- (NSString *) retrieveReminders {
    // Reminders
    NSString *outputRemindersText = [[NSString alloc] init];
    NSPredicate *predicate = [CalCalendarStore taskPredicateWithCalendars:[[CalCalendarStore defaultCalendarStore] calendars]];
    NSArray *tasks = [[CalCalendarStore defaultCalendarStore] tasksWithPredicate:predicate];
    if ([tasks count] == 0) {
        outputRemindersText = [outputRemindersText stringByAppendingString:NSLocalizedString(@"\nYou have no reminders scheduled for today!\n", @"")];
    } else {
        // TODO: add the priority when Apple fix the naming
        for(int i=0; i<[tasks count]; i++) {
            if (![[tasks objectAtIndex:i] completedDate]) {
                outputRemindersText = [outputRemindersText stringByAppendingString:NSLocalizedString(@"\nYou need to ", @"")];
                outputRemindersText = [outputRemindersText stringByAppendingString:[[tasks objectAtIndex:i] title]];

                if ([[tasks objectAtIndex:i] notes]) {
                    // if the title has a dot at the end
                    if(![[[tasks objectAtIndex:i] title] hasSuffix:@"."])
                        outputRemindersText = [outputRemindersText stringByAppendingString:NSLocalizedString(@",", @"")];
                    
                    outputRemindersText = [outputRemindersText stringByAppendingString:NSLocalizedString(@" note for reminder: ", @"")];
                    outputRemindersText = [outputRemindersText stringByAppendingString:[[tasks objectAtIndex:i] notes]];
                    // if the title has a dot at the end
                    if(![[[tasks objectAtIndex:i] notes] hasSuffix:@"."])
                        outputRemindersText = [outputRemindersText stringByAppendingString:NSLocalizedString(@".", @"")];
                } else {
                    // if the title has a dot at the end
                    if(![[[tasks objectAtIndex:i] title] hasSuffix:@"."])
                        outputRemindersText = [outputRemindersText stringByAppendingString:NSLocalizedString(@".", @"")];
                }
            }
        }
        outputRemindersText = [outputRemindersText stringByAppendingString:@"\n"];
    }
    return outputRemindersText;
}

@end