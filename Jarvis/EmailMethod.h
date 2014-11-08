//
//  EmailMethod.h
//  Jarvis
//
//  Created by Gabriel Ulici on 7/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CoreServices/CoreServices.h>
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface EmailMethod : NSObject

- (NSString *) retrieveEmail;

@end
