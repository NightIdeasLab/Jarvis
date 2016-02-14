//
//  NewsAndQuoteMethod.m
//  Jarvis
//
//  Created by Gabriel Ulici on 8/17/15.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "NewsAndQuoteMethod.h"

@interface NewsAndQuoteMethod ()

@property (nonatomic, assign) NSString* feedItems;
@property (nonatomic, assign) BOOL aHasCompleted;

@end

@implementation NewsAndQuoteMethod

- (NSString *) retrieveRSSItems {
    // reading from the plist file
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *outputNewsText = [[NSString alloc] init];
    NSURL *userURL = [defaults URLForKey:@"RSSURL"];
    if(userURL != NULL) {
//        [self refreshWithURL:userURL];
//        [self performSelectorOnMainThread:@selector(refreshWithURL:)
//                                             withObject:userURL
//                                          waitUntilDone:TRUE];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshWithURL:userURL];
                NSLog(@"mata: %@", self.feedItems);
            //            if (!self.aHasCompleted)
//            {
//                NSLog(@"B running without A having run yet!, %@", self);

//            }
        });
    } else {
        NSString * quoteContent1 = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://feeds.nytimes.com/nyt/rss/HomePage"] encoding: NSUTF8StringEncoding error:nil];
        if(quoteContent1!=nil) {
            outputNewsText = [outputNewsText stringByAppendingString:NSLocalizedString(@"\nToday's headlines:\n", @"")];
            outputNewsText = [outputNewsText stringByAppendingString:[[[[quoteContent1 componentsSeparatedByString:@"<title>"] objectAtIndex:3] componentsSeparatedByString:@"</title>"] objectAtIndex:0]];
            outputNewsText = [outputNewsText stringByAppendingString:@".\n"];
            outputNewsText = [outputNewsText stringByAppendingString:[[[[quoteContent1 componentsSeparatedByString:@"<title>"] objectAtIndex:4] componentsSeparatedByString:@"</title>"] objectAtIndex:0]];
            outputNewsText = [outputNewsText stringByAppendingString:@".\n"];
        }

        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
    return outputNewsText;
}

- (NSString *) retrieveDailyQuote {
    // Daily quotation
    NSString *outputQuoteText = [[NSString alloc] init];
	NSString * quoteContent = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://feeds.feedburner.com/brainyquote/QUOTEBR"] encoding: NSUTF8StringEncoding error:nil];
    if(quoteContent!=nil) {
        outputQuoteText = [outputQuoteText stringByAppendingString:NSLocalizedString(@"\nToday's quotation:\n", @"")];
        outputQuoteText = [outputQuoteText stringByAppendingString:[[[[quoteContent componentsSeparatedByString:@"<description>"] objectAtIndex:3] componentsSeparatedByString:@"</description>"] objectAtIndex:0]];
        outputQuoteText = [outputQuoteText stringByAppendingString:@"\n"];
        outputQuoteText = [outputQuoteText stringByAppendingString:[[[[quoteContent componentsSeparatedByString:@"<title>"] objectAtIndex:3] componentsSeparatedByString:@"</title>"] objectAtIndex:0]];
        outputQuoteText = [outputQuoteText stringByAppendingString:@".\n"];
    }

    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    return outputQuoteText;
}

- (void)refreshWithURL:(NSURL *)refreshURL {
    NSMutableURLRequest *URLRequest;
    Feed *feed = [[Feed alloc] init];
    if (feed.requiresBasicAuth) // this feed requires the secure user/pass we stored in the keychain
        URLRequest = [NSMutableURLRequest requestWithURL:refreshURL];
    else if ([refreshURL user] && [refreshURL password]) // maybe the user/pass is built into the URL already? (this is the case for services like Basecamp that use "tokens" built into the URL)
        URLRequest = [NSMutableURLRequest requestWithURL:refreshURL username:[refreshURL user] password:[refreshURL password]];
    else // just a normal URL.
        URLRequest = [NSMutableURLRequest requestWithURL:refreshURL];

    // add any additional request headers
    for (NSString *field in feed.requestHeaders)
        [URLRequest setValue:(feed.requestHeaders)[field] forHTTPHeaderField:field];

    URLRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData; // goes without saying that we only care about fresh data for Feeds

    // build a useful context of extra data for custom feed processors like Trello and Beanstalk. Since those processors may need to fetch
    // additional data from their respective APIs, they may need the account usernamd and password, if applicable.
    NSMutableDictionary *context = [NSMutableDictionary dictionary];

    self.request = [SMWebRequest requestWithURLRequest:URLRequest delegate:(id<SMWebRequestDelegate>)[self class] context:context];
    [self.request addTarget:self action:@selector(refreshComplete:) forRequestEvents:SMWebRequestEventComplete];
    [self.request addTarget:self action:@selector(refreshError:) forRequestEvents:SMWebRequestEventError];
    [self.request start];
}

// This method is called on a background thread. Don't touch your instance members!
+ (id)webRequest:(SMWebRequest *)webRequest resultObjectForData:(NSData *)data context:(NSDictionary *)context {

    NSError *error = nil;
    NSArray *items = [self feedItemsWithData:data discoveredTitle:NULL error:&error];

    if (error) {
        NSLog(@"Error parsing XML feed result for %@ - %@", webRequest.request.URL, error);
        return nil;
    }

    return items;
}

+ (NSArray *)feedItemsWithData:(NSData *)data discoveredTitle:(NSString **)title error:(NSError **)error {
    // try parsing the XML first
    SMXMLDocument *document = [SMXMLDocument documentWithData:data error:error];
    if ((*error)) return nil;

    NSMutableArray *items = [NSMutableArray array];

    // are we speaking RSS or ATOM here?
    if ([document.root.name isEqual:@"rss"]) {
        if (title) *title = [document.root valueWithPath:@"channel.title"];

        NSArray *itemsXml = [[document.root childNamed:@"channel"] childrenNamed:@"item"];

        for (SMXMLElement *itemXml in itemsXml)
            [items addObject:[FeedItem itemWithRSSItemElement:itemXml]];
    }
    else if ([document.root.name isEqual:@"feed"]) {

        if (title) *title = [document.root valueWithPath:@"title"];

        NSArray *itemsXml = [document.root childrenNamed:@"entry"];

        for (SMXMLElement *itemXml in itemsXml)
            [items addObject:[FeedItem itemWithATOMEntryElement:itemXml]];
    }
    else {
        NSString *message = [NSString stringWithFormat:@"Unknown feed root element: <%@>", document.root.name];
        if (error) *error = [NSError errorWithDomain:@"Feed" code:0 userInfo:
                             @{NSLocalizedDescriptionKey: message}];
        return nil;
    }

    if (error) *error = nil;
    return items;
}

- (void)refreshComplete:(NSArray *)newItems {
    Feed *feed = [[Feed alloc] init];
    NSString *outputNewsText = [[NSString alloc] init];
    if (!newItems) {
        // TODO: problem refreshing the feed!
        return;
    }
    // if we have existing items, merge the new ones in
    if (feed.items) {
        NSMutableArray *merged = [NSMutableArray array];

        if (feed.incremental) {

            // populate the final set, newest item to oldest.
            for (FeedItem *newItem in newItems) {
                NSLog(@"NEW ITEM FOR FEED %@: %@", feed.URL, newItem);
                [merged addObject:newItem];
            }

            for (FeedItem *oldItem in feed.items) {
                int i = (int)[newItems indexOfObject:oldItem]; // have we updated this item?
                if (i < 0)
                    [merged addObject:oldItem];
            }

            // necessary for incremental feeds where we keep collecting items
            //while (merged.count > MAX_FEED_ITEMS) [merged removeLastObject];
        } else {
            /*
            for (FeedItem *newItem in newItems) {
                int i = (int)[feed.feed indexOfObject:newItem];
                if (i >= 0)
                    [merged addObject:(feed.items)[i]]; // preserve existing item
                else {
                    NSLog(@"NEW ITEM FOR FEED %@: %@", feed.URL, newItem);
                    [merged addObject:newItem];
                }
            }
             */
        }

        feed.items = merged;

        // mark as notified any item that was "created" by ourself, because we don't need to be reminded about stuff we did ourself.
        for (FeedItem *item in feed.items) {
            if ([(item.authorIdentifier ?: item.author) isEqual:feed.author]) // prefer authorIdentifier if present
                item.authoredByMe = YES;

            if (item.authoredByMe)
                item.notified = item.viewed = YES;
        }
    }
    else {
        //NSLog(@"ALL NEW ITEMS FOR FEED %@", feed.URL);
        feed.items = newItems;

        // don't notify about the initial fetch, or we'll have a shitload of growl popups
        for (FeedItem *item in feed.items)
            item.notified = item.viewed = YES;
    }

    [self validationDidComplete:feed];
//    for (FeedItem *item in feed.items) {
//        item.feed = feed;
//    }

//    for (int i = 1; i <= 5; i++)
//    {
//        FeedItem *item = [feed.items objectAtIndex:i];
//        NSLog(@"item: %@", item.title);
//    }

}

- (NSString *)validationDidComplete:(Feed *)feedsItems {
    self.feedItems = [self.feedItems stringByAppendingString:NSLocalizedString(@"\nToday's headlines:\n", @"")];

    for (int i = 1; i <= 1; i++) {
        FeedItem *item = [feedsItems.items objectAtIndex:i];
        self.feedItems = [self.feedItems stringByAppendingString:item.title];
        self.feedItems = [self.feedItems stringByAppendingString:@".\n"];
        NSLog(@"feeed: %@", item.title);
    }
    self.aHasCompleted = YES;
    return self.feedItems;
}

- (void)refreshError:(NSError *)error {
    NSLog(@"Error: %@", error);
}

@end