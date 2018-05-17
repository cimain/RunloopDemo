//
//  CMRunLoopSource.h
//  runloopDemo
//
//  Created by ChenMan on 2018/5/16.
//  Copyright © 2018年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMRunLoopSource : NSObject

{
    CFRunLoopSourceRef _runLoopSource;
    NSMutableArray *_commands;
}

- (id)init;
- (void)addToCurrentRunLoop;

- (void)sourceFired;

- (void)addCommand:(NSInteger)command withData:(id)data;
- (void)fireCommandsOnRunLoop:(CFRunLoopRef)runloop;
- (void)invalidateSource;
@end


@interface RunLoopContext : NSObject
{
    CFRunLoopRef        _runLoop;
    CMRunLoopSource*        _source;
}
@property (readonly) CFRunLoopRef runLoop;
@property (readonly) CMRunLoopSource* source;

- (id)initWithSource:(CMRunLoopSource*)src andLoop:(CFRunLoopRef)loop;

@end

void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode);
void RunLoopSourcePerformRoutine (void *info);
void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode);

