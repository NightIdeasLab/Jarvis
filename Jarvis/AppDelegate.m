//
//  AppDelegate.m
//  Jarvis
//
//  Created by Gabriel Ulici on 6/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <Sparkle/Sparkle.h>
#import <IOKit/IOMessage.h>

#define DONATE_URL  @"http://goo.gl/YzTfe"
#define DONATE_NAG_TIME (60 * 60 * 24 * 7)

#define SLOW_INTERNET 0 // 1 for YES 0 otherwise. Sometimes my internet connection suckes, in this way i can still code :)

NSSpeechSynthesizer *synth;

@implementation AppDelegate

@synthesize preferencesController = _preferencesController;
@synthesize changeLogController = _changeLogController;
@synthesize weatherImage;

- (NSWindow *) windowLM {
    // returns the main window
	return windowLM;
}

+ (void) initialize {
    //make sure another Jarvis.app isn't running already
    NSArray * apps = [NSRunningApplication runningApplicationsWithBundleIdentifier: [[NSBundle mainBundle] bundleIdentifier]];
    
    if ([apps count] > 1) {
        
        NSAlert * alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle: NSLocalizedString(@"OK", "Jarvis already running alert -> button")];
        [alert setMessageText: NSLocalizedString(@"Jarvis is already running.",
                                                 "Jarvis already running alert -> title")];
        [alert setInformativeText: NSLocalizedString(@"There is already a copy of Jarvis running. "
                                                     "This copy cannot be opened until that instance is quit.", "Jarvis already running alert -> message")];
        [alert setAlertStyle: NSCriticalAlertStyle];
        
        [alert runModal];
        
        //kill ourselves right away
        exit(0);
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults: [NSDictionary dictionaryWithContentsOfFile:
                                                              [[NSBundle mainBundle] pathForResource: @"Defaults" ofType: @"plist"]]];
}

- (id) init {
    if ((self = [super init])) {
        
        // initializing the preference plist
        fDefaults = [NSUserDefaults standardUserDefaults];

		[[NSUserDefaults standardUserDefaults] addObserver:self
												forKeyPath:@"woeidCode" options:( NSKeyValueObservingOptionOld |
																				 NSKeyValueObservingOptionNew )
												   context:NULL];

		[[NSUserDefaults standardUserDefaults] addObserver:self
												forKeyPath:@"PreferenceCloseTimeStamp" options:( NSKeyValueObservingOptionOld |
																				 NSKeyValueObservingOptionNew )
												   context:NULL];
        // upgrading from old version clear recent items
        [[NSDocumentController sharedDocumentController] clearRecentDocuments: nil];
        [NSApp setDelegate: self];
        
        // initializing the update system
        //[[SUUpdater sharedUpdater] setDelegate: self];
        [SUUpdater sharedUpdater];
    }
    return self;
}


// KVO handler
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
					   change:(NSDictionary *)change context:(void *)context
{
	// detect the change for the weather code
    if([keyPath isEqualToString:@"woeidCode"])
    {
        NSString *oldWoeidCode = [change objectForKey:NSKeyValueChangeOldKey];
        NSString *newWoeidCode = [change objectForKey:NSKeyValueChangeNewKey];

	#if DEBUG
		NSLog(@"old C: %@", oldWoeidCode);
		NSLog(@"new C: %@", newWoeidCode);
	#endif

		if (newWoeidCode != oldWoeidCode) {
			[self updateJarvisNOSpeech];
		}
    }

	// detect the close the preference window
	if([keyPath isEqualToString:@"PreferenceCloseTimeStamp"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
           [self updateJarvisNOSpeech];
        });
    }
}

- (void) awakeFromNib {
    
    [windowLM makeKeyAndOrderFront:self];
    
#if DEBUG
	NSLog(@"I have indeed been uploaded, sir. We're online and ready.");
#endif
    
    // allocationg the SpeechSyntesizer
	synth = [[NSSpeechSynthesizer alloc] init];
	[self jarvis:YES];
}

- (void) applicationWillFinishLaunching: (NSNotification *) aNotification {
	// Offer to the move the Application if necessary.
	// Note that if the user chooses to move the application,
	// this call will never return. Therefore you can suppress
	// any first run UI by putting it after this call.
	
    //PFMoveToApplicationsFolderIfNecessary();
    [windowLM makeKeyAndOrderFront:self];
}

- (void) applicationDidFinishLaunching: (NSNotification *) aNotification {

    [NSApp setServicesProvider: self];

    // register for dock icon drags (has to be in applicationDidFinishLaunching: to work)
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler: self andSelector: @selector(handleOpenContentsEvent:replyEvent:)
                                                     forEventClass: kCoreEventClass andEventID: kAEOpenContents];
    
    // shamelessly ask for donations
    if ([fDefaults boolForKey: @"WarningDonate"]) {
        
        const BOOL firstLaunch = [fDefaults boolForKey: @"FirstLaunch"];
        
        NSDate * lastDonateDate = [fDefaults objectForKey: @"DonateAskDate"];
        
        const BOOL timePassed = !lastDonateDate || (-1 * [lastDonateDate timeIntervalSinceNow]) >= DONATE_NAG_TIME;
        
        if (!firstLaunch && timePassed) {
            
            [fDefaults setObject: [NSDate date] forKey: @"DonateAskDate"];
            
            NSAlert * alert = [[NSAlert alloc] init];
            [alert setMessageText: NSLocalizedString(@"Support open-source indie software", "Donation beg -> title")];
            
            NSString * donateMessage = [NSString stringWithFormat: @"%@\n\n%@",
                                        NSLocalizedString(@"Jarvis is a personal assistent application."
                                                          " A lot of time and effort have gone into development, coding, and refinement."
                                                          " If you enjoy using it, please consider showing your love with a donation.", "Donation beg -> message"),
                                        NSLocalizedString(@"Donate or not, there will be no difference to your experience.", "Donation beg -> message")];
            
            [alert setInformativeText: donateMessage];
            [alert setAlertStyle: NSInformationalAlertStyle];
            
            [alert addButtonWithTitle: NSLocalizedString(@"Donate", "Donation beg -> button")];
            NSButton * noDonateButton = [alert addButtonWithTitle: NSLocalizedString(@"Nope", "Donation beg -> button")];
            [noDonateButton setKeyEquivalent: @"\e"]; //escape key
            
            const BOOL allowNeverAgain = lastDonateDate != nil; //hide the "don't show again" check the first time - give them time to try the app
            [alert setShowsSuppressionButton: allowNeverAgain];
            if (allowNeverAgain)
                [[alert suppressionButton] setTitle: NSLocalizedString(@"Don't bug me about this ever again.", "Donation beg -> button")];
            
            const NSInteger donateResult = [alert runModal];
            if (donateResult == NSAlertFirstButtonReturn)
                [self linkDonate: self];
            
            if (allowNeverAgain)
                [fDefaults setBool: ([[alert suppressionButton] state] != NSOnState) forKey: @"WarningDonate"];
            
            [fDefaults setBool: NO forKey: @"FirstLaunch"];
        }
    }
}

- (BOOL) applicationShouldHandleReopen: (NSApplication *) app hasVisibleWindows: (BOOL) visibleWindows {
    // If we close the main window this will
    // make it reappear if we press the dock icon
    if(visibleWindows == NO) {
        [windowLM makeKeyAndOrderFront:self];
	}
	return YES;
}

- (NSMenu *) applicationDockMenu: (NSApplication *) sender {
    
    NSMenu * menu = [[NSMenu alloc] init];
    
    [menu addItemWithTitle: NSLocalizedString(@"Speaking", "Dock item") action: @selector(updateJarvis:) keyEquivalent: @""];
    [menu addItemWithTitle: NSLocalizedString(@"Mute", "Dock item") action: @selector(stopSpeech:) keyEquivalent: @""];
    [menu addItemWithTitle: NSLocalizedString(@"Refresh", "Dock item") action: @selector(updateJarvis:) keyEquivalent: @""];
    
    return menu;
}

- (IBAction)openAboutPanel:(id)sender {
    //	Hide the scroller, in case they’re previously shown it.
    //	In a real application, you wouldn’t need to do this.
    [[AboutPanelController sharedInstance] setShowsScroller: NO];
    
    //	Show the panel
    [[AboutPanelController sharedInstance] showPanel];
}

- (IBAction) openPreferences: (id) sender {
    // instantiate preferences window controller
    if (_preferencesController) {
        //[_preferencesController release];
        _preferencesController = nil;
    }    
    // init from nib but the real initialization happens in the
    // PreferencesWindowController setupToolbar method
    _preferencesController = [[PreferencesController alloc] initWithWindowNibName:@"PreferencesController"];
    
    [_preferencesController showWindow:self];
}

- (IBAction) sendFeedBack: (id) sender {
    //activates the FeedBack Window
    [JRFeedbackController showFeedback];
}

- (IBAction) openHomepage: (id) sender {
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: @"http://goo.gl/UIeKn"]];
}

- (IBAction) openIssue: (id) sender {
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: @"http://goo.gl/4TCve"]];
}

- (IBAction) openChangeLog: (id) sender {
    
    if (_changeLogController) {
        _changeLogController = nil;
    }
    _changeLogController = [[ChangeLogController alloc] initWithWindowNibName:@"ChangeLogController"];
    
    [_changeLogController showWindow:nil];
}

- (IBAction) openDonate: (id) sender {
    [self linkDonate: self];
}

// FIXME: It has a leak release the text
- (IBAction) updateJarvis: (id) sender {

	[synth stopSpeaking];
	[outText setString:@"Updating your report..."];
	[outText setNeedsDisplay:YES];
	[outText displayIfNeeded];
	[outText setNeedsDisplay:NO];
	[self jarvis:YES];
}

- (void) updateJarvisNOSpeech {

	[synth stopSpeaking];
	[outText setString:@"Updating your report..."];
	[outText setNeedsDisplay:YES];
	[outText displayIfNeeded];
	[outText setNeedsDisplay:NO];
	[self jarvis:YES];
}

- (IBAction) stopSpeech: (id) sender {
    [synth stopSpeaking];
}

- (void) linkDonate: (id) sender {
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: DONATE_URL]];
}

- (void) jarvis: (BOOL) speak {
    
    @autoreleasepool {
        
        defaults = [NSUserDefaults standardUserDefaults];
    
        const BOOL useCal = [defaults boolForKey: @"UseCal"];
        const BOOL useWeather = [defaults boolForKey: @"UseWeather"];
        const BOOL useMail = [defaults boolForKey: @"UseMail"];
        const BOOL useNews = [defaults boolForKey: @"UseNewsQuotes"];
    
        const BOOL checkForActiveAccount = [defaults boolForKey: @"checkForActiveAccount"];
    
        NSString *outputText = [[NSString alloc] init];
        
        TimeAndDateMethod *timeAndDate = [[TimeAndDateMethod alloc] init];
        
        outputText = [outputText stringByAppendingString:[timeAndDate retrieveTimeAndDate]];
        if (useCal) {
            CalendarMethod *calendar = [[CalendarMethod alloc] init];
        
            outputText = [outputText stringByAppendingString:[calendar retrieveiCalEvents]];
            outputText = [outputText stringByAppendingString:[calendar retrieveReminders]];
        }
    #if !SLOW_INTERNET
        if (useWeather) {
            WeatherMethod *weather = [[WeatherMethod alloc] init];

            NSDictionary *result = [weather retrieveWeather];

            outputText = [outputText stringByAppendingString:[result objectForKey:@"outputWeatherText"]];

            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[result objectForKey:@"weatherImage"]]];
            NSData *data = [[NSData alloc] initWithContentsOfURL:url];
            NSImage *tempImage = [[NSImage alloc] initWithData:data];
            [weatherImage setImage:tempImage];
        }
    #endif
        if (useMail) {
            EmailMethod *email = [[EmailMethod alloc] init];
        
            outputText = [outputText stringByAppendingString:[email retrieveEmail]];
        } else if (!checkForActiveAccount) {
            EmailMethod *email = [[EmailMethod alloc] init];
            
            [email checkForActiveAccount];
        }
    #if !SLOW_INTERNET
        if (useNews){
            NewsAndQuoteMethod *newsAndQuote = [[NewsAndQuoteMethod alloc] init];
        
            // NYTimes
            outputText = [outputText stringByAppendingString:[newsAndQuote retrieveNYTimes]];
        
            // Daily Quote
            outputText = [outputText stringByAppendingString:[newsAndQuote retrieveDailyQuote]];
        }
    #endif
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        // If set to YES then the mainwindow will
        // be on top of the other windows and there
        // is no way to send it to the back
        [window setFloatingPanel:NO];
        
        //Output
        [outText setFont:[NSFont fontWithName:@"HelveticaNeue-Light" size:12]];
        [outText setTextColor:[NSColor colorWithDeviceWhite:0.95 alpha:1]];
        [outText setString:outputText];

        if (speak) {
        #if !DEBUG
            [synth startSpeakingString:outputText];	//for speaking the text
        #endif
        }
    }
}
@end