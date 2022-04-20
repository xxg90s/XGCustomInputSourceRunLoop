//
//  AppDelegate.m
//  XGCustomInputSourceRunLoop
//
//  Created by xxg90s on 2022/4/19.
//

#import "AppDelegate.h"
#import "XGRunLoopInpuSourceThread.h"

@interface AppDelegate ()

@property (nonatomic, strong) NSMutableArray<XGRunLoopContext *> *sources;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self startCustomInputSourceThread];
    
    return YES;
}

- (void)startCustomInputSourceThread {
    XGRunLoopInpuSourceThread *thread = [[XGRunLoopInpuSourceThread alloc] init];
    [thread start];
}

- (void)fireInputSource {
    [self simulateInputSourceEvent];
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end

@implementation AppDelegate (RunLoop)

- (void)registerSource:(XGRunLoopContext *)sourceContext {
    if (!self.sources) {
        self.sources = [[NSMutableArray alloc] init];
    }
    [self.sources addObject:sourceContext];
    
    // 通过观察自定义事件线程runloop来观察其状态变化
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        NSLog(@"当前线程RunLoop状态发生改变 = %ld", activity);
    });
    CFRunLoopRef runLoop = sourceContext.runLoop;
    CFRunLoopAddObserver(runLoop, observer, kCFRunLoopDefaultMode);
}

- (void)removeSource:(XGRunLoopContext *)sourceContext {
    [self.sources enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XGRunLoopContext *context = obj;
        if ([context isEqual:sourceContext]) {
            [self.sources removeObject:context];
            *stop = YES;
        }
    }];
}

- (void)simulateInputSourceEvent {
    //主线程通过引用context来获取source，并且向source传递事件后唤醒其runloop
    XGRunLoopContext *runLoopContext = [self.sources objectAtIndex:0];
    XGRunLoopSource *inputSource = runLoopContext.source;
    NSInteger command = random() % 10;
    [inputSource addCommand:command data:nil];
    [inputSource fireAllCommandsOnRunLoop:runLoopContext.runLoop];
}

@end
