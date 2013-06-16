//
//  PreferencesController.m
//  Jarvis
//
//  Created by Gabriel Ulici on 6/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "PreferencesController.h"
#import "LoginItems.h"

@interface PreferencesController () <NSToolbarDelegate, NSTabViewDelegate, NSTableViewDataSource, NSTableViewDelegate, NSMenuDelegate >
@property (nonatomic, strong) IBOutlet NSToolbar *toolbar;
@property (nonatomic, strong) IBOutlet NSView *generalView, *updateView;
@property (nonatomic, strong) IBOutlet NSTabView *tabView;
@property (nonatomic, strong) IBOutlet NSButton *launchAtStartupButton;


@end

@implementation PreferencesController

- (id)initPreferencesController {
    if (self = [super initWithWindowNibName:@"PreferencesController"]) {
        // Initialization code here.
    }
    return self;
}

- (void)awakeFromNib {
    [self.toolbar setSelectedItemIdentifier:@"general"];
    [self selectGeneralTab:nil];
    
//    // if we don't have Notification Center available (pre-mountain-lion) then we can't select it
//    if (!HAS_NOTIFICATION_CENTER) {
//        // hide the fact that Growl exists (you don't have a choice now)
//        [self.notificationTypeButton removeItemAtIndex:0];
//        self.notificationTypeGrowlItem.title = @"Enabled";
//    }
//    
//    NotificationType notificationType = (NotificationType)[[NSUserDefaults standardUserDefaults] integerForKey:@"NotificationType"];
//    [self.notificationTypeButton selectItemWithTag:notificationType];
//    
//    KeyCombo combo;
//    combo.code = [[NSUserDefaults standardUserDefaults] integerForKey:@"OpenMenuKeyCode"];
//    combo.flags = [[NSUserDefaults standardUserDefaults] integerForKey:@"OpenMenuKeyFlags"];
//    if (combo.code > -1) [self.keyRecorderControl setKeyCombo:combo];
//    
        self.launchAtStartupButton.state = [LoginItems userLoginItems].currentAppLaunchesAtStartup ? NSOnState : NSOffState;
//    
//    self.hideDockIconButton.state = [[NSUserDefaults standardUserDefaults] boolForKey:@"HideDockIcon"] ? NSOnState : NSOffState;
}

- (void)showPreferences {
    // Transform process from background to foreground
	ProcessSerialNumber psn = { 0, kCurrentProcess };
	SetFrontProcess(&psn);
    
	[self.window center];
    
    [self.window makeKeyAndOrderFront:self];
    
#if DEBUG
    //[self.toolbar setSelectedItemIdentifier:@"accounts"];
   // [self selectAccountsTab:nil];
#ifdef ISOLATE_ACCOUNTS
   // [self addAccount:nil];
#endif
#else
    [self.window setLevel: NSTornOffMenuWindowLevel]; // a.k.a. "Always On Top"
#endif
}

- (void)resizeWindowForContentSize:(NSSize)size {
    static BOOL firstTime = YES;
	NSRect windowFrame = [NSWindow contentRectForFrameRect:[[self window] frame]
                                                 styleMask:[[self window] styleMask]];
	NSRect newWindowFrame = [NSWindow frameRectForContentRect:
                             NSMakeRect( NSMinX( windowFrame ), NSMaxY( windowFrame ) - size.height, size.width, size.height )
                                                    styleMask:[[self window] styleMask]];
	[[self window] setFrame:newWindowFrame display:YES animate:(!firstTime && [[self window] isVisible])];
    firstTime = NO;
}

- (IBAction)selectGeneralTab:(id)sender {
    [self.tabView selectTabViewItemWithIdentifier:@"general"];
    [self.generalView setHidden:YES];
    [self resizeWindowForContentSize:NSMakeSize(self.window.frame.size.width, 310)];
    [self performSelector:@selector(revealView:) withObject:self.generalView afterDelay:0.075];
}

- (IBAction)selectUpdateTab:(id)sender {
    [self.tabView selectTabViewItemWithIdentifier:@"update"];
    [self.updateView setHidden:YES];
    [self resizeWindowForContentSize:NSMakeSize(self.window.frame.size.width, 400)];
    [self performSelector:@selector(revealView:) withObject:self.updateView afterDelay:0.075];
}

- (void)revealView:(NSView *)view {
    [view setHidden:NO];
}

#pragma mark General
- (IBAction)launchAtStartupChanged:(id)sender
{
    [LoginItems userLoginItems].currentAppLaunchesAtStartup = (self.launchAtStartupButton.state == NSOnState);
}

//- (void)launchAtStartupChanged:(id)sender {
//    [LoginItems userLoginItems].currentAppLaunchesAtStartup = (self.launchAtStartupButton.state == NSOnState);
//}


#pragma mark Update

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

@end
