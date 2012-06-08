//
//  AboutController.m
//  Jarvis
//
//  Created by Gabriel Ulici on 11/28/11.
//  Copyright (c) 2011-2012 Night Ideas Lab Inc. All rights reserved.
//

#import "AboutController.h"

@implementation AboutController
AboutController * fAboutBoxInstance = nil;
+ (AboutController *) aboutController
{
    if (!fAboutBoxInstance)
        fAboutBoxInstance = [[self alloc] initWithWindowNibName: @"About"];
    return fAboutBoxInstance;
}

- (void) awakeFromNib
{
    [fAboutView makeKeyAndOrderFront:nil];
    NSDictionary * info = [[NSBundle mainBundle] infoDictionary];
    [jVersionField setStringValue: [NSString stringWithFormat: @"%@ (%@)", [info objectForKey: @"CFBundleShortVersionString"], [info objectForKey: (NSString *)kCFBundleVersionKey]]];

    //size license button
    const CGFloat oldButtonWidth = NSWidth([fLicenseButton frame]);    
    [fLicenseButton setTitle: NSLocalizedString(@"License", "About window -> license button")];
    [fLicenseButton sizeToFit];
    NSRect buttonFrame = [fLicenseButton frame];
    buttonFrame.size.width += 10.0;
    buttonFrame.origin.x -= NSWidth(buttonFrame) - oldButtonWidth;
    [fLicenseButton setFrame: buttonFrame];
}

- (void)windowDidLoad {
	NSLog(@"AboutPanel did load");
    [[self window] center];
}

- (void) windowWillClose: (id) sender
{
    [fAboutView close];
    [fAboutBoxInstance release];
    fAboutBoxInstance = nil;
}

- (IBAction)showLicense:(id)sender
{
    NSString * licenseText = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"COPYING" ofType: nil]
                                        usedEncoding: nil error: NULL];
    [fLicenseView setString: licenseText];
    [fLicenseCloseButton setTitle: NSLocalizedString(@"OK", "About window -> license close button")];
	
	[NSApp beginSheet: fLicenseSheet modalForWindow: [self window] modalDelegate: nil didEndSelector: nil contextInfo: nil];
}

- (IBAction)hideLicense:(id)sender
{
    [fLicenseSheet orderOut: nil];
    [NSApp endSheet: fLicenseSheet];
}

- (IBAction)buttonMe:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: @"http://gabrielulici.github.com/"]];
}

- (IBAction)buttonPhysicistjedi:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: @"http://physicistjedi.deviantart.com/"]];
}

- (IBAction)buttonAndyMatuschak:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: @"http://sparkle.andymatuschak.org/"]];
}

- (IBAction)buttonAndyKim:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: @"http://www.potionfactory.com/"]];
}

@end