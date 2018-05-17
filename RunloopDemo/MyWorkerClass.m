//
//  MyWorkerClass.m
//  runloopDemo
//
//  Created by ChenMan on 2018/5/16.
//  Copyright © 2018年 com. All rights reserved.
//

#import "MyWorkerClass.h"
#import <Foundation/NSPort.h>

@interface MyWorkerClass() <NSMachPortDelegate> {
    NSPort *remotePort;
    NSPort *myPort;
    NSMutableArray *arr;
}
@end

#define kMsg1 100
#define kMsg2 101

@implementation MyWorkerClass

- (void)launchThreadWithPort:(NSPort *)port {
    @autoreleasepool {
        
        //1. 保存主线程传入的port
        remotePort = port;
        
        //2. 设置子线程名字
        [[NSThread currentThread] setName:@"MyWorkerClassThread"];
        
        //3. 开启runloop
        [[NSRunLoop currentRunLoop] run];
        
        //4. 创建自己port
        myPort = [NSPort port];
        
        //5.
        myPort.delegate = self;
        
        //6. 将自己的port添加到runloop
        //作用1、防止runloop执行完毕之后推出
        //作用2、接收主线程发送过来的port消息
        [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
        
        //7. 完成向主线程port发送消息
        [self sendPortMessage];
    }
}

/**
 *   完成向主线程发送port消息
 */
- (void)sendPortMessage {
    
    NSString *str1 = @"aaa111";
    NSString *str2 = @"bbb222";
    arr = [[NSMutableArray alloc] initWithArray:@[[str1 dataUsingEncoding:NSUTF8StringEncoding],[str2 dataUsingEncoding:NSUTF8StringEncoding]]];
    //发送消息到主线程，操作1
    [remotePort sendBeforeDate:[NSDate date]
                         msgid:kMsg1
                    components:arr
                          from:myPort
                      reserved:0];
    
    //发送消息到主线程，操作2
    //    [remotePort sendBeforeDate:[NSDate date]
    //                         msgid:kMsg2
    //                    components:nil
    //                          from:myPort
    //                      reserved:0];
}

#pragma mark - NSPortDelegate

- (void)handlePortMessage:(NSPortMessage *)message
{
    NSLog(@"接收到父线程的消息...\n");
    
    //    unsigned int msgid = [message msgid];
    //    NSPort* distantPort = nil;
    //
    //    if (msgid == kCheckinMessage)
    //    {
    //        distantPort = [message sendPort];
    //
    //    }
    //    else if(msgid == kExitMessage)
    //    {
    //        CFRunLoopStop((__bridge CFRunLoopRef)[NSRunLoop currentRunLoop]);
    //    }
}

@end
