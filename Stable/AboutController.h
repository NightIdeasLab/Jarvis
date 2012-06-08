//
//  AboutController.h
//  Jarvis
//
//  Created by Gabriel Ulici on 11/28/11.
//  Copyright (c) 2011-2012 Night Ideas Lab Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AboutController : NSWindowController {
    IBOutlet NSTextField *jVersionField;
    IBOutlet NSTextView *fLicenseView;
    IBOutlet NSPanel *fLicenseSheet;
    IBOutlet NSButton *fLicenseCloseButton;
    IBOutlet NSButton *fLicenseButton;
    IBOutlet NSButton *fContributorsButton;
    IBOutlet NSPanel *fContributorsView;
    IBOutlet NSWindow *fAboutView;
}

+ (AboutController *) aboutController;

- (IBAction)showLicense:(id)sender;
- (IBAction)hideLicense:(id)sender;
- (IBAction)buttonMe:(id)sender;
- (IBAction)buttonPhysicistjedi:(id)sender;
- (IBAction)buttonAndyMatuschak:(id)sender;
- (IBAction)buttonAndyKim:(id)sender;

@end
