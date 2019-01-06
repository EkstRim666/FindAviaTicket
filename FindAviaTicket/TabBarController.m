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
#import "TicketsTableViewController.h"

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
    mainViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"SearchTBC", nil) image:[UIImage imageNamed:@"search"] selectedImage:[UIImage imageNamed:@"search_selected"]];
    [controllers addObject:[[UINavigationController alloc] initWithRootViewController:mainViewController]];
    
    MapViewController *mapViewController = [MapViewController new];
    mapViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"MapPriceTBC", nil) image:[UIImage imageNamed:@"map"] selectedImage:[UIImage imageNamed:@"map_selected"]];
    [controllers addObject:[[UINavigationController alloc] initWithRootViewController:mapViewController]];
    
    TicketsTableViewController *favoriteTableViewController = [[TicketsTableViewController alloc] initFavoriteTicketsTableViewController];
    favoriteTableViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"FavoriteTBC", nil) image:[UIImage imageNamed:@"favorite"] selectedImage:[UIImage imageNamed:@"favorite_selected"]];
    [controllers addObject:[[UINavigationController alloc] initWithRootViewController:favoriteTableViewController]];
    
    return controllers;
}

@end
