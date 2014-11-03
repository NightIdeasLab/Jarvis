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

// General
@synthesize readUserName;
@synthesize customNamePopUp;
@synthesize customName;
@synthesize popUpNameButton;
@synthesize popUpTimeStyleButton;

// Update
@synthesize updateDateField;
@synthesize profileDateField;

// Weather
@synthesize locationField;
@synthesize mapWebView;
@synthesize locationManager;
@synthesize locationLabel;
@synthesize findLocationButton;
@synthesize automaticLocationCheckBox;
@synthesize temperaturePopUp;
@synthesize popUpTemperatureButton;
@synthesize forecastButton;

// Service button
@synthesize iCalButton;
@synthesize weatherButton;
@synthesize mailButton;
@synthesize newsButton;

#pragma mark -
#pragma mark Class Methods

- (void) awakeFromNib {
	// reading from the plist file
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
	// retriving the last update date and
	// last profile sent date from plist file
	NSDate *updateDate = [defaults objectForKey:@"SULastCheckTime"];
	NSDate *profileDate = [defaults objectForKey:@"SULastProfileSubmissionDate"];

	// retriving latidude and
	// longitude from plist file
	double latitude = [defaults doubleForKey:@"latitudeCode"];
	double longitude = [defaults doubleForKey:@"longitudeCode"];

    BOOL useCal = [defaults boolForKey:@"UseCal"];
    BOOL useWeather = [defaults boolForKey:@"UseWeather"];
    BOOL useMail = [defaults boolForKey:@"UseMail"];
    BOOL useNewsQuotes = [defaults boolForKey:@"UseNewsQuotes"];
    
	if ((latitude != 0) && (longitude != 0)) {
		NSLog(@"latitude : %f", latitude);
        
        [mapWebView setShowsUserLocation: YES];
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
    } else {
        [mailButton setState:0];
        // TODO disable even the vips emails
    }
    if (useNewsQuotes == YES) {
        [newsButton setState:1];
    } else {
        [newsButton setState:0];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	
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
		NSLog(@"The woeid cannot be retrieved!!!");
	}

	//NSLog(@"Flickr woeid responce: %@",woeidCode);

    return 0;
}

- (IBAction)findLocation:(id)sender {
	// retrieves the City and Country
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

	if(woeidContent != nil) {
		woeidCode = [[woeidContent componentsSeparatedByString:@"woeid=\""] objectAtIndex:1];
		woeidCode = [[woeidCode componentsSeparatedByString:@"\""] objectAtIndex:0];
		latitudeCode = [[woeidContent componentsSeparatedByString:@"latitude=\""] objectAtIndex:1];
		latitudeCode = [[latitudeCode componentsSeparatedByString:@"\""] objectAtIndex:0];
		longitudeCode = [[woeidContent componentsSeparatedByString:@"longitude=\""] objectAtIndex:1];
		longitudeCode = [[longitudeCode componentsSeparatedByString:@"\""] objectAtIndex:0];
    }
	else {
		NSLog(@"The woeid cannot be retrieved!!!");
	}

	[self saveCodeData:woeidCode longitude:longitudeCode latitude:latitudeCode];

/*
	NSLog(@"Flickr woeid respornce: %@",woeidCode);
	NSLog(@"Flickr latitude respornce: %@",latitudeCode);
	NSLog(@"Flickr longitude respornce: %@",longitudeCode);
*/
	
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
 
//    
//// Load the HTML for displaying the Google map from a file and replace the
//// format placeholders with our location data
//NSString *htmlString = [NSString stringWithFormat:
//						[NSString
//						 stringWithContentsOfFile:
//						 [[NSBundle mainBundle]
//						  pathForResource:@"googleMaps" ofType:@"html"]
//						 encoding:NSUTF8StringEncoding
//						 error:NULL],
//						latitude,
//						longitude,
//						latitude,
//						longitude];
//
//
//// Load the HTML in the WebView and set the labels
//[[mapWebView mainFrame] loadHTMLString:htmlString baseURL:nil];

#ifdef DEBUG
	[locationLabel setStringValue:[NSString stringWithFormat:@"%f, %f", latitude, longitude]];
#endif

}

- (void) locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error
{
//	[[mapWebView mainFrame]
//	 loadHTMLString:
//	 [NSString stringWithFormat:
//	  NSLocalizedString(@"Location manager failed with error: %@", nil),
//	  [error localizedDescription]]
//	 baseURL:nil];
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

    if ([automaticLocationCheckBox state] == 1) {
        [locationField setEnabled:NO];
        [findLocationButton setEnabled:NO];

    } else {
        [locationField setEnabled:YES];
        [findLocationButton setEnabled:YES];
    }

}

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
@end