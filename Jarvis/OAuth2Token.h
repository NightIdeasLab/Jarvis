#import "NSData+ObjectFromJSONData.h"
#import "NSDictionary+JSONString.h"
#import "NSString+ObjectFromJSONString.h"

@interface OAuth2Token : NSObject

@property (nonatomic, copy) NSString *access_token, *refresh_token;

- (id)initWithTokenResponse:(NSData *)responseData error:(NSString **)error;

- (NSString *)stringRepresentation;
+ (OAuth2Token *)tokenWithStringRepresentation:(NSString *)string;

@end
