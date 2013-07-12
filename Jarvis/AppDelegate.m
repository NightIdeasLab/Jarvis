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
#define woeidCode @"721943" //this is the code for weather you can find yours at http://sigizmund.info/woeidinfo/

#define SLOW_INTERNET 1 // Sometimes my internet connection suckes and in this way i can still work :)


NSSpeechSynthesizer *synth;

@implementation AppDelegate

@synthesize preferencesController = _preferencesController;

- (void)dealloc {
    // should kill variables on exit
    [windowLM release];
    [_preferencesController release];
    [super dealloc];
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
        [alert release];
        
        //kill ourselves right away
        exit(0);
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults: [NSDictionary dictionaryWithContentsOfFile:
                                                              [[NSBundle mainBundle] pathForResource: @"Defaults" ofType: @"plist"]]];
}

- (NSWindow *)windowLM {
    // returns the main window
	return windowLM;
}

- (id) init {
    if ((self = [super init])) {
        
        // initializing the preference plist
        fDefaults = [NSUserDefaults standardUserDefaults];
        
        // upgrading from old version clear recent items
        [[NSDocumentController sharedDocumentController] clearRecentDocuments: nil];
        [NSApp setDelegate: self];

        // initializing the update system
        [[SUUpdater sharedUpdater] setDelegate: self]; // trows a c++ exception
        //fQuitRequested = NO; // i have no idea
    }
    return self;
}

- (void)awakeFromNib {
    
    [windowLM makeKeyAndOrderFront:self];
	NSLog(@"I have indeed been uploaded, sir. We're online and ready.");
	synth = [[NSSpeechSynthesizer alloc] init]; // trows a c++ exception
	[self jarvis];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    [NSApp setServicesProvider: self];
    
    //register for dock icon drags (has to be in applicationDidFinishLaunching: to work)
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler: self andSelector: @selector(handleOpenContentsEvent:replyEvent:)
                                                     forEventClass: kCoreEventClass andEventID: kAEOpenContents];
    
    //shamelessly ask for donations
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
            
            [alert release];
            [fDefaults setBool: NO forKey: @"FirstLaunch"];
        }
        // Just a test need to remove adds a int into the app preference file
        if (!firstLaunch) {
            
            [fDefaults setInteger:721943 forKey: @"LocationCode"];
        }
    }
}

- (BOOL) applicationShouldHandleReopen: (NSApplication *) app hasVisibleWindows: (BOOL) visibleWindows {
    // If we close the main window this will
    // make it reapear if we press the dock icon
    if(visibleWindows == NO) {
       [windowLM makeKeyAndOrderFront:self];
	}
	return YES;
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	// Offer to the move the Application if necessary.
	// Note that if the user chooses to move the application,
	// this call will never return. Therefore you can suppress
	// any first run UI by putting it after this call.
	
    //PFMoveToApplicationsFolderIfNecessary();
	
	//[windowLM center];
	[windowLM makeKeyAndOrderFront:self];
}

- (IBAction)openPreferences:(id)sender {
    
    //activate app
    [NSApp activateIgnoringOtherApps:YES];
    
    //instantiate preferences window controller
    if (_preferencesController) {
        [_preferencesController release];
        _preferencesController = nil;
    }
    
    //init from nib but the real initialization happens in the
    //PreferencesWindowController setupToolbar method
    _preferencesController = [[PreferencesController alloc] initWithWindowNibName:@"PreferencesController"];
    
    [_preferencesController showWindow:self];
    //[[PreferencesWindowController sharedPrefsWindowController] showWindow:self];
}

- (IBAction)sendFeedBack:(id)sender {
    
    //activates the FeedBack Window
    [JRFeedbackController showFeedback];
}

- (NSMenu *) applicationDockMenu: (NSApplication *) sender {
    
    NSMenu * menu = [[NSMenu alloc] init];
    
    [menu addItemWithTitle: NSLocalizedString(@"Speaking", "Dock item") action: @selector(update:) keyEquivalent: @""];
    [menu addItemWithTitle: NSLocalizedString(@"Mute", "Dock item") action: @selector(stopSpeech:) keyEquivalent: @""];
    [menu addItemWithTitle: NSLocalizedString(@"Refresh", "Dock item") action: @selector(update:) keyEquivalent: @""];
    
    return [menu autorelease];
}

- (IBAction)update:(id)sender; {
    
	[synth stopSpeaking];
	[outText setString:@"Updating your report..."];
	[outText setNeedsDisplay:YES];
	[outText displayIfNeeded];
	[outText setNeedsDisplay:NO];
	[self jarvis];
}

- (IBAction)Homepage:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: @"http://goo.gl/UIeKn"]];
}

- (IBAction)Issue:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: @"http://goo.gl/4TCve"]];
}

- (IBAction)ChangeLog:(id)sender {
//    if (! myChangeLogController ) {
//		myChangeLogController	= [[ChangeLogController alloc] init];
//	} // end if
//    [[myChangeLogController window] makeKeyAndOrderFront:self];
}

- (IBAction)Donate:(id)sender {
    [self linkDonate: self];
}

- (void) showMainWindow: (id) sender {
    [windowLM makeKeyAndOrderFront: nil];
}

- (void) linkDonate: (id) sender {
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: DONATE_URL]];
}

- (void)jarvis {
    
    //////////////////////////////
    // Personalization parameters:
    // VIP names and email addresses
	NSArray * vipNames = [NSArray arrayWithObjects: @"GMail", @"Yahoo1", @"Yahoo", @"Me", nil];
	NSArray * vipAddresses = [NSArray arrayWithObjects: \
							  [NSArray arrayWithObjects: @"test@gmail.com", nil],\
							  [NSArray arrayWithObjects: @"test@yahoo.com", nil],\
							  [NSArray arrayWithObjects: @"test@yahoo.com", nil],\
							  [NSArray arrayWithObjects: @"test@me.com", nil]\
							  , nil];
    
    // Junecloud username and password for package tracking Does Not Work
    //	NSString * packageUserName = @"email@domail.com";
    //	NSString * packagePassword = @"supersecretpassword";
    ////////////////////////////////
    
    // Don't touch the rest unless you know what you are doing.
	NSString *text = [[NSString alloc] init];
	
    // Time and date
	NSCalendarDate *date = [NSCalendarDate calendarDate];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	if([date hourOfDay]<4) text = NSLocalizedString(@"Good night, ", @"Greeting in the night");
	else if([date hourOfDay]<12) text = NSLocalizedString(@"Good morning, ", @"Greeting in the morning");
	else if([date hourOfDay]<18) text = NSLocalizedString(@"Good afternoon, ", @"Greeting in the afternoon");
	else text = NSLocalizedString(@"Good evening, ", @"Greeting in the evening");
    
    //Reading the username
    text = [text stringByAppendingString: NSUserName()];
    text = [text stringByAppendingString:@". "];
    
	
	text = [text stringByAppendingString: NSLocalizedString(@"It is ", @"Declares the time. Ex. It is 19:30")];
	if([date minuteOfHour]<10)
		text = [text stringByAppendingString:[NSString stringWithFormat:@"%ld:0%ld.\n", [date hourOfDay], [date minuteOfHour]]];
	else
		text = [text stringByAppendingString:[NSString stringWithFormat:@"%ld:%ld.\n", [date hourOfDay], [date minuteOfHour]]];
	
	text = [text stringByAppendingString:NSLocalizedString(@"Today is ", @"Declares the day")];
	text = [text stringByAppendingString:[[dateFormatter standaloneMonthSymbols] objectAtIndex:[date monthOfYear]-1]];
	text = [text stringByAppendingString:[NSString stringWithFormat:@" %ld, ", [date dayOfMonth]]];
	text = [text stringByAppendingString:[[dateFormatter standaloneWeekdaySymbols] objectAtIndex:[date dayOfWeek]%7]];
	text = [text stringByAppendingString:@".\n"];
    
    // iCal events
    text = [text stringByAppendingString:@"\n"];
	NSCalendarDate *endDate = [[NSCalendarDate dateWithYear:[date yearOfCommonEra] month:[date monthOfYear] day:[date dayOfMonth] hour:23 minute:59 second:59 timeZone:nil] retain];
	NSPredicate *predicate = [CalCalendarStore eventPredicateWithStartDate:date endDate:endDate calendars:[[CalCalendarStore defaultCalendarStore] calendars]];
	NSArray *events = [[CalCalendarStore defaultCalendarStore] eventsWithPredicate:predicate];
    if ([events count] == 0)
    {
        text = [text stringByAppendingString:NSLocalizedString(@"You do not have any apoiments today!!!\n", @"This message will appear if you do not have any apoiments")];
    }
    else
    {
        for(int i=0; i<[events count]; i++)
        {
            if([[events objectAtIndex:i] isAllDay])
            {
                text = [text stringByAppendingString:NSLocalizedString(@"There is, ", @"")];
                text = [text stringByAppendingString:[[events objectAtIndex:i] title]];
                text = [text stringByAppendingString:NSLocalizedString(@", all day", @"")];
            }
            else
            {
                text = [text stringByAppendingString:NSLocalizedString(@"There is, ", @"")];
                text = [text stringByAppendingString:[[events objectAtIndex:i] title]];
                text = [text stringByAppendingString:NSLocalizedString(@", at ", @"")];
                NSCalendarDate *eventDate = [[[events objectAtIndex:i] startDate] dateWithCalendarFormat:nil timeZone:nil];
                if([eventDate minuteOfHour]<10)
                    text = [text stringByAppendingString:[NSString stringWithFormat:@"%ld:0%ld", [eventDate hourOfDay], [eventDate minuteOfHour]]];
                else
                    text = [text stringByAppendingString:[NSString stringWithFormat:@"%ld:%ld", [eventDate hourOfDay], [eventDate minuteOfHour]]];
            }
            text = [text stringByAppendingString:@".\n"];
        }
    }
    
    // iCal Reminders
	text = [text stringByAppendingString:@"\n"];
	predicate = [CalCalendarStore taskPredicateWithCalendars:[[CalCalendarStore defaultCalendarStore] calendars]];
	NSArray *tasks = [[CalCalendarStore defaultCalendarStore] tasksWithPredicate:predicate];
    if ([tasks count] == 0)
    {
   		text = [text stringByAppendingString:NSLocalizedString(@"You do not have any reminders today!!!\n", @"")];
    }
    else
    {
        for(int i=0; i<[tasks count]; i++)
        {
            text = [text stringByAppendingString:NSLocalizedString(@"You need to ", @"")];
            text = [text stringByAppendingString:[[tasks objectAtIndex:i] title]];
            text = [text stringByAppendingString:@".\n"];
        }
    }
    
#if !SLOW_INTERNET
    
    //Weather conditions
	NSString * weatherText = [[NSString alloc] init];
	NSString * weatherPage = [[NSString alloc] init];
   	NSString * cityName = [[NSString alloc] init];
    NSString * countryName = [[NSString alloc] init];
	NSString * weatherContent = [[NSString alloc] init];
	weatherPage = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@&u=c",woeidCode]] encoding: NSUTF8StringEncoding error:nil];
	weatherContent = weatherPage;
	if(weatherContent != nil)
	{
		if ([[weatherContent componentsSeparatedByString:@"<b>Current Conditions:</b><br />"] count]>1)
		{
            cityName = [[weatherContent componentsSeparatedByString:@"<title>Yahoo! Weather - "] objectAtIndex:1];
            cityName = [[cityName componentsSeparatedByString:@","] objectAtIndex:0];
            countryName = [[weatherContent componentsSeparatedByString:@"country=\""] objectAtIndex:1];
            countryName = [[countryName componentsSeparatedByString:@"\"/>"] objectAtIndex:0];
            weatherText = [[weatherContent componentsSeparatedByString:@"<b>Current Conditions:</b><br />"] objectAtIndex:1];
            weatherText = [[weatherText componentsSeparatedByString:@"<BR />"] objectAtIndex:0];
            
            text = [text stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"\nWeather in %@, %@ is : ", @""),cityName, countryName]];
            
            //Removing white spaces from the begining or end of the sting retrived
            NSString *trimmedString = [weatherText stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            text = [text stringByAppendingString:trimmedString];
            text = [text stringByAppendingString:@".\n"];
		}
	}

    
    //Forecast for the next 5 days
	weatherPage = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%@&u=c",woeidCode]] encoding: NSUTF8StringEncoding error:nil];
	weatherContent = weatherPage;
    
    text = [text stringByAppendingString:NSLocalizedString(@"Forecast for the next 5 days: \n", @"")];
    if(weatherContent != nil)
	{
		if ([[weatherContent componentsSeparatedByString:@"<BR /><b>Forecast:</b><BR />"] count]>1)
		{
            weatherText = [[weatherContent componentsSeparatedByString:@"<BR /><b>Forecast:</b><BR />"] objectAtIndex:1];
            weatherText = [[weatherText componentsSeparatedByString:@"<a href="] objectAtIndex:0];
            
            //Removing white spaces from the begining or end of the sting retrived
            NSString *trimmedString = [weatherText stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            //removing the <br /> from the text
            NSString *trimmedString1 = [trimmedString
                                        stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
            
            text = [text stringByAppendingString:trimmedString1];
		}
	}
#endif
    
    //Unread email count
	NSDictionary* errorDict;
    NSAppleEventDescriptor* returnDescriptor = NULL;
	NSAppleScript* scriptObject = [[NSAppleScript alloc] initWithSource:
								   @"\
								   tell application \"Mail\"\n\
								   set unreadCount to unread count of inbox\n\
								   set senders to (sender of messages of inbox whose read status is false)\n\
								   if unreadCount is 0 then\n\
								   set output to \"You have no, new email.\n\"\n\
								   else if unreadCount is 1 then\n\
								   set output to \"You have \" & unreadCount & \", new email.\n\"\n\
								   else\n\
								   set output to \"You have \" & unreadCount & \", new emails.\n\"\n\
								   end if\n\
								   repeat with sender in senders\n\
								   set output to output & \"###\" & sender\n\
								   end repeat\n\
								   return {output}\n\
								   end tell\
								   "];
	
    returnDescriptor = [scriptObject executeAndReturnError: &errorDict];
	[scriptObject release];
	text = [text stringByAppendingString:@"\n"];
	text = [text stringByAppendingString:[[[returnDescriptor stringValue] componentsSeparatedByString:@"###"] objectAtIndex:0]];
	
    //VIP email count
	unsigned long mailCount;
	NSString * senderList = [[returnDescriptor stringValue] lowercaseString];
	for(int i=0; i<[vipNames count]; i++)
	{
		mailCount = 0;
		for(int j=0; j<[[vipAddresses objectAtIndex:i] count]; j++)
		{
			if([senderList rangeOfString:[[vipAddresses objectAtIndex:i] objectAtIndex:j]].location != NSNotFound)
			{mailCount = mailCount + [[senderList componentsSeparatedByString: [[vipAddresses objectAtIndex:i] objectAtIndex:j]] count] - 1;}
		}
		if (mailCount==1) text = [text stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"%d of them is from %@.\n", @""), mailCount, [vipNames objectAtIndex:i]]];
		else if (mailCount>1) text = [text stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"%d of them are from %@.\n", @""), mailCount, [vipNames objectAtIndex:i]]];
	}
    
	/*
     //Package tracker
     NSMutableURLRequest * packagePageRequest = [[NSMutableURLRequest alloc] init];
     [packagePageRequest setURL: [NSURL URLWithString:@"https://junecloud.com/sync/deliveries/"]];
     [packagePageRequest setHTTPMethod:@"POST"];
     NSString *requestBody = [NSString stringWithFormat:@"cmd=login&type=web&email=%@&password=%@&newpassword=&confirmpass=&name=", packageUserName, packagePassword];
     [packagePageRequest setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
     NSData * packageData = [NSURLConnection sendSynchronousRequest:packagePageRequest returningResponse:nil error:NULL];
     NSString * packagePageContent = [[NSString alloc] initWithData:packageData encoding:NSUTF8StringEncoding];
     
     NSString * packageName = [[NSString alloc] init];
     NSString * packageNumber = [[NSString alloc] init];
     NSString * packageStatus = [[NSString alloc] init];
     NSString * statusAddress = [[NSString alloc] init];
     
     if(packagePageContent!=nil)
     {
     for(int i=1; i<[[packagePageContent componentsSeparatedByString:@"<div class=\"delivery\">"] count]; i++)
     {
     packageNumber = [[[[[[packagePageContent componentsSeparatedByString:@"<div class=\"delivery\">"] objectAtIndex:i]componentsSeparatedByString:@")"] objectAtIndex:0] componentsSeparatedByString:@"("] objectAtIndex:1];
     statusAddress = @"http://boxoh.com/?t=";
     statusAddress = [statusAddress stringByAppendingString:packageNumber];
     statusAddress = [NSString stringWithContentsOfURL:[NSURL URLWithString:statusAddress] encoding: NSUTF8StringEncoding error:nil];
     if([[statusAddress componentsSeparatedByString:@"info\">"] count]>1 && [[statusAddress componentsSeparatedByString:@"loc\">"] count]>1)
     {
     text = [text stringByAppendingString:@"Your "];
     packageName = [[[[[[packagePageContent componentsSeparatedByString:@"<div class=\"delivery\">"] objectAtIndex:i]componentsSeparatedByString:@"<span"] objectAtIndex:0] componentsSeparatedByString:@"<h4>"] objectAtIndex:1];
     text = [text stringByAppendingString:packageName];
     text = [text stringByAppendingString:@" package is, "];
     
     packageStatus = [[[[statusAddress componentsSeparatedByString:@"info\">"] objectAtIndex:1]componentsSeparatedByString:@"</span>"] objectAtIndex:0];
     text = [text stringByAppendingString:packageStatus];
     text = [text stringByAppendingString:@" at, "];
     packageStatus = [[[[statusAddress componentsSeparatedByString:@"loc\">"] objectAtIndex:1]componentsSeparatedByString:@"</span>"] objectAtIndex:0];
     
     NSArray *abbrArray = [NSArray arrayWithObjects:@"AL",  @"AK",  @"AZ",  @"AR",  @"CA",  @"CO",  @"CT",  @"DE",  @"FL",  @"GA",  @"HI",  @"ID",  @"IL",  @"IN",  @"IA",  @"KS",  @"KY",  @"LA",  @"ME",  @"MD",  @"MA",  @"MI",  @"MN",  @"MS",  @"MO",  @"MT",  @"NE",  @"NV",  @"NH",  @"NJ",  @"NM",  @"NY",  @"NC",  @"ND",  @"OH",  @"OK",  @"OR",  @"PA",  @"RI",  @"SC",  @"SD",  @"TN",  @"TX",  @"UT",  @"VT",  @"VA",  @"WA",  @"WV",  @"WI",  @"WY", nil];
     NSArray *nameArray = [NSArray arrayWithObjects:@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming", nil];
     for(int i=1; i<[abbrArray count]; i++)
     {
     if([packageStatus hasSuffix:[abbrArray objectAtIndex:i]]) packageStatus = [[[packageStatus componentsSeparatedByString:[abbrArray objectAtIndex:i]] objectAtIndex:0] stringByAppendingString: [nameArray objectAtIndex:i]];
     }
     text = [text stringByAppendingString:packageStatus];
     text = [text stringByAppendingString:@".\n"];
     }
     
     }
     }
     */
    /*
     //Wikinews headlines
     NSString * newsContent = [[NSString alloc] init];
     NSString * newsEntry = [[NSString alloc] init];
     NSString * allNews = [[NSString alloc] init];
     newsContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://en.wikinews.org/wiki/Template:Latest_news"] encoding: NSUTF8StringEncoding error:nil];
     if(newsContent!=nil)
     {
     newsContent = [[newsContent componentsSeparatedByString:@"</span>"] objectAtIndex:3];
     allNews=@"";
     for(int i=0;i<[[newsContent componentsSeparatedByString:@"</a></li>"] count];i++)
     {
     newsEntry = [[[[newsContent componentsSeparatedByString:@"</a></li>"] objectAtIndex:i] componentsSeparatedByString:@"\">"] objectAtIndex:1];
     if(![newsEntry hasPrefix:@"Wikinews Shorts:"] && ![newsEntry hasPrefix:@"<"])
     {
     allNews = [allNews stringByAppendingString:newsEntry];
     allNews = [allNews stringByAppendingString:@".\n"];
     }
     }
     if(allNews==@"")
     {
     newsContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://en.wikinews.org/wiki/Template:Latest_news"] encoding: NSUTF8StringEncoding error:nil];
     if(newsContent!=nil)
     {
     newsContent = [[newsContent componentsSeparatedByString:@"</span>"] objectAtIndex:1];
     for(int i=0;i<[[newsContent componentsSeparatedByString:@"</a></li>"] count];i++)
     {
     newsEntry = [[[[newsContent componentsSeparatedByString:@"</a></li>"] objectAtIndex:i] componentsSeparatedByString:@"\">"] objectAtIndex:1];
     if(![newsEntry hasPrefix:@"Wikinews Shorts:"] && ![newsEntry hasPrefix:@"<li>"])
     {
     allNews = [allNews stringByAppendingString:newsEntry];
     allNews = [allNews stringByAppendingString:@".\n"];
     }
     }
     }
     }
     if(allNews!=@"")
     {
     text = [text stringByAppendingString:@"\nToday's headlines:\n"];
     text = [text stringByAppendingString:allNews];
     }
     }*/

#if !SLOW_INTERNET
    //NYTimes latest
    NSString * quoteContent1 = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://feeds.nytimes.com/nyt/rss/HomePage"] encoding: NSUTF8StringEncoding error:nil];
	if(quoteContent1!=nil)
	{
		text = [text stringByAppendingString:NSLocalizedString(@"\nToday's Headlines from NYTimes:\n", @"")];
		text = [text stringByAppendingString:[[[[quoteContent1 componentsSeparatedByString:@"<title>"] objectAtIndex:3] componentsSeparatedByString:@"</title>"] objectAtIndex:0]];
        //text = [text stringByAppendingString:[[[[quoteContent componentsSeparatedByString:@"<link>"] objectAtIndex:3] componentsSeparatedByString:@"</link>"] objectAtIndex:0]];
		text = [text stringByAppendingString:@".\n"];
		text = [text stringByAppendingString:[[[[quoteContent1 componentsSeparatedByString:@"<title>"] objectAtIndex:4] componentsSeparatedByString:@"</title>"] objectAtIndex:0]];
		text = [text stringByAppendingString:@".\n"];
	}
    
    //Daily quotation
	NSString * quoteContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://feeds.feedburner.com/brainyquote/QUOTEBR"] encoding: NSUTF8StringEncoding error:nil];
	if(quoteContent!=nil)
	{
		text = [text stringByAppendingString:NSLocalizedString(@"\nToday's quotation from BrainyQuote.com:\n", @"")];
		text = [text stringByAppendingString:[[[[quoteContent componentsSeparatedByString:@"<description>"] objectAtIndex:3] componentsSeparatedByString:@"</description>"] objectAtIndex:0]];
		text = [text stringByAppendingString:@"\n"];
		text = [text stringByAppendingString:[[[[quoteContent componentsSeparatedByString:@"<title>"] objectAtIndex:3] componentsSeparatedByString:@"</title>"] objectAtIndex:0]];
		text = [text stringByAppendingString:@".\n"];
	}
    
#endif
    
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
	
    //Output
	[window setFloatingPanel:NO];
	[outText setTextColor:[NSColor colorWithDeviceWhite:0.95 alpha:1]];
	[outText setString:text];
	[synth startSpeakingString:text];	//for speaking the text
}

- (IBAction)stopSpeech:(id)sender {
    [synth stopSpeaking];
}

@end
