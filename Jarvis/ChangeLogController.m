//
//  ChangeLogController.m
//  Jarvis
//
//  Created by Gabriel Ulici on 7/14/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "ChangeLogController.h"

@implementation ChangeLogController
@synthesize changeLogWebView;

- (id)initWithWindow:(NSWindow *)window{
	if((self = [super initWithWindow:nil])){
        // for the moment nothing :)        
	}
	return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

	[windowCL setFloatingPanel:NO];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    // sets a webview to be trasparent
    [changeLogWebView setDrawsBackground:NO];
    
    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
    NSString *htmlPath = [resourcesPath stringByAppendingString:@"/htdocs/ChangeLog.html"];
    [[changeLogWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]];

	

    /* this way i can load a normal file not as the htdocs */
   // NSURL *mainWebPageURL = [[NSBundle mainBundle] URLForResource:@"ChangeLog" withExtension:@"html"];
    
	//[[changeLogWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:mainWebPageURL]];
    
}

- (IBAction)showWindow:(id)sender{
    // This forces the resources in the nib to load.
    [self window];
    
    [[self window] center];
    
    [super showWindow:sender];
}

// Close the window with cmd+w incase the app doesn't have an app menu
- (void)keyDown:(NSEvent *)theEvent{
    NSString *key = [theEvent charactersIgnoringModifiers];
    if(([theEvent modifierFlags] & NSCommandKeyMask) && [key isEqualToString:@"w"]){
        [self close];
    }else{
        [super keyDown:theEvent];
    }
}


@end
