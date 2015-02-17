//
//  PreferencesController.m
//  Jarvis
//
//  Created by Gabriel Ulici on 6/17/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "PreferencesController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@implementation PreferencesController

// Preferences Toolbar
@synthesize generalPreferenceView = _generalPreferenceView;
@synthesize speechPreferenceView = _speechPreferenceView;
@synthesize timeAndDatePreferenceView = _timeAndDatePreferenceView;
@synthesize icalAndRemaindersPreferenceView = _icalAndRemaindersPreferenceView;
@synthesize weatherPreferenceView = _weatherPreferenceView;
@synthesize emailPreferenceView = _emailPreferenceView;
@synthesize newsPreferenceView = _newsPreferenceView;
@synthesize quotationPreferenceView = _quotationPreferenceView;
@synthesize updatePreferenceView = _updatePreferenceView;

// General
@synthesize readUserName;
@synthesize customNamePopUp;
@synthesize customName;
@synthesize popUpNameButton;
@synthesize popUpTimeStyleButton;

// Service button
@synthesize iCalButton;
@synthesize weatherButton;
@synthesize mailButton;
@synthesize newsButton;

// Mail
@synthesize nameVIP1;
@synthesize emailVIP1;
@synthesize nameVIP2;
@synthesize emailVIP2;
@synthesize nameVIP3;
@synthesize emailVIP3;
@synthesize nameVIP4;
@synthesize emailVIP4;
@synthesize saveButton;
// Weather
@synthesize mapView;
@synthesize locationField;
@synthesize locationManager;
@synthesize locationLabel;
@synthesize findLocationButton;
@synthesize automaticLocationCheckBox;
@synthesize temperaturePopUp;
@synthesize popUpTemperatureButton;
@synthesize forecastButton;

// Update
@synthesize updateDateField;
@synthesize profileDateField;

#pragma mark -
#pragma mark Class Methods

- (void) awakeFromNib {
	// reading from the plist file
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
	// retriving the last update date and
	// last profile sent date from plist file
	NSDate *updateDate = [defaults objectForKey:@"SULastCheckTime"];
	NSDate *profileDate = [defaults objectForKey:@"SULastProfileSubmissionDate"];

    BOOL useCal = [defaults boolForKey:@"UseCal"];
    BOOL useWeather = [defaults boolForKey:@"UseWeather"];
    BOOL useMail = [defaults boolForKey:@"UseMail"];
    BOOL useNewsQuotes = [defaults boolForKey:@"UseNewsQuotes"];
    
	// checking and setting the last update date
	// and last profile sent date into the interface
	if ([updateDate.description length] > 0) {
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

	if ([defaults boolForKey: @"ReadUserName"]) {
		[readUserName setState:1];

		[self changeStateOfName:self];

		NSString *userNameState = [defaults stringForKey: @"UserName"];
		BOOL forecastState = [defaults boolForKey:@"ForecastWeather"];
		
		if ([userNameState isEqualToString:@"Short"]) {
			[popUpNameButton selectItemAtIndex:0];
			[customName setEnabled:NO];
		} else if ([userNameState isEqualToString:@"Full"]) {
			[popUpNameButton selectItemAtIndex:1];
			[customName setEnabled:NO];
		} else {
			[popUpNameButton selectItemAtIndex:2];
			[customName setEnabled:YES];
			[customName setStringValue:userNameState];
		}

		if (forecastState == YES) {
			[forecastButton setState:1];
		} else {
			[forecastButton setState:0];
		}
	} else {
		[readUserName setState:0];
		[self changeStateOfName:self];
	}
    
    if (useCal == YES) {
        [iCalButton setState:1];
    } else {
        [iCalButton setState:0];
    }
    if (useWeather == YES) {
        [weatherButton setState:1];
    } else {
        [weatherButton setState:0];
    }
    if (useMail == YES) {
        [mailButton setState:1];
        // setting the VIPs name and email addresses
        if ([defaults objectForKey:@"emailVIP1"] != NULL) [emailVIP1 setStringValue:[defaults objectForKey:@"emailVIP1"]];
        if ([defaults objectForKey:@"nameVIP1"] != NULL) [nameVIP1 setStringValue:[defaults objectForKey:@"nameVIP1"]];
        if ([defaults objectForKey:@"emailVIP2"] != NULL) [emailVIP2 setStringValue:[defaults objectForKey:@"emailVIP2"]];
        if ([defaults objectForKey:@"nameVIP2"] != NULL) [nameVIP2 setStringValue:[defaults objectForKey:@"nameVIP2"]];
        if ([defaults objectForKey:@"emailVIP3"] != NULL) [emailVIP3 setStringValue:[defaults objectForKey:@"emailVIP3"]];
        if ([defaults objectForKey:@"nameVIP3"] != NULL) [nameVIP3 setStringValue:[defaults objectForKey:@"nameVIP3"]];
        if ([defaults objectForKey:@"emailVIP4"] != NULL) [emailVIP4 setStringValue:[defaults objectForKey:@"emailVIP4"]];
        if ([defaults objectForKey:@"nameVIP4"] != NULL) [nameVIP4 setStringValue:[defaults objectForKey:@"nameVIP4"]];
    } else {
        [mailButton setState:0];
        [emailVIP1 setEnabled:NO];
        [emailVIP2 setEnabled:NO];
        [emailVIP3 setEnabled:NO];
        [emailVIP4 setEnabled:NO];
        [nameVIP1 setEnabled:NO];
        [nameVIP2 setEnabled:NO];
        [nameVIP3 setEnabled:NO];
        [nameVIP4 setEnabled:NO];
    }
    if (useNewsQuotes == YES) {
        [newsButton setState:1];
    } else {
        [newsButton setState:0];
    }
    
    [mapView setShowsUserLocation: YES];
    [mapView setDelegate: self];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 49.8578255;
    coordinate.longitude = -97.16531639999999;
    MKReverseGeocoder *reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate: coordinate];
    reverseGeocoder.delegate = self;
    [reverseGeocoder start];
    
}

#pragma mark -
#pragma mark Toolbar Configuration

- (void)setupToolbar{
	[self addView:self.generalPreferenceView label: NSLocalizedString(@"General", @"General Window title")
			image: [NSImage imageNamed:@"PrefGeneral"]];
    [self addView:self.emailPreferenceView label: NSLocalizedString(@"Email & VIP", @"Email & VIP Window title")
			image: [NSImage imageNamed:@"PrefAccount"]];
	[self addView:self.weatherPreferenceView label: NSLocalizedString(@"Weather", @"Weather Window title")
			image: [NSImage imageNamed:@"PrefWeather"]];
    [self addView:self.updatePreferenceView label: NSLocalizedString(@"Update", @"Update Window title")
			image: [NSImage imageNamed:@"PrefUpdate"]];
    
	//[self addView:self.generalPreferenceView label:@"General" imageName:@"NSGeneral"];

	//[self addFlexibleSpacer]; //added a space between the icons

	// Optional configuration settings.
	[self setCrossFade:[[NSUserDefaults standardUserDefaults] boolForKey:@"fade"]];
	[self setShiftSlowsAnimation:[[NSUserDefaults standardUserDefaults] boolForKey:@"shiftSlowsAnimation"]];
}

#pragma mark -
#pragma mark General Methods

- (IBAction)changeStateOfName:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if ([readUserName state] == 1) {
		[customNamePopUp setEnabled:YES];
		[defaults setBool:YES forKey: @"ReadUserName"];
		[popUpNameButton selectItemAtIndex:0];
    } else {
		[customName setEnabled:NO];
		[customNamePopUp setEnabled:NO];
		[defaults setBool:NO forKey: @"ReadUserName"];
		if ([[defaults stringForKey:@"UserName"] isNotEqualTo:@"None"]) {
			[defaults setObject:@"None" forKey: @"UserName"];
		}
    }
    [defaults synchronize];
}

- (IBAction)readUserName:(NSButton *)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger indexOfPopUp = [popUpNameButton indexOfSelectedItem];
    
	if (indexOfPopUp == 0 ) {
		[defaults setObject:@"Short" forKey: @"UserName"];
		[customName setEnabled:NO];
		[customName setStringValue:@""];
	} else if (indexOfPopUp == 1 ) {
		[defaults setObject:@"Full" forKey: @"UserName"];
		[customName setEnabled:NO];
		[customName setStringValue:@""];
	} else if (indexOfPopUp == 2) {
		[customName setEnabled:YES];
	}
    [defaults synchronize];
}

- (IBAction)readCustomName:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
	NSString *customNameText = [customName stringValue];
    
	if ([customNameText length] >0) {
		[defaults setObject:customNameText forKey: @"UserName"];
	}
    [defaults synchronize];
}

- (IBAction)changeStateServices:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([sender tag] == 1) {
        if ([sender state]==NSOffState){
            [defaults setBool:NO forKey: @"UseCal"];
        } else if ([sender state]==NSOnState){
            [defaults setBool:YES forKey: @"UseCal"];
        }
    } else if ([sender tag] == 2) {
        if ([sender state]==NSOffState){
            [defaults setBool:NO forKey: @"UseWeather"];
        } else if ([sender state]==NSOnState){
            [defaults setBool:YES forKey: @"UseWeather"];
        }
    } else if ([sender tag] == 3) {
        if ([sender state]==NSOffState){
            [defaults setBool:NO forKey: @"UseMail"];
        } else if ([sender state]==NSOnState){
            [defaults setBool:YES forKey: @"UseMail"];
        }
    } else if ([sender tag] == 4) {
        if ([sender state]==NSOffState){
            [defaults setBool:NO forKey: @"UseNewsQuotes"];
        } else if ([sender state]==NSOnState){
            [defaults setBool:YES forKey: @"UseNewsQuotes"];
        }
    }
    [defaults synchronize];
}

#pragma mark -
#pragma mark Mail Methods

- (IBAction)saveVips:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([[emailVIP1 stringValue] length] > 0) [defaults setObject:[emailVIP1 stringValue] forKey: @"emailVIP1"];
    if ([[nameVIP1 stringValue] length] > 0) [defaults setObject:[nameVIP1 stringValue] forKey: @"nameVIP1"];
    if ([[emailVIP2 stringValue] length] > 0) [defaults setObject:[emailVIP2 stringValue] forKey: @"emailVIP2"];
    if ([[nameVIP2 stringValue] length] > 0) [defaults setObject:[nameVIP2 stringValue] forKey: @"nameVIP2"];
    if ([[emailVIP3 stringValue] length] > 0) [defaults setObject:[emailVIP3 stringValue] forKey: @"emailVIP3"];
    if ([[nameVIP3 stringValue] length] > 0) [defaults setObject:[nameVIP3 stringValue] forKey: @"nameVIP3"];
    if ([[emailVIP4 stringValue] length] > 0) [defaults setObject:[emailVIP4 stringValue] forKey: @"emailVIP4"];
    if ([[nameVIP4 stringValue] length] > 0) [defaults setObject:[nameVIP4 stringValue] forKey: @"nameVIP4"];
    
    [saveButton setTitle:NSLocalizedString(@"Saved", @"Text that appears if the save button was pressed")];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [saveButton setTitle:NSLocalizedString(@"Save", @"Text that appears if the save button was not pressed")];
    });
    [defaults synchronize];
}

#pragma mark -
#pragma mark Weather Methods

#pragma mark -
#pragma mark WOIED

- (IBAction)findLocation:(id)sender {
	// retrieves the City and Country
	NSString *locationText = [locationField stringValue];
	NSString *messageForLabel = [[NSString alloc] initWithFormat:NSLocalizedString(@"Your location is: %@", @"Message after the user inseted his location"), locationText];

	if ([locationText length] >0) {
		// Displays the user his location
		[locationLabel setStringValue:messageForLabel];
	}
	else {
		// If the user will not write a city and country then we will display this message
		[locationLabel setStringValue:NSLocalizedString(@"Please enter a City and Country.", @"Message that appeareas if the user did not inserted his location")];
	}
}

- (IBAction)changeStateAutomaticLocation:(id)sender {

    if ([automaticLocationCheckBox state] == 1) {
        [locationField setEnabled:NO];
        [findLocationButton setEnabled:NO];

    } else {
        [locationField setEnabled:YES];
        [findLocationButton setEnabled:YES];
    }

}

- (IBAction)changeTemperatureStyle:(NSPopUpButton *)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger indexOfTemperaturePopUp = [popUpTemperatureButton indexOfSelectedItem];

	if (indexOfTemperaturePopUp == 0 ) {
		[defaults setObject:@"c" forKey: @"TemperatureStyle"];
	} else if (indexOfTemperaturePopUp == 1 ) {
		[defaults setObject:@"f" forKey: @"TemperatureStyle"];
	}
    [defaults synchronize];
}

- (IBAction)changeTimeStyle:(NSPopUpButton *)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger indexOfTimePopUp = [popUpTimeStyleButton indexOfSelectedItem];

	if (indexOfTimePopUp == 0 ) {
		[defaults setObject:@"24" forKey: @"TimeStyle"];
	} else if (indexOfTimePopUp == 1 ) {
		[defaults setObject:@"am/pm" forKey: @"TimeStyle"];
	}
    [defaults synchronize];
}

- (IBAction)forecastYesOrNo:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	if ([forecastButton state] == 1) {
		[defaults setBool:YES forKey: @"ForecastWeather"];
	} else {
		[defaults setBool:NO forKey: @"ForecastWeather"];
	}
	[defaults synchronize];
}


#pragma mark MKReverseGeocoderDelegate

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    //NSLog(@"found placemark: %@", placemark);
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    //NSLog(@"MKReverseGeocoder didFailWithError: %@", error);
}

#pragma mark MKGeocoderDelegate

- (void)geocoder:(MKGeocoder *)geocoder didFindCoordinate:(CLLocationCoordinate2D)coordinate
{
    //NSLog(@"MKGeocoder found (%f, %f) for %@", coordinate.latitude, coordinate.longitude, geocoder.address);
}

- (void)geocoder:(MKGeocoder *)geocoder didFailWithError:(NSError *)error
{
    //NSLog(@"MKGeocoder didFailWithError: %@", error);
}

#pragma mark MapView Delegate

// Responding to Map Position Changes

- (void)mapView:(MKMapView *)aMapView regionWillChangeAnimated:(BOOL)animated
{
    //NSLog(@"mapView: %@ regionWillChangeAnimated: %d", aMapView, animated);
}

- (void)mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated
{
    //NSLog(@"mapView: %@ regionDidChangeAnimated: %d", aMapView, animated);
}

//Loading the Map Data
- (void)mapViewWillStartLoadingMap:(MKMapView *)aMapView
{
    //NSLog(@"mapViewWillStartLoadingMap: %@", aMapView);
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)aMapView
{
    //NSLog(@"mapViewDidFinishLoadingMap: %@", aMapView);
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)aMapView withError:(NSError *)error
{
    //NSLog(@"mapViewDidFailLoadingMap: %@ withError: %@", aMapView, error);
}

// Tracking the User Location
- (void)mapViewWillStartLocatingUser:(MKMapView *)aMapView
{
    //NSLog(@"mapViewWillStartLocatingUser: %@", aMapView);
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)aMapView
{
    //NSLog(@"mapViewDidStopLocatingUser: %@", aMapView);
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //NSLog(@"mapView: %@ didUpdateUserLocation: %@", aMapView, userLocation);
}

- (void)mapView:(MKMapView *)aMapView didFailToLocateUserWithError:(NSError *)error
{
    // NSLog(@"mapView: %@ didFailToLocateUserWithError: %@", aMapView, error);
}

// Managing Annotation Views


- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    //NSLog(@"mapView: %@ viewForAnnotation: %@", aMapView, annotation);
    //MKAnnotationView *view = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"blah"] autorelease];
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"blah"];
    view.draggable = YES;
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"MarkerTest" ofType:@"png"];
    //NSURL *url = [NSURL fileURLWithPath:path];
    //view.imageUrl = [url absoluteString];
    return view;
}

- (void)mapView:(MKMapView *)aMapView didAddAnnotationViews:(NSArray *)views
{
    //NSLog(@"mapView: %@ didAddAnnotationViews: %@", aMapView, views);
}
/*
 - (void)mapView:(MKMapView *)aMapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
 {
 NSLog(@"mapView: %@ annotationView: %@ calloutAccessoryControlTapped: %@", aMapView, view, control);
 }
 */

// Dragging an Annotation View
/*
 - (void)mapView:(MKMapView *)aMapView annotationView:(MKAnnotationView *)annotationView
 didChangeDragState:(MKAnnotationViewDragState)newState
 fromOldState:(MKAnnotationViewDragState)oldState
 {
 NSLog(@"mapView: %@ annotationView: %@ didChangeDragState: %d fromOldState: %d", aMapView, annotationView, newState, oldState);
 }
 */


// Selecting Annotation Views

- (void)mapView:(MKMapView *)aMapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //NSLog(@"mapView: %@ didSelectAnnotationView: %@", aMapView, view);
}

- (void)mapView:(MKMapView *)aMapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    //NSLog(@"mapView: %@ didDeselectAnnotationView: %@", aMapView, view);
}


// Managing Overlay Views

- (MKOverlayView *)mapView:(MKMapView *)aMapView viewForOverlay:(id <MKOverlay>)overlay
{
    //NSLog(@"mapView: %@ viewForOverlay: %@", aMapView, overlay);
    MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:overlay];
    return circleView;
    //    MKPolylineView *polylineView = [[[MKPolylineView alloc] initWithPolyline:overlay] autorelease];
    //    return polylineView;
    MKPolygonView *polygonView = [[MKPolygonView alloc] initWithPolygon:overlay];
    return polygonView;
}

- (void)mapView:(MKMapView *)aMapView didAddOverlayViews:(NSArray *)overlayViews
{
    //NSLog(@"mapView: %@ didAddOverlayViews: %@", aMapView, overlayViews);
}

- (void)mapView:(MKMapView *)aMapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
{
    //NSLog(@"mapView: %@ annotationView: %@ didChangeDragState:%d fromOldState:%d", aMapView, annotationView, newState, oldState);
    
    if (newState ==  MKAnnotationViewDragStateEnding || newState == MKAnnotationViewDragStateNone)
    {
        // create a new circle view
        MKPointAnnotation *pinAnnotation = annotationView.annotation;
        for (NSMutableDictionary *pin in coreLocationPins)
        {
            if ([[pin objectForKey:@"pin"] isEqual: pinAnnotation])
            {
                // found the pin.
                MKCircle *circle = [pin objectForKey:@"circle"];
                CLLocationDistance pinCircleRadius = circle.radius;
                [aMapView removeOverlay:circle];
                
                circle = [MKCircle circleWithCenterCoordinate:pinAnnotation.coordinate radius:pinCircleRadius];
                [pin setObject:circle forKey:@"circle"];
                [aMapView addOverlay:circle];
            }
        }
    }
    else {
        // find old circle view and remove it
        MKPointAnnotation *pinAnnotation = annotationView.annotation;
        for (NSMutableDictionary *pin in coreLocationPins)
        {
            if ([[pin objectForKey:@"pin"] isEqual: pinAnnotation])
            {
                // found the pin.
                MKCircle *circle = [pin objectForKey:@"circle"];
                [aMapView removeOverlay:circle];
            }
        }
    }
    
    
    //MKPointAnnotation *annotation = annotationView.annotation;
    //NSLog(@"annotation = %@", annotation);
    
}

// MacMapKit additions
- (void)mapView:(MKMapView *)aMapView userDidClickAndHoldAtCoordinate:(CLLocationCoordinate2D)coordinate;
{
    //NSLog(@"mapView: %@ userDidClickAndHoldAtCoordinate: (%f, %f)", aMapView, coordinate.latitude, coordinate.longitude);
    MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
    pin.coordinate = coordinate;
    pin.title = @"Hi.";
    [mapView addAnnotation:pin];
}

- (NSArray *)mapView:(MKMapView *)mapView contextMenuItemsForAnnotationView:(MKAnnotationView *)view
{
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Delete It" action:@selector(delete:) keyEquivalent:@""];
    return [NSArray arrayWithObject:item];
}

@end