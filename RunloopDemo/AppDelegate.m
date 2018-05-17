//
//  AppDelegate.m
//  runloopDemo
//
//  Created by ChenMan on 2018/5/16.
//  Copyright © 2018年 com. All rights reserved.
//

#import "AppDelegate.h"
#import "CMRunLoopSource.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (id)init
{
    self = [super init];
    if (self) {
        self.sources = [NSMutableArray array];
    }
    return self;
}

+(AppDelegate *)sharedAppDelegate
{
    static AppDelegate *thePTAppDelegate = nil;
    @synchronized(self){
        if (thePTAppDelegate == nil)
        {
            thePTAppDelegate = [[AppDelegate alloc] init];
        }
        return thePTAppDelegate;
    }
}

/**
 *
 *  协调输入源的客户端（将输入源注册到客户端）
 *
 */
- (void)registerSource:(RunLoopContext*)sourceContext
{
    [self.sources addObject:sourceContext];
//    [self fireSource];
}

- (void)fireSource
{
    if (self.sources.count > 0){//如果有任务(事件),给缓冲区发送命令
        RunLoopContext *context = [self.sources objectAtIndex:0];
        CMRunLoopSource *source = context.source;
        CFRunLoopRef runLoop = context.runLoop;
        

        //给缓冲区发送命令
        if(runLoop){
            [source fireCommandsOnRunLoop:runLoop];
        }
    }
}

- (void)removeSource:(RunLoopContext*)sourceContext
{
    id objToRemove = nil;
    
    for (RunLoopContext* context in self.sources)
    {
        if ([context isEqual:sourceContext])
        {
            objToRemove = context;
            break;
        }
    }
    
    if (objToRemove)
        [self.sources removeObject:objToRemove];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    //创建窗口
//    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    _window.backgroundColor = [UIColor whiteColor];
//    [_window makeKeyAndVisible];
//    ViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ViewController"];
//    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
//    self.window.rootViewController = navi;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
