// Copied from https://github.com/nfarina/feeds with modifications

@interface NSString (Truncated)

- (NSString *)truncatedAfterIndex:(NSUInteger)index;
- (NSString *)truncatedWithString:(NSString *)truncationString afterIndex:(NSUInteger)index;

@end
