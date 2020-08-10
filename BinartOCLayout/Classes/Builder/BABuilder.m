#import <objc/runtime.h>

#import "BABuilder.h"

@implementation BABuilder

- (instancetype)init {
    if (self = [super init]) {
        [self setDefault];
    }
    
    return self;
}

- (void)setDefault {
    self.build = ^UIView *{
        return nil;
    };
}

@end
