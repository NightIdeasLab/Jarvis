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
    
}

#pragma mark -
#pragma mark Preference var
@property (strong, nonatomic) IBOutlet NSView *generalPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *speechPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *timeAndDatePreferenceView;
@property (strong, nonatomic) IBOutlet NSView *icalAndRemaindersPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *weatherPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *emailPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *newsPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *quotationPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *updatePreferenceView;

#pragma mark -
#pragma mark Update var
@property (strong, nonatomic) IBOutlet NSTextField *updateDateField;
@property (strong, nonatomic) IBOutlet NSTextField *profileDateField;

#pragma mark -
#pragma mark Weather var
@property (strong, nonatomic) IBOutlet NSTextField *locationField;
@property (assign) IBOutlet WebView *mapWebView;
@property (strong, atomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet NSTextField *locationLabel;
@property (assign) IBOutlet NSButton *findLocationButton;

@property (assign) IBOutlet NSButton *automaticLocationCheckBok;

// Weather

// Finds the WOEID code for the location that the user inputs

- (IBAction)changeStateAutomaticLocation:(id)sender;

- (IBAction)findLocation:(id)sender;

- (IBAction)openInDefaultBrowser:(id)sender;

@end
