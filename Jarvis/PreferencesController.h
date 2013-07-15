//
//  PreferencesController.h
//  Jarvis
//
//  Created by Gabriel Ulici on 6/17/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "DBPrefsWindowController.h"

@interface PreferencesController : DBPrefsWindowController

@property (strong, nonatomic) IBOutlet NSView *generalPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *speechPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *timeAndDatePreferenceView;
@property (strong, nonatomic) IBOutlet NSView *icalAndRemaindersPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *weatherPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *emailPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *newsPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *quotationPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *updatePreferenceView;
@property (strong, nonatomic) IBOutlet NSTextField *updateDateField;
@property (strong, nonatomic) IBOutlet NSTextField *profileDateField;
@property (strong, nonatomic) IBOutlet NSTextField *locationField;
@property (strong, nonatomic) IBOutlet NSTextField *myLabel;
@property (assign) IBOutlet WebView *mapWebView;


// Weather

// Finds the WOEID code for the location that the user inputs
- (IBAction)findLocation:(id)sender;

@end
