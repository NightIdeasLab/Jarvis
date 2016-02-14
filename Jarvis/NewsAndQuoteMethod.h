//
//  NewsAndQuoteMethod.h
//  Jarvis
//
//  Created by Gabriel Ulici on 7/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMWebRequest/SMWebRequest.h"
#import "Feed.h"

@interface NewsAndQuoteMethod : NSObject

@property (nonatomic, strong) SMWebRequest *request, *tokenRequest;

- (NSString *) retrieveRSSItems;
- (NSString *) retrieveDailyQuote;

@end