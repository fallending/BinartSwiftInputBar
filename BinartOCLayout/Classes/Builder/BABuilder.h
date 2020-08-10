
#import "BALayoutUtil.h"

// 从 css 映射过来

// box-sizing
// flex

@interface BABuilder : NSObject

// width: 600px
// width: 100%
// width: 100wv
@property (nonatomic, strong) BAVoidBlock w;
@property (nonatomic, strong) BAVoidBlock maxw; // max-width

// height: 600px
// height: 100%
// height: 100hv
@property (nonatomic, strong) BAVoidBlock h;
@property (nonatomic, strong) BAVoidBlock maxh;
@property (nonatomic, strong) BAVoidBlock size;

// margin: auto
// margin: 0 auto;
@property (nonatomic, strong) BAVoidBlock mar; // margin

// padding: 50px;
@property (nonatomic, strong) BAVoidBlock pad; // padding


@property (nonatomic, strong) BAVoidBlock fix; // fixed(x, y) 相对于屏幕


@property (nonatomic, strong) BAVoidBlock abs; // absolute(x, y) // 相对于父视图

@property (nonatomic, strong) BAVoidBlock fly; // float


//////

@property (nonatomic, strong) BAVoidBlock build;

//@property (nonatomic, strong) BAVoidBlock mar; // 外边距
//@property (nonatomic, strong) BAVoidBlock pad; // 内边距
@property (nonatomic, strong) BAVoidBlock rel; // 相对布局
//@property (nonatomic, strong) BAVoidBlock abs; // 绝对布局 top bottom right left
//@property (nonatomic, strong) BAVoidBlock flex; // flex布局

- (void)setDefault;

@end

