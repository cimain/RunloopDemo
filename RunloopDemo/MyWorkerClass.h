//
//  MyWorkerClass.h
//  runloopDemo
//
//  Created by ChenMan on 2018/5/16.
//  Copyright © 2018年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyWorkerClass : NSObject

- (void)launchThreadWithPort:(NSPort *)port;

@end
