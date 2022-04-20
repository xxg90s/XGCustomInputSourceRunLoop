//
//  XGRunLoopContext.m
//  XGCustomInputSourceRunLoop
//
//  Created by xxg90s on 2022/4/19.
//

#import "XGRunLoopContext.h"

@implementation XGRunLoopContext

- (instancetype)initWithSource:(XGRunLoopSource *)inputSource runLoop:(CFRunLoopRef)runLoop {
    if (self = [super init]) {
        _source = inputSource;
        _runLoop = runLoop;
    }
    return self;
}

@end
