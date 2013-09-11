//
//  PreferencesController.m
//  Jarvis
//
//  Created by Gabriel Ulici on 6/17/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "PreferencesController.h"

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

// Update
@synthesize updateDateField;
@synthesize profileDateField;

// Weather
@synthesize locationField;
@synthesize mapWebView;
@synthesize locationManager;
@synthesize locationLabel;
@synthesize findLocationButton;
@synthesize automaticLocationCheckBok;

#pragma mark -
#pragma mark Class Methods
/*
- (void)dealloc {
	[updateDateField release];
	[profileDateField release];
	[locationField release];
	[locationLabel release];
	[locationManager stopUpdatingLocation];
	[locationManager release];
	[super dealloc];
}*/

- (void) awakeFromNib {
	// reading from the plist file
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	// retriving the last update date and
	// last profile sent date from plist file
	NSDate *updateDate = [defaults objectForKey:@"SULastCheckTime"];
	NSDate *profileDate = [defaults objectForKey:@"SULastProfileSubmissionDate"];

	// retriving latidude and
	// longitude from plist file
	double latitude = [defaults doubleForKey:@"Latitude"];
	double longitude = [defaults doubleForKey:@"Longitude"];

	if ((latitude != 0) && (longitude != 0)) {
	NSLog(@"latitude : %f", latitude);
	}
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

	// FIXME: Close the location manager when the pref window closes
	// TODO: load the weather stuff only when the wether view is active
	//       and releasing them when switching from it
	/* 	Weather Stuff retriving the location */
//	locationManager = [[CLLocationManager alloc] init];
//	locationManager.delegate = self;
//	[locationManager startUpdatingLocation];

//	[self changeStateAutomaticLocation:self];

	

	//[defaults release];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	[locationManager stopUpdatingLocation];
	//[locationManager release];
}

#pragma mark -
#pragma mark Toolbar Configuration

- (void)setupToolbar{
	[self addView:self.generalPreferenceView label: NSLocalizedString(@"General", @"General Window title")
			image: [NSImage imageNamed:@"PrefGeneral"]];
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
#pragma mark Weather Methods

#pragma mark -
#pragma mark WOIED

- (NSInteger *)getWOEIDfromlatitude: (double) latitude andLongitude: (double) longitude {

	NSString *flickrKEY = @"ca5edb0f6f046f0e9e1ee43dd49277e4";
	NSString *woeidCode = @"";
	NSString *woeidContent = @"";
	woeidContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:
													  [NSString stringWithFormat:
													   @"http://api.flickr.com/services/rest/?method=flickr.places.findByLatLon&api_key=%@&lat=%f&lon=%f",flickrKEY,latitude, longitude]] encoding:NSUTF8StringEncoding error:nil];

	if(woeidContent != nil) {
		woeidCode = [[woeidContent componentsSeparatedByString:@"woeid=\""] objectAtIndex:1];
		woeidCode = [[woeidCode componentsSeparatedByString:@"\""] objectAtIndex:0];
	}
	else {
		NSLog(@"The woeid cannot be retrived!!!");
	}

	NSLog(@"Flickr woeid responce: %@",woeidCode);

    return 0;
}

- (IBAction)findLocation:(id)sender {
	// retrives the City and Country
	NSString *locationText = [locationField stringValue];
	NSString *messageForLabel = [[NSString alloc] initWithFormat:NSLocalizedString(@"Your location is: %@", @"Message after the user inseted his location"), locationText];

	if ([locationText length] >0) {
		// Displays the user his location
		[locationLabel setStringValue:messageForLabel];
		[self getWOEIDFromCityAndCountry:locationText];
	}
	else {
		// If the user will not write a city and country then we will display this message
		[locationLabel setStringValue:NSLocalizedString(@"Please enter a City and Country.", @"Message that appeareas if the user did not inserted his location")];
	}


	//[messageForLabel release];

	//    if (!firstLaunch) {
	//
	//        [fDefaults setInteger:721943 forKey: @"LocationCode"];
	//    }

}

- (NSInteger *)getWOEIDFromCityAndCountry: (NSString *) cityAndCountry {
	// TODO: remove the white spaces in cityAndCountry and replace it with %20 the normal HTML white space
	cityAndCountry =[cityAndCountry stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

	NSString *flickrKEY = @"ca5edb0f6f046f0e9e1ee43dd49277e4";
	NSString *woeidCode = @"";
	NSString *latitudeCode = @"";
	NSString *longitudeCode = @"";
	NSString *woeidContent = @"";
	woeidContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:
													  [NSString stringWithFormat:
													   @"http://api.flickr.com/services/rest/?method=flickr.places.find&api_key=%@&query=%@",flickrKEY,cityAndCountry]] encoding:
															NSUTF8StringEncoding error:nil];

	NSLog(@"woeidcontent: %@", woeidContent);

	if(woeidContent != nil) {
		woeidCode = [[woeidContent componentsSeparatedByString:@"woeid=\""] objectAtIndex:1];
		woeidCode = [[woeidCode componentsSeparatedByString:@"\""] objectAtIndex:0];
		latitudeCode = [[woeidContent componentsSeparatedByString:@"latitude=\""] objectAtIndex:1];
		latitudeCode = [[latitudeCode componentsSeparatedByString:@"\""] objectAtIndex:0];
		longitudeCode = [[woeidContent componentsSeparatedByString:@"longitude=\""] objectAtIndex:1];
		longitudeCode = [[longitudeCode componentsSeparatedByString:@"\""] objectAtIndex:0];
    }
	else {
		NSLog(@"The woeid cannot be retrived!!!");
	}

	[self saveCodeData:woeidCode longitude:longitudeCode latitude:latitudeCode];

#if DEBUG
	NSLog(@"Flickr woeid respornce: %@",woeidCode);
	NSLog(@"Flickr latitude respornce: %@",latitudeCode);
	NSLog(@"Flickr longitude respornce: %@",longitudeCode);
#endif
	
	double latitudeDouble = [latitudeCode doubleValue];

	double longitudeDouble = [longitudeCode doubleValue];

	[self updateMapWithLatitude: latitudeDouble AndLongitude: longitudeDouble];

	return 0;
}

- (void)saveCodeData:(NSString *) aWoeidCode longitude:(NSString *) aLongitudeCode latitude:(NSString *) aLatitudeCode{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
    [defaults setObject:aWoeidCode forKey: @"woeidCode"];
	[defaults setObject:aLongitudeCode forKey: @"longitudeCode"];
	[defaults setObject:aLatitudeCode forKey: @"latitudeCode"];

	[defaults synchronize];
}

#pragma mark -
#pragma mark WOIED functions  for LAT & LON

+ (double)latitudeRangeForLocation:(CLLocation *)aLocation {
	const double M = 6367000.0; // approximate average meridional radius of curvature of earth
	const double metersToLatitude = 1.0 / ((M_PI / 180.0) * M);
	const double accuracyToWindowScale = 4.0;

	return aLocation.horizontalAccuracy * metersToLatitude * accuracyToWindowScale;
}

+ (double)longitudeRangeForLocation:(CLLocation *)aLocation {
	double latitudeRange =
    [PreferencesController latitudeRangeForLocation:aLocation];

	return latitudeRange * cos(aLocation.coordinate.latitude * M_PI / 180.0);
}

- (void) locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
	// Ignore updates where nothing we care about changed
	if (newLocation.coordinate.longitude == oldLocation.coordinate.longitude &&
		newLocation.coordinate.latitude == oldLocation.coordinate.latitude &&
		newLocation.horizontalAccuracy == oldLocation.horizontalAccuracy)
	{
		return;
	}

	//NSLog(@"Latitude: %f , longitude: %f , and new location : %@", newLocation.coordinate.latitude,newLocation.coordinate.longitude,newLocation);

[self updateMapWithLatitude:newLocation.coordinate.latitude AndLongitude:newLocation.coordinate.longitude];

}

-(void) updateMapWithLatitude: (double) latitude  AndLongitude: (double) longitude
{
// Load the HTML for displaying the Google map from a file and replace the
// format placeholders with our location data
NSString *htmlString = [NSString stringWithFormat:
						[NSString
						 stringWithContentsOfFile:
						 [[NSBundle mainBundle]
						  pathForResource:@"googleMaps" ofType:@"html"]
						 encoding:NSUTF8StringEncoding
						 error:NULL],
						latitude,
						longitude,
						latitude,
						longitude];


// Load the HTML in the WebView and set the labels
[[mapWebView mainFrame] loadHTMLString:htmlString baseURL:nil];

#ifdef DEBUG
	[locationLabel setStringValue:[NSString stringWithFormat:@"%f, %f", latitude, longitude]];
#endif

}

- (void) locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
	[[mapWebView mainFrame]
	 loadHTMLString:
	 [NSString stringWithFormat:
	  NSLocalizedString(@"Location manager failed with error: %@", nil),
	  [error localizedDescription]]
	 baseURL:nil];
	[locationLabel setStringValue:@""];
}

#pragma mark -
#pragma mark Other Functions

- (void)windowWillTerminate:(NSNotification *)aNotification {
	[locationManager stopUpdatingLocation];
	//[locationManager release];
}

- (IBAction)openInDefaultBrowser:(id)sender {
	CLLocation *currentLocation = locationManager.location;

	NSURL *externalBrowserURL = [NSURL URLWithString:[NSString stringWithFormat:
													  @"http://maps.google.com/maps?q=%f,%f&ll=%f,%fspn=%f,%f",
													  currentLocation.coordinate.latitude,
													  currentLocation.coordinate.longitude,
													  currentLocation.coordinate.latitude,
													  currentLocation.coordinate.longitude,
													  [PreferencesController latitudeRangeForLocation:currentLocation],
													  [PreferencesController longitudeRangeForLocation:currentLocation]]];

	[[NSWorkspace sharedWorkspace] openURL:externalBrowserURL];
}

- (IBAction)changeStateAutomaticLocation:(id)sender {

    if ([automaticLocationCheckBok state] == 1) {
        [locationField setEnabled:NO];
        [findLocationButton setEnabled:NO];

    } else {
        [locationField setEnabled:YES];
        [findLocationButton setEnabled:YES];
    }

}

@end
