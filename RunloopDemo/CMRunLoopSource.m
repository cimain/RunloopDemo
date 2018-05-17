//
//  CMRunLoopSource.m
//  runloopDemo
//
//  Created by ChenMan on 2018/5/16.
//  Copyright © 2018年 com. All rights reserved.
//

#import "CMRunLoopSource.h"
#import "AppDelegate.h"
#import <objc/runtime.h>

@interface CMRunLoopSource ()

@property (nonatomic, weak) NSTimer *timer;
@end

@implementation CMRunLoopSource

/**
 *
 *  安装输入源到Run Loop－－－分两步首先初始化一个输入源(init)，然后将这个输入源添加到当前Run Loop里面(addToCurrentRunLoop)
 *  
 */
- (id)init
{
    CFRunLoopSourceContext  context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL,
        &RunLoopSourceScheduleRoutine,
        RunLoopSourceCancelRoutine,
        RunLoopSourcePerformRoutine};
    
    _runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
    _commands = [[NSMutableArray alloc] init];
    
    return self;
}


- (void)addToCurrentRunLoop
{
    //获取当前线程的runLoop(辅助线程)
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(runLoop, _runLoopSource, kCFRunLoopDefaultMode);
}

- (void)sourceFired
{
    NSLog(@"Source fired: do some work, dude!");
    NSThread *thread = [NSThread currentThread];
    
//    [thread cancel];
    
    //既然线程没了，就把AppDelegate缓存的runloop也给删了，以免下次调用CFRunLoopWakeUp(runloop);会崩溃，因为只有runloop没了线程
//    [[AppDelegate sharedAppDelegate].sources removeObjectAtIndex:0];
}

- (void)addCommand:(NSInteger)command withData:(id)data
{
    
}

/**
 *  
 *  唤醒runloop
 *
 */
- (void)fireCommandsOnRunLoop:(CFRunLoopRef)runloop
{
    //标记为待处理
    if (_runLoopSource) {
        CFRunLoopSourceSignal(_runLoopSource);
        CFRunLoopWakeUp(runloop);
    }
}

-(void)timerAction:(NSTimer *)timer{
    NSLog(@"---+++++++++++---");
}

- (void)invalidateSource
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopRemoveSource(runLoop, _runLoopSource, kCFRunLoopDefaultMode);
}

@end

@implementation RunLoopContext

- (id)initWithSource:(CMRunLoopSource*)src andLoop:(CFRunLoopRef)loop
{
    self = [super init];
    if (self)
    {
        _runLoop = loop;
        _source = src;
    }
    return self;
}

@end



/**
 *  调度例程
 *  当将输入源安装到run loop后，调用这个协调调度例程，将源注册到客户端（可以理解为其他线程）
 *
 */
void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    CMRunLoopSource *obj = (__bridge CMRunLoopSource*)info;
    AppDelegate*   delegate = [AppDelegate sharedAppDelegate];
//    AppDelegate *delegate =  (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    RunLoopContext *theContext = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
    //发送注册请求
    [delegate performSelectorOnMainThread:@selector(registerSource:) withObject:theContext waitUntilDone:YES];
}

/**
 *  处理例程
 *  在输入源被告知（signal source）时，调用这个处理例程，这儿只是简单的调用了 [obj sourceFired]方法
 *
 */
void RunLoopSourcePerformRoutine (void *info)
{
    CMRunLoopSource*  obj = (__bridge CMRunLoopSource*)info;
    [obj sourceFired];
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:obj selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

/**
 *  取消例程
 *  如果使用CFRunLoopSourceInvalidate/CFRunLoopRemoveSource函数把输入源从run loop里面移除的话，系统会调用这个取消例程，并且把输入源从注册的客户端（可以理解为其他线程）里面移除
 *
 */
void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    CMRunLoopSource* obj = (__bridge CMRunLoopSource*)info;
    AppDelegate* delegate = [AppDelegate sharedAppDelegate];
    RunLoopContext* theContext = [[RunLoopContext alloc] initWithSource:obj andLoop:rl];
    
    [delegate performSelectorOnMainThread:@selector(removeSource:) withObject:theContext waitUntilDone:NO];
}




