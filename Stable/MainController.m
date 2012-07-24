//
//  MainController.m
//  Jarvis
//
//  Created by Gabriel Ulici on 09/23/11.
//  Copyright (c) 2011-2012 Night Ideas Lab Inc. All rights reserved.
//

#import "MainController.h"
#import "PFMoveApplication.h"

#import <IOKit/IOMessage.h>
#import <Sparkle/Sparkle.h>

#define DONATE_URL  @"http://goo.gl/raHHq"
#define DONATE_NAG_TIME (60 * 60 * 24 * 7)

NSSpeechSynthesizer *synth;

@implementation MainController

+ (void) initialize
{
    [[NSUserDefaults standardUserDefaults] registerDefaults: [NSDictionary dictionaryWithContentsOfFile:
                                                              [[NSBundle mainBundle] pathForResource: @"Defaults" ofType: @"plist"]]];
    
    /*
    //make sure another instance of the app isn't running already
    BOOL othersRunning = NO;
    
    if ([NSApp isOnSnowLeopardOrBetter])
    {
        NSArray * apps = [NSRunningApplicationSL runningApplicationsWithBundleIdentifier: [[NSBundle mainBundle] bundleIdentifier]];
        othersRunning = [apps count] > 1;
    }
    else
    {
        NSString * bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
        const int processIdentifier = [[NSProcessInfo processInfo] processIdentifier];
        
        for (NSDictionary * dic in [[NSWorkspace sharedWorkspace] launchedApplications])
        {
            if ([[dic objectForKey: @"NSApplicationBundleIdentifier"] isEqualToString: bundleIdentifier]
                && [[dic objectForKey: @"NSApplicationProcessIdentifier"] intValue] != processIdentifier)
                othersRunning = YES;
        }
    }
    
    if (othersRunning)
    {
        NSAlert * alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle: NSLocalizedString(@"Quit", "Jarvis already running alert -> button")];
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
    
    //set custom value transformers
    ExpandedPathToPathTransformer * pathTransformer = [[[ExpandedPathToPathTransformer alloc] init] autorelease];
    [NSValueTransformer setValueTransformer: pathTransformer forName: @"ExpandedPathToPathTransformer"];
    
    ExpandedPathToIconTransformer * iconTransformer = [[[ExpandedPathToIconTransformer alloc] init] autorelease];
    [NSValueTransformer setValueTransformer: iconTransformer forName: @"ExpandedPathToIconTransformer"];
    
    //first message
    if ([[NSUserDefaults standardUserDefaults] boolForKey: @"WarningInfo"])
    {
        NSAlert * alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle: NSLocalizedString(@"I Accept", "Info alert -> button")];
        [alert addButtonWithTitle: NSLocalizedString(@"Quit", "Info alert -> button")];
        [alert setMessageText: NSLocalizedString(@"Welcome to Jarvis", "Info alert -> title")];
        [alert setInformativeText: NSLocalizedString(@"Jarvis is a personal assistent application."
                                                     " bla bla.",
                                                     "Info alert -> message")];
        [alert setAlertStyle: NSInformationalAlertStyle];
        
        if ([alert runModal] == NSAlertSecondButtonReturn)
            exit(0);
        [alert release];
        
        [[NSUserDefaults standardUserDefaults] setBool: NO forKey: @"WarningInfo"];
    }*/
}

- (id) init
{
    if ((self = [super init]))
    {
        fDefaults = [NSUserDefaults standardUserDefaults];
        
        //upgrading from old version clear recent items
        [[NSDocumentController sharedDocumentController] clearRecentDocuments: nil];
        [NSApp setDelegate: self];
         myPreferencesController = [[PreferencesController alloc] init];
        [[SUUpdater sharedUpdater] setDelegate: self];
        fQuitRequested = NO;
    }
    return self;
}

- (NSWindow *)windowLM {
	return windowLM;
}

- (IBAction)update:(id)sender;
{
	[synth stopSpeaking];
	[outText setString:@"Updating your report..."];
	[outText setNeedsDisplay:YES];
	[outText displayIfNeeded];
	[outText setNeedsDisplay:NO];
	[self jarvis];
}

- (IBAction)Homepage:(id)sender 
{
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: @"http://goo.gl/3ctJU"]];
}

- (IBAction)Issue:(id)sender 
{
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: @"http://goo.gl/1ye2X"]];
}

- (IBAction)ChangeLog:(id)sender 
{
    if (! myChangeLogController ) {
		myChangeLogController	= [[ChangeLogController alloc] init];
	} // end if
    [[myChangeLogController window] makeKeyAndOrderFront:self];
}

- (IBAction)Donate:(id)sender 
{
    [self linkDonate: self];
}

- (IBAction)showPreferencesWindow:(id)sender 
{
    if (! myPreferencesController ) 
    {
        myPreferencesController	= [[PreferencesController alloc] init];
	}
    [[myPreferencesController window] makeKeyAndOrderFront:self];
}

- (IBAction)showAboutWindow:(id)sender
{
    [[AboutController aboutController] showWindow: nil];
}

- (void)awakeFromNib
{
    [windowLM makeKeyAndOrderFront:self];
	NSLog(@"I have indeed been uploaded, sir. We're online and ready.");
	//[self setVolume:0.8];
	synth = [[NSSpeechSynthesizer alloc] init];
	[self jarvis];
}

- (void) applicationDidFinishLaunching: (NSNotification *) notification
{
    [NSApp setServicesProvider: self];
    
    //register for dock icon drags (has to be in applicationDidFinishLaunching: to work)
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler: self andSelector: @selector(handleOpenContentsEvent:replyEvent:)
                                                     forEventClass: kCoreEventClass andEventID: kAEOpenContents];
    //shamelessly ask for donations
    if ([fDefaults boolForKey: @"WarningDonate"])
    {
        const BOOL firstLaunch = [fDefaults boolForKey: @"FirstLaunch"];
        
        NSDate * lastDonateDate = [fDefaults objectForKey: @"DonateAskDate"];
        const BOOL timePassed = !lastDonateDate || (-1 * [lastDonateDate timeIntervalSinceNow]) >= DONATE_NAG_TIME;
        
        if (!firstLaunch && timePassed)
        {
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
    }
}

- (BOOL) applicationShouldHandleReopen: (NSApplication *) app hasVisibleWindows: (BOOL) visibleWindows
{
    NSWindow * mainWindow = [NSApp mainWindow];
    if (!mainWindow || ![mainWindow isVisible])
        [windowLM makeKeyAndOrderFront: nil];
    return NO;
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	// Offer to the move the Application if necessary.
	// Note that if the user chooses to move the application,
	// this call will never return. Therefore you can suppress
	// any first run UI by putting it after this call.
	
    PFMoveToApplicationsFolderIfNecessary();
	
	[windowLM center];
	[windowLM makeKeyAndOrderFront:self];
}

- (void) showMainWindow: (id) sender
{
    [windowLM makeKeyAndOrderFront: nil];
}

- (void) linkDonate: (id) sender
{
    [[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString: DONATE_URL]];
}

- (void)jarvis
{	
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
    
// Zipcode  and location for US weather (play with the weather addresses below for non-US locations)
//	NSString * zipCode = @"213490";
//	NSString * locationName = @"Rome, Italy";
	
// Junecloud username and password for package tracking
//	NSString * packageUserName = @"email@domail.com"; 
//	NSString * packagePassword = @"supersecretpassword";
  ////////////////////////////////

// Don't touch the rest unless you know what you are doing.
	NSString *text = [[NSString alloc] init];
	
// Time and date
	NSCalendarDate *date = [NSCalendarDate calendarDate];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	
	if([date hourOfDay]<4) text = @"Good night.\n";
	else if([date hourOfDay]<12) text = @"Good morning.\n";
	else if([date hourOfDay]<18) text = @"Good afternoon.\n";
	else text = @"Good evening.\n";
	
	text = [text stringByAppendingString:@"It is "];
	if([date minuteOfHour]<10)
		text = [text stringByAppendingString:[NSString stringWithFormat:@"%d:0%d.\n", [date hourOfDay], [date minuteOfHour]]];
	else
		text = [text stringByAppendingString:[NSString stringWithFormat:@"%d:%d.\n", [date hourOfDay], [date minuteOfHour]]];
	
	text = [text stringByAppendingString:@"Today is "];
	text = [text stringByAppendingString:[[dateFormatter standaloneMonthSymbols] objectAtIndex:[date monthOfYear]-1]];
	text = [text stringByAppendingString:[NSString stringWithFormat:@" %d, ", [date dayOfMonth]]];
	text = [text stringByAppendingString:[[dateFormatter standaloneWeekdaySymbols] objectAtIndex:[date dayOfWeek]%7]];
	text = [text stringByAppendingString:@".\n\n"];

// iCal events
    text = [text stringByAppendingString:@"\n"];
    text = [text stringByAppendingString:@"iCal Events: \n"];
	NSCalendarDate *endDate = [[NSCalendarDate dateWithYear:[date yearOfCommonEra] month:[date monthOfYear] day:[date dayOfMonth] hour:23 minute:59 second:59 timeZone:nil] retain];
	NSPredicate *predicate = [CalCalendarStore eventPredicateWithStartDate:date endDate:endDate calendars:[[CalCalendarStore defaultCalendarStore] calendars]];
	NSArray *events = [[CalCalendarStore defaultCalendarStore] eventsWithPredicate:predicate];
	for(int i=0; i<[events count]; i++)
	{
        
		if([[events objectAtIndex:i] isAllDay])
		{
			text = [text stringByAppendingString:[[events objectAtIndex:i] title]];
        }
		else
		{
			text = [text stringByAppendingString:@"There is, "];
			text = [text stringByAppendingString:[[events objectAtIndex:i] title]];
			text= [text stringByAppendingString:@", at "];
			NSCalendarDate *eventDate = [[[events objectAtIndex:i] startDate] dateWithCalendarFormat:nil timeZone:nil];
			if([eventDate minuteOfHour]<10)
				text = [text stringByAppendingString:[NSString stringWithFormat:@"%d:0%d", [eventDate hourOfDay], [eventDate minuteOfHour]]];
			else
				text = [text stringByAppendingString:[NSString stringWithFormat:@"%d:%d", [eventDate hourOfDay], [eventDate minuteOfHour]]];
		}
		text = [text stringByAppendingString:@".\n"];
	}

// iCal to-do
	text = [text stringByAppendingString:@"\n"];
    text = [text stringByAppendingString:@"To Do's: \n"];
    
	predicate = [CalCalendarStore taskPredicateWithCalendars:[[CalCalendarStore defaultCalendarStore] calendars]];
	NSArray *tasks = [[CalCalendarStore defaultCalendarStore] tasksWithPredicate:predicate];
	for(int i=0; i<[tasks count]; i++)
	{
		text = [text stringByAppendingString:@"You need to "];
		text = [text stringByAppendingString:[[tasks objectAtIndex:i] title]];
		text = [text stringByAppendingString:@".\n"];
	}
	/*
//Weather conditions
	NSString * weatherText = [[NSString alloc] init];
	NSString * weatherPage = [[NSString alloc] init];
	NSString * weatherContent = [[NSString alloc] init];
	weatherPage = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.accuweather.com/en-us/it/lazio/rome/quick-look.aspx?cityid=",zipCode]] encoding: NSUTF8StringEncoding error:nil];
	weatherContent = weatherPage;
	if(weatherContent!=nil)
	{
		if ([[weatherContent componentsSeparatedByString:@"<div id=\"quicklook_current_temps\">"] count]>1)
		{
		weatherText = [[weatherContent componentsSeparatedByString:@"<div id=\"quicklook_current_temps\">"] objectAtIndex:1];
		weatherText = [[weatherText componentsSeparatedByString:@"&"] objectAtIndex:0];
		text = [text stringByAppendingString:[NSString stringWithFormat:@"\nWeather in %@ is ",locationName]];
		text = [text stringByAppendingString:weatherText];
		text = [text stringByAppendingString:@" degrees.\n"];
		}
	}
	weatherPage = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.accuweather.com/en-us/it/lazio/rome/quick-look.aspx?cityid=",zipCode]] encoding: NSUTF8StringEncoding error:nil];
	weatherContent = weatherPage;
	if(weatherContent!=nil)
	{
		weatherContent = [[weatherContent componentsSeparatedByString:@"Low:&nbsp;"] objectAtIndex:0];
		if([[weatherContent componentsSeparatedByString:@"High:"] count]>1)
		{
			weatherText = [[weatherContent componentsSeparatedByString:@"High:"] objectAtIndex:1];
			weatherText = [[weatherText componentsSeparatedByString:@";\">"] objectAtIndex:1];
			weatherText = [[weatherText componentsSeparatedByString:@"</div>"] objectAtIndex:0];
			text = [text stringByAppendingString:weatherText];
			text = [text stringByAppendingString:@".\n"];
			
			text = [text stringByAppendingString:@"Temperature, will raise up to "];
			weatherText = [[weatherContent componentsSeparatedByString:@"High:"] objectAtIndex:1];
			weatherText = [[weatherText componentsSeparatedByString:@"&"] objectAtIndex:0];
			text = [text stringByAppendingString:weatherText];
			text = [text stringByAppendingString:@" degrees.\n"];
		}
		else
		{
			weatherContent = weatherPage;
			if(weatherContent!=nil)
			{
				weatherText = [[weatherContent componentsSeparatedByString:@"Low:&nbsp;"] objectAtIndex:1];
				weatherText = [[weatherText componentsSeparatedByString:@";\">"] objectAtIndex:1];
				weatherText = [[weatherText componentsSeparatedByString:@"</div>"] objectAtIndex:0];
				text = [text stringByAppendingString:weatherText];
				text = [text stringByAppendingString:@".\n"];
				
				text = [text stringByAppendingString:@"Temperature, will fall down to "];
				weatherText = [[weatherContent componentsSeparatedByString:@"Low:&nbsp;"] objectAtIndex:1];
				weatherText = [[weatherText componentsSeparatedByString:@"&"] objectAtIndex:0];
				text = [text stringByAppendingString:weatherText];
				text = [text stringByAppendingString:@" degrees.\n"];
			}
		}
	}
     */
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
	int mailCount;
	NSString * senderList = [[returnDescriptor stringValue] lowercaseString];
	for(int i=0; i<[vipNames count]; i++)
	{
		mailCount = 0;
		for(int j=0; j<[[vipAddresses objectAtIndex:i] count]; j++)
		{
			if([senderList rangeOfString:[[vipAddresses objectAtIndex:i] objectAtIndex:j]].location != NSNotFound)
			{mailCount = mailCount + [[senderList componentsSeparatedByString: [[vipAddresses objectAtIndex:i] objectAtIndex:j]] count] - 1;}
		}
		if (mailCount==1) text = [text stringByAppendingString:[NSString stringWithFormat:@"%d of them is from %@.\n", mailCount, [vipNames objectAtIndex:i]]];
		else if (mailCount>1) text = [text stringByAppendingString:[NSString stringWithFormat:@"%d of them are from %@.\n", mailCount, [vipNames objectAtIndex:i]]];
	}
	text = [text stringByAppendingString:@"\n"];
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
    
//NYTimes latest
    NSString * quoteContent1 = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://feeds.nytimes.com/nyt/rss/HomePage"] encoding: NSUTF8StringEncoding error:nil];
	if(quoteContent1!=nil)
	{
		text = [text stringByAppendingString:@"\nToday's Headlines from NYTimes:\n"];
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
		text = [text stringByAppendingString:@"\nToday's quotation from BrainyQuote.com:\n"];
		text = [text stringByAppendingString:[[[[quoteContent componentsSeparatedByString:@"<description>"] objectAtIndex:3] componentsSeparatedByString:@"</description>"] objectAtIndex:0]];
		text = [text stringByAppendingString:@"\n"];
		text = [text stringByAppendingString:[[[[quoteContent componentsSeparatedByString:@"<title>"] objectAtIndex:3] componentsSeparatedByString:@"</title>"] objectAtIndex:0]];
		text = [text stringByAppendingString:@".\n"];
	}
	
	[[NSURLCache sharedURLCache] removeAllCachedResponses];
	
//Output
	[window setFloatingPanel:NO];
	[outText setTextColor:[NSColor colorWithDeviceWhite:0.95 alpha:1]];
	[outText setString:text];
	[synth startSpeakingString:text];	//for speaking the text
}

/*
//Copy-pasted from .arri
//@ http://www.cocoadev.com/index.pl?SoundVolume
- (void)setVolume:(float)involume {
	OSStatus		err;
	AudioDeviceID	device;
	UInt32			size;
	Boolean			canset	= false;
	UInt32			channels[2];
	//float			volume[2];
	
	// get default device
	size = sizeof device;
	err = AudioHardwareGetProperty(kAudioHardwarePropertyDefaultOutputDevice, &size, &device);
	if(err!=noErr) {
		NSLog(@"audio-volume error get device");
		return;
	}
	
	
	// try set master-channel (0) volume
	size = sizeof canset;
	err = AudioDeviceGetPropertyInfo(device, 0, false, kAudioDevicePropertyVolumeScalar, &size, &canset);
	if(err==noErr && canset==true) {
		size = sizeof involume;
		err = AudioDeviceSetProperty(device, NULL, 0, false, kAudioDevicePropertyVolumeScalar, size, &involume);
		return;
	}
	
	// else, try seperate channels
	// get channels
	size = sizeof(channels);
	err = AudioDeviceGetProperty(device, 0, false, kAudioDevicePropertyPreferredChannelsForStereo, &size,&channels);
	if(err!=noErr) {
		NSLog(@"error getting channel-numbers");
		return;
	}
	
	// set volume
	size = sizeof(float);
	err = AudioDeviceSetProperty(device, 0, channels[0], false, kAudioDevicePropertyVolumeScalar, size, &involume);
	if(noErr!=err) NSLog(@"error setting volume of channel %d",channels[0]);
	err = AudioDeviceSetProperty(device, 0, channels[1], false, kAudioDevicePropertyVolumeScalar, size, &involume);
	if(noErr!=err) NSLog(@"error setting volume of channel %d",channels[1]);
	
}*/

- (void)windowDidLoad 
{
	NSLog(@"MainPanel did load");
   // [[self window] center];
}

@end