// Copied from https://github.com/nfarina/feeds with modifications

#import "SMXMLDocument.h"
#import "ISO8601DateFormatter.h"
#import "NSString+English.h"
#import "NSString+Base64.h"
#import "NSDate+InternetDateTime.h"
#import "SMWebRequest.h"
#import "NSURLRequest+Authorization.h"
#import "RegexKitLite.h"
#import "NSString+EntityDecoding.h"
#import "NSString+Truncated.h"

extern NSString *kFeedUpdatedNotification;

NSDate *AutoFormatDate(NSString *dateString);

@interface Feed : NSObject

// stored properties
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, copy) NSString *title, *author;
@property (nonatomic, copy) NSDictionary *requestHeaders;
@property (nonatomic, assign) BOOL disabled, requiresBasicAuth, requiresOAuth2Token, incremental;

// used only at runtime
@property (nonatomic, copy) NSArray *items;

+ (Feed *)feedWithURLString:(NSString *)URLString title:(NSString *)title;
+ (Feed *)feedWithURLString:(NSString *)URLString title:(NSString *)title author:(NSString *)author;

+ (Feed *)feedWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

+ (NSArray *)feedItemsWithData:(NSData *)data discoveredTitle:(NSString **)title error:(NSError **)error;

@end

@interface FeedItem : NSObject

@property (nonatomic, copy) NSString *identifier, *title, *author, *authorIdentifier, *project, *content, *rawDate;
@property (nonatomic, strong) NSURL *link, *comments;
@property (nonatomic, strong) NSDate *published, *updated;
@property (nonatomic, assign) BOOL notified, viewed, authoredByMe;
@property (nonatomic, unsafe_unretained) Feed *feed;

@property (nonatomic, readonly) NSString *authorAndTitle;

// creates a new FeedItem by parsing an XML element
+ (FeedItem *)itemWithRSSItemElement:(SMXMLElement *)element;
+ (FeedItem *)itemWithATOMEntryElement:(SMXMLElement *)element;

- (NSComparisonResult)compareItemByPublishedDate:(FeedItem *)item;

- (NSAttributedString *)attributedStringHighlighted:(BOOL)highlighted;

@end
