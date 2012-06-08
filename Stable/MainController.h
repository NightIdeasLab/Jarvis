//
//  MainController.h
//  Jarvis
//
//  Created by Gabriel Ulici on 09/23/11.
//  Copyright (c) 2011-2012 Night Ideas Lab Inc. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <AudioToolbox/AudioServices.h>
#import <CalendarStore/CalendarStore.h>
#import <Cocoa/Cocoa.h>
#import <CoreAudio/CoreAudio.h>
#import <CoreServices/CoreServices.h>
#import <Quartz/Quartz.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <WebKit/WebKit.h>

#import "AboutController.h"
#import "ChangeLogController.h"
#import "PreferencesController.h"

#ifdef MAC_OS_X_VERSION_10_6
#define APPLICATION_DELEGATE <NSApplicationDelegate>
#else
#define APPLICATION_DELEGATE
#endif

@interface MainController : NSObject APPLICATION_DELEGATE
{
    NSUserDefaults * fDefaults;
    BOOL fQuitRequested;
    IBOutlet id outText;
	IBOutlet id window;
    IBOutlet NSWindow *windowLM;
    PreferencesController *myPreferencesController;
    ChangeLogController *myChangeLogController;
}

- (NSWindow *)windowLM;

- (IBAction)update:(id)sender;
- (IBAction)Homepage:(id)sender;
- (IBAction)Issue:(id)sender;
- (IBAction)ChangeLog:(id)sender;
- (IBAction)Donate:(id)sender;
- (IBAction)showPreferencesWindow:(id)sender;
- (IBAction)showAboutWindow:(id)sender;
- (void)jarvis;
//- (void)setVolume:(float)involume;

@end
 

