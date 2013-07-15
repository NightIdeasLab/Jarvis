//
//  PreferencesController.h
//  Jarvis
//
//  Created by Gabriel Ulici on 6/17/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreLocation/CoreLocation.h>
#import <WebKit/WebKit.h>
#import "DBPrefsWindowController.h"

@interface PreferencesController : DBPrefsWindowController < CLLocationManagerDelegate > {
    CLLocationManager *locationManager;
}

#pragma -
#pragma Preference var
@property (strong, nonatomic) IBOutlet NSView *generalPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *speechPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *timeAndDatePreferenceView;
@property (strong, nonatomic) IBOutlet NSView *icalAndRemaindersPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *weatherPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *emailPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *newsPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *quotationPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *updatePreferenceView;

#pragma -
#pragma Update var
@property (strong, nonatomic) IBOutlet NSTextField *updateDateField;
@property (strong, nonatomic) IBOutlet NSTextField *profileDateField;

#pragma -
#pragma Weather var
@property (copy) NSString* identifier;
@property (strong, nonatomic) IBOutlet NSTextField *locationField;
@property (strong, nonatomic) IBOutlet NSTextField *myLabel;
@property (assign) IBOutlet WebView *mapWebView;
@property (strong, nonatomic) IBOutlet NSTextField *locationLabel;


// Weather

// Finds the WOEID code for the location that the user inputs
- (IBAction)findLocation:(id)sender;

- (IBAction)openInDefaultBrowser:(id)sender;

@end
