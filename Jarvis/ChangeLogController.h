//
//  ChangeLogController.h
//  Jarvis
//
//  Created by Gabriel Ulici on 7/14/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface ChangeLogController : NSWindowController {
	IBOutlet id windowCL;
}

@property (assign) IBOutlet WebView *changeLogWebView;

@end
