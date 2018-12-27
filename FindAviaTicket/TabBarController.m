//
//  TabBarController.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 27/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "TabBarController.h"
#import "MapViewController.h"
#import "MainViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

-(instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewControllers = [self createViewControllers];
        self.tabBar.tintColor =UIColor.blackColor;
    }
    return self;
}

-(NSArray<UIViewController *>*)createViewControllers {
    NSMutableArray<UIViewController *> *controllers = [NSMutableArray<UIViewController *> new];
    
    MainViewController *mainViewController = [MainViewController new];
    mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Search" image:nil selectedImage:nil];
    [controllers addObject:[[UINavigationController alloc] initWithRootViewController:mainViewController]];
    
    MapViewController *mapViewController = [MapViewController new];
    mapViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Map price" image:nil selectedImage:nil];
    [controllers addObject:[[UINavigationController alloc] initWithRootViewController:mapViewController]];
    
    return controllers;
}

@end
