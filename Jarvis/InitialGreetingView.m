//
//  InitialGreetingView.m
//  Jarvis
//
//  Created by Darrin Dickey on 10/3/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "InitialGreetingView.h"

@implementation InitialGreetingView : NSView

@synthesize weatherImage;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)rect
{
    //NSString              * hws = @"";
    NSPoint                 p;
    NSMutableDictionary   * attribs;
    NSColor               * c;
    NSFont                * fnt;
    
    NSString *outputText = [[NSString alloc] init];
    
    //Begin Time and Date Method
    
    TimeAndDateMethod *timeAndDate = [[TimeAndDateMethod alloc] init];
    
    outputText = [outputText stringByAppendingString:[timeAndDate getTimeAndDate]];
    
    
    //Begin Weather Method
    
    WeatherMethod *weather = [[WeatherMethod alloc] init];
    
	NSDictionary *result = [weather getWeather];
    
    outputText = [outputText stringByAppendingString:[result objectForKey:@"outputWeatherText"]];
    
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[result objectForKey:@"weatherImage"]]];
	NSData *data = [[NSData alloc] initWithContentsOfURL:url];
	NSImage *tempImage = [[NSImage alloc] initWithData:data];
	[weatherImage setImage:tempImage];
    
    
    //Begin Email Method
    
    EmailMethod *email = [[EmailMethod alloc] init];
    
    outputText = [outputText stringByAppendingString:[email getEmail]];
    
    
    //Begin Calendar Method
    
    CalendarMethod *calendar = [[CalendarMethod alloc] init];
    
   	outputText = [outputText stringByAppendingString:[calendar getiCalEvents]];
    outputText = [outputText stringByAppendingString:[calendar getReminders]];
    
    //Begin News and Quote Method
    
    NewsAndQuoteMethod *newsAndQuote = [[NewsAndQuoteMethod alloc] init];
    
    // NYTimes
    outputText = [outputText stringByAppendingString:[newsAndQuote getNYTimes]];
    
    // Daily Quote
    outputText = [outputText stringByAppendingString:[newsAndQuote getDailyQuote]];
    
    
    p = NSMakePoint( 10, 175 );
    
    attribs = [[NSMutableDictionary alloc] init];
    
    c = [NSColor colorWithDeviceWhite:0.95 alpha:1];
    fnt = [NSFont fontWithName:@"Helvetica" size:14];
    
    [attribs setObject:c forKey:NSForegroundColorAttributeName];
    [attribs setObject:fnt forKey:NSFontAttributeName];
    
    [outputText drawAtPoint:p withAttributes:attribs];
}


@end
