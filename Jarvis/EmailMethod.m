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
//    NSDictionary *nsAppInfo;
//    NSBundle *nsAppBundle;
//    NSString *nsAppPath;
//    
//    //NSURL *appName = [[NSWorkspace sharedWorkspace] URLForApplicationToOpenURL:[NSURL URLWithString:@"mailto:"]];
//    
//    NSWorkspace *nsSharedWorkspace = [NSWorkspace sharedWorkspace];
//    nsAppPath = [nsSharedWorkspace fullPathForApplication:@"Mail.app"];
//    nsAppBundle = [NSBundle bundleWithPath: nsAppPath];
//    nsAppInfo = [nsAppBundle infoDictionary];
//    NSLog(@"version%@", [nsAppInfo objectForKey:@"CFBundleShortVersionString"]);
//    NSLog(@"build%@", [nsAppInfo objectForKey:@"CFBundleVersion"]);
    
    
    NSUserDefaults *mailPrefs = [[NSUserDefaults alloc] init];
    NSArray *smtpList = [[mailPrefs persistentDomainForName:@"com.apple.mail"] objectForKey:@"MailSections"];
    NSLog(@"APPLE Pref: %@", smtpList);
    
    NSArray *mailPrefsAppleScript = (__bridge NSArray *)CFPreferencesCopyValue((CFStringRef)@"MailSections", (CFStringRef)@"com.apple.mail", kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    
    NSLog(@"APPLE PrefsAppleScript: %@", mailPrefsAppleScript);
    
    if(smtpList != NULL){
            
        //Unread email count
        NSString *outputEmailText = [[NSString alloc] init];    
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
            for(int i=0; i<[vipNames count]; i++)
            {
                mailCount = 0;
                for(int j=0; j<[[vipAddresses objectAtIndex:i] count]; j++)
                {
                    if([senderList rangeOfString:[[vipAddresses objectAtIndex:i] objectAtIndex:j]].location != NSNotFound)
                    {mailCount = mailCount + [[senderList componentsSeparatedByString: [[vipAddresses objectAtIndex:i] objectAtIndex:j]] count] - 1;}
                }
                if (mailCount==1) outputEmailText = [outputEmailText stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"%d of them is from %@.\n", @""), mailCount, [vipNames objectAtIndex:i]]];
                else if (mailCount>1) outputEmailText = [outputEmailText stringByAppendingString:[NSString stringWithFormat:NSLocalizedString(@"%d of them are from %@.\n", @""), mailCount, [vipNames objectAtIndex:i]]];
            }
            return outputEmailText;
        }
    }
}
@end