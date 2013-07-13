//
//  PreferencesController.m
//  Jarvis
//
//  Created by Gabriel Ulici on 6/17/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "PreferencesController.h"

@implementation PreferencesController

@synthesize generalPreferenceView = _generalPreferenceView;
@synthesize speechPreferenceView = _speechPreferenceView;
@synthesize timeAndDatePreferenceView = _timeAndDatePreferenceView;
@synthesize icalAndRemaindersPreferenceView = _icalAndRemaindersPreferenceView;
@synthesize weatherPreferenceView = _weatherPreferenceView;
@synthesize emailPreferenceView = _emailPreferenceView;
@synthesize newsPreferenceView = _newsPreferenceView;
@synthesize quotationPreferenceView = _quotationPreferenceView;
@synthesize updatePreferenceView = _updatePreferenceView;
@synthesize updateDateField;
@synthesize profileDateField;
@synthesize locationField;
@synthesize myLabel;

#pragma mark -
#pragma mark Class Methods

- (void)dealloc
{
    [updateDateField release];
    [profileDateField release];
    [locationField release];
    [myLabel release];
    [super dealloc];
}

- (void) awakeFromNib
{
    // reading from the plist file
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // retriving  the last update date and
    // last profile sent date from plist file
    NSDate *updateDate = [defaults objectForKey:@"SULastCheckTime"];
    NSDate *profileDate = [defaults objectForKey:@"SULastProfileSubmissionDate"];
    
    // checking and setting the last update date
    // and last profile sent date into the interface
    if ([profileDate.description length] > 0) {
        [updateDateField setObjectValue:updateDate];
    }
    else {
        [updateDateField setStringValue:NSLocalizedString(@"Never", @"Text that appears if there where no check for update")];
    }
    
    
    if ([profileDate.description length] > 0) {
        [profileDateField setObjectValue:profileDate];
    }
    else {
        [profileDateField setStringValue:NSLocalizedString(@"Never", @"Text that appears if there where not sent any profile data")];
    }
    
    [defaults release];
}

#pragma mark -
#pragma mark Configuration

- (void)setupToolbar{
    [self addView:self.generalPreferenceView label: NSLocalizedString(@"General", @"General Window title") image: [NSImage imageNamed: @"PrefGeneral"]];
    [self addView:self.weatherPreferenceView label: NSLocalizedString(@"Weather", @"Weather Window title") image: [NSImage imageNamed: @"PrefWeather"]];
    [self addView:self.updatePreferenceView label: NSLocalizedString(@"Update", @"Update Window title") image: [NSImage imageNamed: @"PrefUpdate"]];
    
    //[self addView:self.generalPreferenceView label:@"General" imageName:@"NSGeneral"];

    //[self addFlexibleSpacer]; //added a space between the icons
    
    // Optional configuration settings.
    [self setCrossFade:[[NSUserDefaults standardUserDefaults] boolForKey:@"fade"]];
    [self setShiftSlowsAnimation:[[NSUserDefaults standardUserDefaults] boolForKey:@"shiftSlowsAnimation"]];
}

#pragma mark -
#pragma mark Weather Methods

- (IBAction)findLocation:(id)sender {
    // retrives the City and Country
    NSString *locationText = [locationField stringValue];
    NSString *messageForLabel = [[NSString alloc] initWithFormat:NSLocalizedString(@"Your location is: %@", @"Message after the user inseted his location"), locationText];

    // separa NSString in mai single pointers
//    NSString *list = @"Norman, Stanley, Fletcher";
//    NSArray *listItems = [list componentsSeparatedByString:@", "];
    
    if ([locationText length] >0) {
        // Displays the user his location
        [myLabel setStringValue:messageForLabel];
    }
    else {
        // If the user will not write a city and country then we will display this message
        [myLabel setStringValue:NSLocalizedString(@"Please enter a City and Country.", @"Message that appeareas if the user did not inserted his location")];
    }
    
    [messageForLabel release];
    
//    if (!firstLaunch) {
//        
//        [fDefaults setInteger:721943 forKey: @"LocationCode"];
//    }
    
    
}
@end
