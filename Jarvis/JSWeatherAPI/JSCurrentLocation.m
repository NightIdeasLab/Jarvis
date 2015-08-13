//
//  JSCurrentLocation.m
//  JSWeatherAPI
//
//  Created by John Setting on 12/4/14.
//  Copyright (c) 2014 John Setting. All rights reserved.
//
//  Modified by Gabriel Ulici on 10/4/15.
//  Copyright (c) 2015 Night Ideas Lab. All rights reserved.
//

#import "JSCurrentLocation.h"

@interface JSCurrentLocation() <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation JSCurrentLocation

- (id)init
{
    if (!(self = [super init])) return nil;
    return self;
}

+ (id)sharedInstance
{
    static dispatch_once_t once;
    static JSCurrentLocation *instance;
    dispatch_once(&once, ^{ instance = [[JSCurrentLocation alloc] init]; });
    return instance;
}

- (void)getCurrentLocation
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.geocoder = [[CLGeocoder alloc] init];
    
    [self.locationManager setDelegate:self];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
/*
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        //[self.locationManager requestWhenInUseAuthorization];
    } else if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        //[self.locationManager requestAlwaysAuthorization];
    }
*/
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JSCurrentLocation:didFailToReceiveLocation:)]) {
        [self.delegate JSCurrentLocation:self didFailToReceiveLocation:error];
    }
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // Get the most recent location found
    CLLocation *currentLocation = [locations objectAtIndex:[locations count] - 1];
    
    // Convert CLLocation to a readable text
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        [manager stopUpdatingLocation];
        
        if (error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(JSCurrentLocation:didFailToReceiveLocation:)]) {
                [self.delegate JSCurrentLocation:self didFailToReceiveLocation:error];
            }
            return;
        }
        
        if ([placemarks count] > 0) {
            CLPlacemark * placemark = [placemarks lastObject];
            //float latitude = placemark.location.coordinate.latitude;
            //float longitude = placemark.location.coordinate.longitude;
            NSString *city = placemark.locality;
            NSString *state = placemark.administrativeArea;

            // We want to receive the latitude and longitude of the
            // current location to get the current locations weather
            if (self.delegate && [self.delegate respondsToSelector:@selector(JSCurrentLocation:didReceiveLocation:)]) {
                [self.delegate JSCurrentLocation:self didReceiveLocation:@{@"city" : city,
                                                                           @"state" : state}];
            }
            return;
        }
    }];
}

@end