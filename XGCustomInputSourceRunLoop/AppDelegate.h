//
//  AppDelegate.h
//  XGCustomInputSourceRunLoop
//
//  Created by xxg90s on 2022/4/19.
//

#import <UIKit/UIKit.h>
#import "XGRunLoopContext.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

- (void)fireInputSource;

@end

@interface AppDelegate (RunLoop)

- (void)registerSource:(XGRunLoopContext *)sourceContext;

- (void)removeSource:(XGRunLoopContext *)sourceContext;

- (void)simulateInputSourceEvent;

@end

