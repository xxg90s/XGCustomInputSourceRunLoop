//
//  XGRunLoopSource.h
//  XGCustomInputSourceRunLoop
//
//  Created by xxg90s on 2022/4/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class XGRunLoopSource;

@protocol XGRunLoopSourceCallbackDelegate <NSObject>

- (void)source:(XGRunLoopSource *)source command:(NSInteger)command;

@end

// 接受其他线程的消息
@interface XGRunLoopSource : NSObject
{
    CFRunLoopSourceRef _runLoopSource;
    NSMutableArray *_commands;
}

@property (nonatomic, weak) id<XGRunLoopSourceCallbackDelegate> delegate;

/// 将source添加到当前runLoop
- (void)addToCurrentRunLoop;

/// 删除source
- (void)invalidate;

/// 接收到source事件
- (void)sourceFired;

/// 外部调用
- (void)addCommand:(NSInteger)command data:(nullable id)data;

/// 唤醒runLoop
- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runLoop;

@end

NS_ASSUME_NONNULL_END
