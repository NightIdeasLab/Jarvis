//
//  PreferencesController.h
//  Jarvis
//
//  Created by Gabriel Ulici on 6/17/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MapKit/MapKit.h>
#import "DBPrefsWindowController.h"

@class MKMapView;

@interface PreferencesController : DBPrefsWindowController < CLLocationManagerDelegate, MKMapViewDelegate, MKReverseGeocoderDelegate, MKGeocoderDelegate > {
    BOOL showsUserLocationApp;
}

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
#pragma mark General var
@property (assign) IBOutlet NSButton *readUserName;
@property (assign, nonatomic) IBOutlet NSTextField *customName;
@property (assign) IBOutlet NSButton *customNamePopUp;
@property (unsafe_unretained) IBOutlet NSPopUpButton *popUpNameButton;
@property (unsafe_unretained) IBOutlet NSPopUpButton *popUpTimeStyleButton;

#pragma mark -
#pragma mark Update var
@property (assign, nonatomic) IBOutlet NSTextField *updateDateField;
@property (assign, nonatomic) IBOutlet NSTextField *profileDateField;

#pragma mark -
#pragma mark Weather var
@property (unsafe_unretained) IBOutlet MKMapView *mapView;
@property (assign, nonatomic) IBOutlet NSTextField *locationField;
@property (assign, atomic) CLLocationManager *locationManager;
@property (assign, nonatomic) IBOutlet NSTextField *locationLabel;
@property (assign) IBOutlet NSButton *findLocationButton;
@property (unsafe_unretained) IBOutlet NSPopUpButton *popUpTemperatureButton;
@property (assign) IBOutlet NSButton *temperaturePopUp;

@property (assign) IBOutlet NSButton *automaticLocationCheckBox;
@property (unsafe_unretained) IBOutlet NSButton *forecastButton;

// General
- (IBAction)changeStateOfName:(id)sender;

- (IBAction)readUserName:(NSButton *)sender;

- (IBAction)readCustomName:(id)sender;

// Weather

// Finds the WOEID code for the location that the user inputs
- (IBAction)changeStateAutomaticLocation:(id)sender;

- (IBAction)findLocation:(id)sender;

- (IBAction)changeTemperatureStyle:(NSPopUpButton *)sender;

- (IBAction)changeTimeStyle:(NSPopUpButton *)sender;

- (IBAction)forecastYesOrNo:(id)sender;

@end
