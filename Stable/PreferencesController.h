//
//  PreferencesController.h
//  Jarvis
//
//  Created by Gabriel Ulici on 3/11/12.
//  Copyright (c) 2011-2012 Night Ideas Lab Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSWindowController {
    NSWindow *fPreferenceView;
}

@property (assign) IBOutlet NSWindow *fPreferenceView;

@end
