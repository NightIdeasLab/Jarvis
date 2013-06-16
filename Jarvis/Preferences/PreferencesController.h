//
//  PreferencesController.h
//  Jarvis
//
//  Created by Gabriel Ulici on 6/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define DEFAULT_REFRESH_INTERVAL 30*60; // default to 30 minutes if none specified

typedef enum {
    NotificationTypeUserNotificationCenter = 0,
    NotificationTypeGrowl = 1,
    NotificationTypeDisabled = 2
} NotificationType;

@interface PreferencesController : NSWindowController

- (id)initPreferencesController;
- (void)showPreferences;
- (IBAction)selectGeneralTab:(id)sender;
- (IBAction)selectUpdateTab:(id)sender;

@end
