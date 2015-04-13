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

// Update
@synthesize updateDateField;
@synthesize profileDateField;

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

#pragma mark -
#pragma mark Class Methods

- (void) awakeFromNib {
	// reading from the plist file
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
	// retriving the last update date and
	// last profile sent date from plist file
	NSDate *updateDate = [defaults objectForKey:@"SULastCheckTime"];
	NSDate *profileDate = [defaults objectForKey:@"SULastProfileSubmissionDate"];

<<<<<<< HEAD
	// retriving latidude and
	// longitude from plist file
	double latitude = [defaults doubleForKey:@"latitudeCode"];
	double longitude = [defaults doubleForKey:@"longitudeCode"];

	if ((latitude != 0) && (longitude != 0)) {
		NSLog(@"latitude : %f", latitude);
        
        [mapWebView setShowsUserLocation: YES];
	}
=======
    BOOL useCal = [defaults boolForKey:@"UseCal"];
    BOOL useWeather = [defaults boolForKey:@"UseWeather"];
    BOOL useMail = [defaults boolForKey:@"UseMail"];
    BOOL useNewsQuotes = [defaults boolForKey:@"UseNewsQuotes"];
	BOOL automaticLocation = [defaults boolForKey:@"AutomaticLocation"];
	BOOL forecastState = [defaults boolForKey:@"ForecastWeather"];
	NSString *temperatureStyle = [defaults stringForKey:@"TemperatureStyle"];
    
>>>>>>> version-0.4.3
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

	if ([defaults boolForKey:@"ReadUserName"]) {
		[readUserName setState:1];
		[self changeStateOfName:self];

		NSString *userNameState = [defaults stringForKey:@"UserName"];
		
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
	} else {
		[readUserName setState:0];
		[self changeStateOfName:self];
	}
<<<<<<< HEAD
	
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
	
=======
    
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

    if (automaticLocation == YES) {
		[mapView setShowsUserLocation: YES];
		[mapView setDelegate: self];
		[locationField setEnabled:NO];
        [findLocationButton setEnabled:NO];
		[automaticLocationCheckBox setState:1];
	} else {
		[automaticLocationCheckBox setState:0];
		[locationField setEnabled:YES];
        [findLocationButton setEnabled:YES];
	}

	if (forecastState == YES) {
		[forecastButton setState:1];
	} else {
		[forecastButton setState:0];
	}
	
	if ([temperatureStyle isEqualToString:@"Celsius"]) {
		[popUpTemperatureButton selectItemAtIndex:0];
	} else 	if ([temperatureStyle isEqualToString:@"Kelvin"]) {
		[popUpTemperatureButton selectItemAtIndex:1];
	} else 	if ([temperatureStyle isEqualToString:@"Fahrenheit"]) {
		[popUpTemperatureButton selectItemAtIndex:2];
	}
>>>>>>> version-0.4.3
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

- (IBAction)findLocation:(id)sender {
	[mapView showAddress:[locationField stringValue]];
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
<<<<<<< HEAD

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
=======
>>>>>>> version-0.4.3
	
	MKGeocoder *geocoderNoCoord = [[MKGeocoder alloc] initWithAddress:locationText];
	geocoderNoCoord.delegate = self;
	[geocoderNoCoord start];
}

- (IBAction)changeStateAutomaticLocation:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
    if ([automaticLocationCheckBox state] == 1) {
        [locationField setEnabled:NO];
        [findLocationButton setEnabled:NO];
		[defaults setBool:YES forKey: @"AutomaticLocation"];
    } else {
        [locationField setEnabled:YES];
        [findLocationButton setEnabled:YES];
		[defaults setBool:NO forKey: @"AutomaticLocation"];
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
	
}

- (IBAction)readCustomName:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	NSString *customNameText = [customName stringValue];

	if ([customNameText length] >0) {
		[defaults setObject:customNameText forKey: @"UserName"];
	}
}

- (IBAction)changeTemperatureStyle:(NSPopUpButton *)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger indexOfTemperaturePopUp = [popUpTemperatureButton indexOfSelectedItem];

	if (indexOfTemperaturePopUp == 0 ) {
		[defaults setObject:@"Celsius" forKey: @"TemperatureStyle"];
	} else if (indexOfTemperaturePopUp == 1 ) {
		[defaults setObject:@"Kelvin" forKey: @"TemperatureStyle"];
	} else if (indexOfTemperaturePopUp == 2 ) {
		[defaults setObject:@"Fahrenheit" forKey: @"TemperatureStyle"];
	}
}

- (IBAction)changeTimeStyle:(NSPopUpButton *)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSInteger indexOfTimePopUp = [popUpTimeStyleButton indexOfSelectedItem];

	if (indexOfTimePopUp == 0 ) {
		[defaults setObject:@"24" forKey: @"TimeStyle"];
	} else if (indexOfTimePopUp == 1 ) {
		[defaults setObject:@"am/pm" forKey: @"TimeStyle"];
	}
}

- (IBAction)forecastYesOrNo:(id)sender {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	if ([forecastButton state] == 1) {
		[defaults setBool:YES forKey: @"ForecastWeather"];
	} else {
		[defaults setBool:NO forKey: @"ForecastWeather"];
	}
	
}

<<<<<<< HEAD

@end
=======
- (void)geocoder:(MKGeocoder *)geocoder didFindCoordinate:(CLLocationCoordinate2D)coordinate
{
	CLLocationCoordinate2D coordinateE;
	coordinateE.latitude = coordinate.longitude;
	coordinateE.longitude = coordinate.latitude;
	MKReverseGeocoder *reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate: coordinateE];
	reverseGeocoder.delegate = self;
	[reverseGeocoder start];
}

- (void)geocoder:(MKGeocoder *)geocoder didFailWithError:(NSError *)error
{
    //NSLog(@"MKGeocoder didFailWithError: %@", error);
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
    if (placemark.locality != NULL && placemark.country != NULL && placemark.countryCode != NULL) {
        [mapView setShowsUserLocation: NO];
        // adding the location to the text box
		NSString *locationText = [NSString stringWithFormat:@"%@, %@", placemark.country, placemark.locality];
		NSString *messageForLabel = [[NSString alloc] initWithFormat:NSLocalizedString(@"Your location is: %@", @"Message after the user inseted his location"), locationText];
		[locationLabel setStringValue:messageForLabel];
		[defaults setObject:placemark.locality forKey: @"Locality"];
		[defaults setObject:placemark.countryCode forKey: @"CountryCode"];
		[defaults synchronize];
    }
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    //NSLog(@"MKReverseGeocoder didFailWithError: %@", error);
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (showsUserLocationApp == NO) {
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = userLocation.location.coordinate.latitude;
        coordinate.longitude = userLocation.location.coordinate.longitude;
        MKReverseGeocoder *reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate: coordinate];
        reverseGeocoder.delegate = self;
        [reverseGeocoder start];
        if (userLocation.location.coordinate.latitude && userLocation.location.coordinate.longitude) {
            showsUserLocationApp = YES;
        }
    }
}

@end
>>>>>>> version-0.4.3
