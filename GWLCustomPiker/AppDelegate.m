//
//  AppDelegate.m
//  GWLCustomPiker
//
//  Created by 高万里 on 15/6/12.
//  Copyright (c) 2015年 高万里. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoViewController.h"
#import "Demo1ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor blackColor];
    Demo1ViewController *vc = [[Demo1ViewController alloc]init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
