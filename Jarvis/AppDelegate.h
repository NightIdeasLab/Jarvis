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
#import "JRFeedbackController.h"
#import "PreferencesController.h"


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


- (NSWindow *)windowLM;

@end