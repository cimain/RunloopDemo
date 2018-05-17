//
//  AppDelegate.h
//  runloopDemo
//
//  Created by ChenMan on 2018/5/16.
//  Copyright © 2018年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RunLoopContext;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, readwrite, strong) NSMutableArray *sources;

+(AppDelegate *)sharedAppDelegate;
- (void)fireSource;
- (void)registerSource:(RunLoopContext*)sourceContext;
- (void)removeSource:(RunLoopContext*)sourceContext;

@end

