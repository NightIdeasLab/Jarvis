//
//  PackageTrackerMethod.m
//  Jarvis
//
//  Created by Gabriel Ulici on 7/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "PackageTrackerMethod.h"

@implementation PackageTrackerMethod

- (NSString *) retrievePackages {
    
    /*
    // Junecloud username and password for package tracking Does Not Work
    NSString * packageUserName = @"email@domail.com";
    NSString * packagePassword = @"supersecretpassword";
    ////////////////////////////////
    
    //Package tracker
    NSString *text = [[NSString alloc] init];
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
    
    return 0;
}

@end
