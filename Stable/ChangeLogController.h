//
//  ChangeLog.h
//  Jarvis
//
//  Created by Gabriel Ulici on 1/26/12.
//  Copyright (c) 2011-2012 Night Ideas Lab Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface ChangeLogController : NSWindowController {
    IBOutlet WebView *fChangeLogWebView;
    IBOutlet NSWindow *fChangeLogView;
}

@property (nonatomic, retain) IBOutlet WebView *fChangeLogWebView;

@end
