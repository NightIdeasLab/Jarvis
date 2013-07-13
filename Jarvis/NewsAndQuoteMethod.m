//
//  NewsAndQuoteMethod.m
//  Jarvis
//
//  Created by Gabriel Ulici on 7/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "NewsAndQuoteMethod.h"

@implementation NewsAndQuoteMethod

- (NSString *) retriveNYTimes {
    
    //NYTimes latest
    NSString *text = [[NSString alloc] init];
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
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [text autorelease];
    return text;
    
}

- (NSString *) retriveDailyQuote {
    
    //Daily quotation
    NSString *text = [[NSString alloc] init];
	NSString * quoteContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://feeds.feedburner.com/brainyquote/QUOTEBR"] encoding: NSUTF8StringEncoding error:nil];
	if(quoteContent!=nil)
    {
		text = [text stringByAppendingString:NSLocalizedString(@"\nToday's quotation from BrainyQuote.com:\n", @"")];
		text = [text stringByAppendingString:[[[[quoteContent componentsSeparatedByString:@"<description>"] objectAtIndex:3] componentsSeparatedByString:@"</description>"] objectAtIndex:0]];
		text = [text stringByAppendingString:@"\n"];
		text = [text stringByAppendingString:[[[[quoteContent componentsSeparatedByString:@"<title>"] objectAtIndex:3] componentsSeparatedByString:@"</title>"] objectAtIndex:0]];
		text = [text stringByAppendingString:@".\n"];
	}
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [text autorelease];
    return text;
    
}

@end
