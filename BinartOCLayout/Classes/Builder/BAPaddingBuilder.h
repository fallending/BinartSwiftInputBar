
#import "BABuilder.h"

@interface BAPaddingBuilder : BABuilder

@property (nonatomic, strong) BAVoidBlock head;
@property (nonatomic, strong) BAVoidBlock tail;
@property (nonatomic, strong) BAVoidBlock up;
@property (nonatomic, strong) BAVoidBlock down;

@end

