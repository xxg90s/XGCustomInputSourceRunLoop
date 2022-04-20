//
//  XGRunLoopContext.h
//  XGCustomInputSourceRunLoop
//
//  Created by xxg90s on 2022/4/19.
//

#import <Foundation/Foundation.h>
#import "XGRunLoopSource.h"

NS_ASSUME_NONNULL_BEGIN

// 容器类，输入源 与 RunLoop 关联的上下文对象，client通过该容器来和输入源通信
@interface XGRunLoopContext : NSObject

@property (nonatomic, assign) CFRunLoopRef runLoop;
@property (nonatomic, strong) XGRunLoopSource *source;

- (instancetype)initWithSource:(XGRunLoopSource *)inputSource runLoop:(CFRunLoopRef)runLoop;

@end

NS_ASSUME_NONNULL_END
