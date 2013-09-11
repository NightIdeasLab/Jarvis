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
    NSString *outputNewsText = [[NSString alloc] init];
    NSString * quoteContent1 = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://feeds.nytimes.com/nyt/rss/HomePage"] encoding: NSUTF8StringEncoding error:nil];
	if(quoteContent1!=nil)
	{
		outputNewsText = [outputNewsText stringByAppendingString:NSLocalizedString(@"\nToday's Headlines from NYTimes:\n", @"")];
		outputNewsText = [outputNewsText stringByAppendingString:[[[[quoteContent1 componentsSeparatedByString:@"<title>"] objectAtIndex:3] componentsSeparatedByString:@"</title>"] objectAtIndex:0]];
        //text = [text stringByAppendingString:[[[[quoteContent componentsSeparatedByString:@"<link>"] objectAtIndex:3] componentsSeparatedByString:@"</link>"] objectAtIndex:0]];
		outputNewsText = [outputNewsText stringByAppendingString:@".\n"];
		outputNewsText = [outputNewsText stringByAppendingString:[[[[quoteContent1 componentsSeparatedByString:@"<title>"] objectAtIndex:4] componentsSeparatedByString:@"</title>"] objectAtIndex:0]];
		outputNewsText = [outputNewsText stringByAppendingString:@".\n"];
	}
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    return outputNewsText;
    
}

- (NSString *) retriveDailyQuote {
    
    //Daily quotation
    NSString *outputQuoteText = [[NSString alloc] init];
	NSString * quoteContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://feeds.feedburner.com/brainyquote/QUOTEBR"] encoding: NSUTF8StringEncoding error:nil];
	if(quoteContent!=nil)
    {
		outputQuoteText = [outputQuoteText stringByAppendingString:NSLocalizedString(@"\nToday's quotation from BrainyQuote.com:\n", @"")];
		outputQuoteText = [outputQuoteText stringByAppendingString:[[[[quoteContent componentsSeparatedByString:@"<description>"] objectAtIndex:3] componentsSeparatedByString:@"</description>"] objectAtIndex:0]];
		outputQuoteText = [outputQuoteText stringByAppendingString:@"\n"];
		outputQuoteText = [outputQuoteText stringByAppendingString:[[[[quoteContent componentsSeparatedByString:@"<title>"] objectAtIndex:3] componentsSeparatedByString:@"</title>"] objectAtIndex:0]];
		outputQuoteText = [outputQuoteText stringByAppendingString:@".\n"];
	}
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    return outputQuoteText;
    
}

@end
