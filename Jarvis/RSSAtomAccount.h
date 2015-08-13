#import "NSString+English.h"
#import "NSURLRequest+Authorization.h"
#import "SMWebRequest/SMWebRequest.h"
#import "Hpple/TFHpple.h"
#import "Feed.h"

@interface RSSAtomAccount : NSObject

@property (nonatomic, copy) NSArray *feeds;
@property (nonatomic, strong) SMWebRequest *request, *tokenRequest;

- (void)validateLink:(NSString *)fixedDomain;

@end
