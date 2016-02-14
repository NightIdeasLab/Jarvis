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
// for rss
#import "NSString+English.h"
#import "NSURLRequest+Authorization.h"
#import "SMWebRequest/SMWebRequest.h"
#import "Hpple/TFHpple.h"
#import "Feed.h"

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
@property (unsafe_unretained) IBOutlet NSButton *iCalButton;
@property (unsafe_unretained) IBOutlet NSButton *weatherButton;
@property (unsafe_unretained) IBOutlet NSButton *mailButton;
@property (unsafe_unretained) IBOutlet NSButton *newsButton;

#pragma mark -
#pragma mark Mail var
@property (unsafe_unretained) IBOutlet NSTextField *nameVIP1;
@property (unsafe_unretained) IBOutlet NSTextField *emailVIP1;
@property (unsafe_unretained) IBOutlet NSTextField *nameVIP2;
@property (unsafe_unretained) IBOutlet NSTextField *emailVIP2;
@property (unsafe_unretained) IBOutlet NSTextField *nameVIP3;
@property (unsafe_unretained) IBOutlet NSTextField *emailVIP3;
@property (unsafe_unretained) IBOutlet NSTextField *nameVIP4;
@property (unsafe_unretained) IBOutlet NSTextField *emailVIP4;
@property (unsafe_unretained) IBOutlet NSButton *saveButton;

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

#pragma mark -
#pragma mark News&Quotes var
@property (nonatomic, copy) NSArray *feeds;
@property (nonatomic, strong) SMWebRequest *request, *tokenRequest;
@property (weak) IBOutlet NSTextField *newsLink;
@property (weak) IBOutlet NSTextField *newsLinkOutput;
@property (weak) IBOutlet NSImageView *newsLinkOutputImage;
@property (weak) IBOutlet NSProgressIndicator *newsLinkOutputProgress;

#pragma mark -
#pragma mark Update var
@property (assign, nonatomic) IBOutlet NSTextField *updateDateField;
@property (assign, nonatomic) IBOutlet NSTextField *profileDateField;

// General
- (IBAction)changeStateOfName:(id)sender;
- (IBAction)readUserName:(NSButton *)sender;
- (IBAction)readCustomName:(id)sender;
- (IBAction)changeStateServices:(id)sender;

// Mail
- (IBAction)saveVips:(id)sender;

// Weather
// Finds the WOEID code for the location that the user inputs
- (IBAction)changeStateAutomaticLocation:(id)sender;
- (IBAction)findLocation:(id)sender;
- (IBAction)changeTemperatureStyle:(NSPopUpButton *)sender;
- (IBAction)changeTimeStyle:(NSPopUpButton *)sender;
- (IBAction)forecastYesOrNo:(id)sender;
- (IBAction)newsLinkChange:(id)sender;
- (void)validationDidFailWithMessage:(NSString *)message;

@end