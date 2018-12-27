//
//  AppDelegate.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 27/11/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = [TabBarController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
