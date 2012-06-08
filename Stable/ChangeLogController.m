//
//  ChangeLog.m
//  Jarvis
//
//  Created by Gabriel Ulici on 1/26/12.
//  Copyright (c) 2012 Night Ideas Lab Inc. All rights reserved.
//

#import "ChangeLogController.h"

@implementation ChangeLogController

@synthesize fChangeLogWebView;

- (id) init 
{    
	if ( ! (self = [super initWithWindowNibName: @"ChangeLog"]) ) 
    {
        NSLog(@"init failed in ChangeLogController");
        return nil;
	}
	NSLog(@"init OK in ChangeLogController");
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //something will be here
}

- (void) awakeFromNib
{
    [fChangeLogView makeKeyAndOrderFront:nil];
   // WebPreferences *prefs = [fChangeLogWebView preferences];
  //  [prefs _setLocalStorageDatabasePath:@"~/Library/Jarvis/LocalStorage"];
	NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
	NSString *htmlPath = [resourcesPath stringByAppendingString:@"/htdocs/relnotes.html"];
	[[fChangeLogWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]];
}

- (void) windowDidLoad
{
	NSLog(@"ChangeLogPanel did load");
    [[self window] makeKeyAndOrderFront:self];
}

- (void) windowWillClose: (id) sender
{
	[NSApp terminate:self];
}

@end
