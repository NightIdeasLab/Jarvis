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

@interface PreferencesController : DBPrefsWindowController < CLLocationManagerDelegate >

#pragma mark -
#pragma mark Preference var
@property (assign, nonatomic) IBOutlet NSView *generalPreferenceView;
@property (assign, nonatomic) IBOutlet NSView *speechPreferenceView;
@property (assign, nonatomic) IBOutlet NSView *timeAndDatePreferenceView;
@property (assign, nonatomic) IBOutlet NSView *icalAndRemaindersPreferenceView;
@property (assign, nonatomic) IBOutlet NSView *weatherPreferenceView;
@property (assign, nonatomic) IBOutlet NSView *emailPreferenceView;
@property (assign, nonatomic) IBOutlet NSView *newsPreferenceView;
@property (assign, nonatomic) IBOutlet NSView *quotationPreferenceView;
@property (assign, nonatomic) IBOutlet NSView *updatePreferenceView;

#pragma mark -
#pragma mark Update var
@property (assign, nonatomic) IBOutlet NSTextField *updateDateField;
@property (assign, nonatomic) IBOutlet NSTextField *profileDateField;

#pragma mark -
#pragma mark Weather var
@property (assign, nonatomic) IBOutlet NSTextField *locationField;
@property (assign) IBOutlet WebView *mapWebView;
@property (assign, atomic) CLLocationManager *locationManager;
@property (assign, nonatomic) IBOutlet NSTextField *locationLabel;
@property (assign) IBOutlet NSButton *findLocationButton;

@property (assign) IBOutlet NSButton *automaticLocationCheckBok;

// Weather

// Finds the WOEID code for the location that the user inputs

- (IBAction)changeStateAutomaticLocation:(id)sender;

- (IBAction)findLocation:(id)sender;

- (IBAction)openInDefaultBrowser:(id)sender;


@end
