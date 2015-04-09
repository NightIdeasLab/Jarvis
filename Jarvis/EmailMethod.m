//
//  EmailMethod.m
//  Jarvis
//
//  Created by Gabriel Ulici on 7/13/13.
//  Copyright (c) 2013 Night Ideas Lab Inc. All rights reserved.
//

#import "EmailMethod.h"

@implementation EmailMethod

- (NSString *) retrieveEmail {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // VIP names and email addresses
    NSString *nameVIP1 = [defaults objectForKey: @"nameVIP1"];
    NSString *nameVIP2 = [defaults objectForKey: @"nameVIP2"];
    NSString *nameVIP3 = [defaults objectForKey: @"nameVIP3"];
    NSString *nameVIP4 = [defaults objectForKey: @"nameVIP5"];
    
    NSString *emailVIP1 = [defaults objectForKey: @"emailVIP1"];
    NSString *emailVIP2 = [defaults objectForKey: @"emailVIP2"];
    NSString *emailVIP3 = [defaults objectForKey: @"emailVIP3"];
    NSString *emailVIP4 = [defaults objectForKey: @"emailVIP4"];
    
    //////////////////////////////
    // Personalization parameters:
	NSArray * vipNames = [NSArray arrayWithObjects: nameVIP1, nameVIP2, nameVIP3, nameVIP4, nil];
	NSArray * vipAddresses = [NSArray arrayWithObjects: \
							  [NSArray arrayWithObjects: emailVIP1, nil],\
							  [NSArray arrayWithObjects: emailVIP2, nil],\
							  [NSArray arrayWithObjects: emailVIP3, nil],\
							  [NSArray arrayWithObjects: emailVIP4, nil]\
							  , nil];
          
    NSString *outputEmailText = [[NSString alloc] init];

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
    if(returnDescriptor != NULL){
        outputEmailText = [outputEmailText stringByAppendingString:@"\n"];
        outputEmailText = [outputEmailText stringByAppendingString:[[[returnDescriptor stringValue] componentsSeparatedByString:@"###"] objectAtIndex:0]];
        
        //VIP email count
        unsigned long mailCount;
        NSString * senderList = [[returnDescriptor stringValue] lowercaseString];
        if ([vipNames count] > 0){
            for(int i=0; i<[vipNames count]; i++) {
                mailCount = 0;
                for(int j=0; j<[[vipAddresses objectAtIndex:i] count]; j++)
                {
                    if([senderList rangeOfString:[[vipAddresses objectAtIndex:i] objectAtIndex:j]].location != NSNotFound)
                    {mailCount = mailCount + [[senderList componentsSeparatedByString: [[vipAddresses objectAtIndex:i] objectAtIndex:j]] count] - 1;}
                }
                if (mailCount==1) outputEmailText = [outputEmailText stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"%d of them is from %@.\n", @""), mailCount, [vipNames objectAtIndex:i]]];
                else if (mailCount>1) outputEmailText = [outputEmailText stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"%d of them are from %@.\n", @""), mailCount, [vipNames objectAtIndex:i]]];
            }
        }
    }
//    } else {
//       outputEmailText = [outputEmailText stringByAppendingString:NSLocalizedString(@"\nPlease setup the mail!!!\n", @"")];
//    }
    return outputEmailText;
}


-(void)checkForActiveMailAccount {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSAppleScript* script= [[NSAppleScript alloc] initWithSource:@"tell application \"Mail\" \nname of every account \nend tell"];
    NSDictionary* scriptError = nil;
    NSAppleEventDescriptor* descriptor=[script executeAndReturnError:&scriptError];
    if(scriptError)
    {
        [defaults setBool:NO forKey: @"UseMail"];
        [defaults synchronize];
    } else if (descriptor){
        [defaults setBool:YES forKey: @"UseMail"];
        [defaults synchronize];
    }
    [defaults setBool:YES forKey: @"CheckForActiveMailAccount"];
}

@end