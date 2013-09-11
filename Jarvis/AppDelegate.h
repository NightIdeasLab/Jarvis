//
//  AppDelegate.h
//  Jarvis
//
//  Created by Gabriel Ulici on 6/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

// Frameworks
#import <AppKit/AppKit.h>
#import <AudioToolbox/AudioServices.h>
#import <CalendarStore/CalendarStore.h>
#import <Cocoa/Cocoa.h>
#import <CoreAudio/CoreAudio.h>
#import <CoreServices/CoreServices.h>
#import <Quartz/Quartz.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <WebKit/WebKit.h>
#import <IOKit/IOMessage.h>
#import <Sparkle/Sparkle.h>

// Local Classes
#import "CalendarMethod.h"
#import "ChangeLogController.h"
#import "EmailMethod.h"
#import "JRFeedbackController.h"
#import "PreferencesController.h"
#import "NewsAndQuoteMethod.h"
#import "TimeAndDateMethod.h"
#import "WeatherMethod.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    NSString * fConfigDirectory;
    NSUserDefaults * fDefaults;
    BOOL fQuitRequested;
    IBOutlet id outText;
    IBOutlet id window;
    IBOutlet NSWindow *windowLM;
}

@property (nonatomic, strong) PreferencesController *preferencesController;
@property (nonatomic, strong) ChangeLogController *changeLogController;

- (NSWindow *)windowLM;

- (IBAction) openPreferences: (id) sender;
- (IBAction) sendFeedBack: (id) sender;
- (IBAction) openHomepage: (id) sender;
- (IBAction) openIssue: (id) sender;
- (IBAction) openChangeLog: (id) sender;
- (IBAction) openDonate: (id) sender;
- (IBAction) updateJarvis: (id) sender;
- (IBAction) stopSpeech: (id) sender;
- (void) linkDonate: (id) sender;
- (void) jarvis: (BOOL) speech;



@end