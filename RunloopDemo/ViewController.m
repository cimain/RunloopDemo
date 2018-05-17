//
//  ViewController.m
//  runloopDemo
//
//  Created by mac on 16/4/7.
//  Copyright © 2016年 com. All rights reserved.
//
#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "CMRunLoopSource.h"
#import <Foundation/NSPort.h>
#import "MyWorkerClass.h"
#import "AppDelegate.h"

@interface ViewController ()<MKMapViewDelegate,NSPortDelegate,NSMachPortDelegate>
{
    BOOL _end;
}

@property (weak, nonatomic) IBOutlet UIScrollView *testScrollview;
@property (nonatomic, readwrite, retain) CMRunLoopSource *source;
@property (nonatomic, weak) NSThread *aThread;
@end

@implementation ViewController

static int a;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.testScrollview.hidden = NO;
    [[NSThread currentThread] setName:@"VC--Thread"];
    
    
    [self test7];
//    [self launchThreadForPort];
}

- (IBAction)buttonTaped:(id)sender {
    AppDelegate *delegate = [AppDelegate sharedAppDelegate];
    [delegate fireSource];
}

static NSString *CustomRunLoopMode = @"CustomRunLoopMode";
/**
 *
 *  自定义RunLoopModel
 *
 */
-(void)test8{
    [NSThread detachNewThreadSelector:@selector(test88) toTarget:self withObject:nil];
}

-(void)test88{
    NSTimer *timer = [NSTimer timerWithTimeInterval:1
                                             target:self
                                           selector:@selector(printMessage:)
                                           userInfo:nil
                                            repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    CFRunLoopAddCommonMode(CFRunLoopGetCurrent(), (__bridge CFStringRef)(CustomRunLoopMode));
    
    do {
        [[NSRunLoop currentRunLoop] runMode:CustomRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    } while (_end);
    NSLog(@"finishing thread.........");
}

/**
 *
 *  自定义source源
 *
 */
-(void)test7{
    
    NSThread* aThread = [[NSThread alloc] initWithTarget:self selector:@selector(testForCustomSource) object:nil];
    self.aThread = aThread;
    [aThread setName:@"test7--Thread"];
    [aThread start];
}

-(void)testForCustomSource{
    NSLog(@"starting thread.......");
    
    NSRunLoop *myRunLoop = [NSRunLoop currentRunLoop];
    
   // 设置Run Loop observer的运行环境
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    // 创建Run loop observer对象
    // 第一个参数用于分配该observer对象的内存
    // 第二个参数用以设置该observer所要关注的的事件，详见回调函数myRunLoopObserver中注释
    // 第三个参数用于标识该observer是在第一次进入run loop时执行还是每次进入run loop处理时均执行
    // 第四个参数用于设置该observer的优先级
    // 第五个参数用于设置该observer的回调函数
    // 第六个参数用于设置该observer的运行环境
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
    if (observer){
        CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
    
    _source = [[CMRunLoopSource alloc] init];
    [_source addToCurrentRunLoop];
    
    while (!self.aThread.isCancelled)
    {
        NSLog(@"We can do other work");
        [myRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:5.0f]];
    }
    
    
    [_source invalidateSource];
    NSLog(@"finishing thread.........");
}

/**
 *
 *  自定义timer
 *
 */
-(void)testCustomTimer{
    // 获得当前thread的Run loop
    NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
    // 设置Run Loop observer的运行环境
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    // 创建Run loop observer对象
    // 第一个参数用于分配该observer对象的内存
    // 第二个参数用以设置该observer所要关注的的事件，详见回调函数myRunLoopObserver中注释
    // 第三个参数用于标识该observer是在第一次进入run loop时执行还是每次进入run loop处理时均执行
    // 第四个参数用于设置该observer的优先级
    // 第五个参数用于设置该observer的回调函数
    // 第六个参数用于设置该observer的运行环境
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
    if (observer){
        CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopTimerContext timerContext = {0, NULL, NULL, NULL, NULL};
    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 0.1, 0.3, 0, 0,
                                                   &myCFTimerCallback, &timerContext);
    
    CFRunLoopAddTimer(runLoop, timer, kCFRunLoopCommonModes);
    NSInteger loopCount = 2;
    do{
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        loopCount--;
    }while (loopCount);

}
void myCFTimerCallback(){
    NSLog(@"-----++++-------");
}

/**
 *
 *  使用系统的timer(添加observe)
 *
 */
- (void)test6{
    // 获得当前thread的Run loop
    NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
    // 设置Run Loop observer的运行环境
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    // 创建Run loop observer对象
    // 第一个参数用于分配该observer对象的内存
    // 第二个参数用以设置该observer所要关注的的事件，详见回调函数myRunLoopObserver中注释
    // 第三个参数用于标识该observer是在第一次进入run loop时执行还是每次进入run loop处理时均执行
    // 第四个参数用于设置该observer的优先级
    // 第五个参数用于设置该observer的回调函数
    // 第六个参数用于设置该observer的运行环境
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
    if (observer){
        CFRunLoopRef cfLoop = [myRunLoop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
    [NSTimer scheduledTimerWithTimeInterval:5.1 target:self selector:@selector(printMessage:) userInfo:nil repeats:YES];
    NSInteger loopCount = 1;
    
    do{
        NSLog(@"%d",(int)loopCount);
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        loopCount--;
    }while (loopCount);
}


/**
 *
 *  配置基于port的源
 *
 */
-(void)test9{
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(printMessage:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSRunLoopCommonModes];
    while (_end)
    {
        SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 2, YES);
    }
    NSLog(@"finishing thread.........");
}

/**
 *
 *  在辅助线程使用timer
 *
 */
-(void)test4{
    NSLog(@"The new thread will start...");
    [NSThread detachNewThreadSelector:@selector(newThreadAction) toTarget:self withObject:nil];
}
-(void)newThreadAction{
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
    if (observer){
        CFRunLoopRef cfLoop = [runloop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
    //在当前线程中注册事件源
    [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector:@selector(printMessage:) userInfo: nil
                                    repeats:YES];
    
    NSInteger loopCount = 2;
    do{
        [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
        loopCount--;
        
    }while (loopCount);
}

/**
 *
 *  可以检查RunLoop的退出
 *
 */
- (void)test3
{
    BOOL done = NO;
    do{
        SInt32 result = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, YES);
        if ((result == kCFRunLoopRunStopped) || (result == kCFRunLoopRunFinished))
            done = YES;
    }
    while (!done);
}



/**
 *
 *  可以看到每一个线程都有属于自己的runloop
 *
 */
-(void)test2{
    NSLog(@"CFRunLoopGetMain---------%@",CFRunLoopGetMain());
    NSLog(@"----currentRunLoop-------%@",[NSRunLoop currentRunLoop]);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"---async---currentRunLoopdispatch_get_main_queue---currentRunLoop----%@",[NSRunLoop currentRunLoop]);

    });
    dispatch_async(dispatch_queue_create("test1", NULL), ^{
        NSLog(@"--async---dispatch_queue_create(test1, NULL)----currentRunLoop----%@",[NSRunLoop currentRunLoop]);
    });
    dispatch_sync(dispatch_queue_create("test2", NULL), ^{
        NSLog(@"--sync----dispatch_queue_create(test2, NULL)---currentRunLoop-----%@",[NSRunLoop currentRunLoop]);
    });
}

/**
 *
 *  在滚动scrollview的时候,输出台停止打印,停止滚动后继续打印
 *
 */
-(void)test1{
    self.testScrollview.hidden = NO;
    self.testScrollview.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height * 4);
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(printMessage:)
                                                    userInfo:nil
                                                     repeats:YES];
    //把timer添加到commendModes里面
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];

}

-(void)printMessage:(NSTimer *)timer{
    a++;
    NSLog(@"%d",a);
}

- (void)launchThreadForPort
{
    NSPort* myPort = [NSMachPort port];
    if (myPort)
    {
        //这个类持有即将到来的端口消息
        [myPort setDelegate:self];
        //将端口作为输入源安装到当前的 runLoop
        [[NSThread currentThread] setName:@"launchThreadForPort---Thread"];
        [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
        //当前线程去调起工作线程
        MyWorkerClass *work = [[MyWorkerClass alloc] init];
        [NSThread detachNewThreadSelector:@selector(launchThreadWithPort:) toTarget:work withObject:myPort];
    }
}

//NSPortDelegate
#define kCheckinMessage 100
//处理从工作线程返回的响应
- (void) handlePortMessage: (id)portMessage {
    //消息的 id
    unsigned int messageId = (int)[[portMessage valueForKeyPath:@"msgid"] unsignedIntegerValue];
    
    if (messageId == kCheckinMessage) {
        
        //1. 当前主线程的port
        NSPort *localPort = [portMessage valueForKeyPath:@"localPort"];
        //2. 接收到消息的port（来自其他线程）
        NSPort *remotePort = [portMessage valueForKeyPath:@"remotePort"];
        //3. 获取工作线程关联的端口，并设置给远程端口，结果同2
        NSPort *distantPort = [portMessage valueForKeyPath:@"sendPort"];
        
        NSMutableArray *arr = [[portMessage valueForKeyPath:@"components"] mutableCopy];
        if ([arr objectAtIndex:0]) {
            NSData *data = [arr objectAtIndex:0];
            NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"");
        }
        NSLog(@"");
        //为了以后的使用保存工作端口
//        [self storeDistantPort: distantPort];
    } else {
        //处理其他的消息
    }
}

void myRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    switch(activity)
    {
            // 即将进入Loop
        case kCFRunLoopEntry:
            NSLog(@"run loop entry");
            break;
        case kCFRunLoopBeforeTimers://即将处理 Timer
            NSLog(@"run loop before timers");
            break;
        case kCFRunLoopBeforeSources://即将处理 Source
            NSLog(@"run loop before sources");
            break;
        case kCFRunLoopBeforeWaiting://即将进入休眠
            NSLog(@"run loop before waiting");
            break;
        case kCFRunLoopAfterWaiting://刚从休眠中唤醒
            NSLog(@"run loop after waiting");
            break;
        case kCFRunLoopExit://即将退出Loop
            NSLog(@"run loop exit");
            break;
        default:
            break;
    }
}



@end
