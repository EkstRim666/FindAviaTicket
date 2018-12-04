//
//  MainViewController.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 27/11/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "MainViewController.h"
#import "DataManager.h"
#import "DeparturePlaceViewController.h"
#import "ArrivalTableViewController.h"

#define dataManager [DataManager sharedInstance]

@interface MainViewController ()

@property (nonatomic, strong) UIButton *departurePlace;
@property (nonatomic, strong) UIButton *arrivalPlace;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [dataManager loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete) name:kDataManagerLoadDataDidComplete object:nil];
    
    [self prepareUI];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)loadDataComplete {
    [self.departurePlace setEnabled:YES];
    [self.arrivalPlace setEnabled:YES];
}

#pragma mark - PrepareUI
- (void)prepareUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.departurePlace = [UIButton buttonWithType:UIButtonTypeSystem];
    self.departurePlace.tintColor = [UIColor blackColor];
    self.departurePlace.backgroundColor = [UIColor lightGrayColor];
    self.departurePlace.frame = CGRectMake(30, 140, ([UIScreen mainScreen].bounds.size.width - 60), 60);
    [self.departurePlace setTitle:@"FROM" forState:UIControlStateNormal];
    [self.departurePlace addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.departurePlace];
    
    self.arrivalPlace = [UIButton buttonWithType:UIButtonTypeSystem];
    self.arrivalPlace.tintColor = [UIColor blackColor];
    self.arrivalPlace.backgroundColor = [UIColor lightGrayColor];
    self.arrivalPlace.frame = CGRectMake(30, (CGRectGetMaxY(self.departurePlace.frame) + 20), ([UIScreen mainScreen].bounds.size.width - 60), 60);
    [self.arrivalPlace setTitle:@"TO" forState:UIControlStateNormal];
    [self.arrivalPlace addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.arrivalPlace];
    
    [self.departurePlace setEnabled:NO];
    [self.arrivalPlace setEnabled:NO];
}

#pragma mark - IBAction
- (void)placeButtonDidTap:(UIButton *)sender {
    UIViewController *placeViewController;
    if ([sender isEqual:self.departurePlace]) {
        placeViewController = [DeparturePlaceViewController new];
    } else if ([sender isEqual:self.arrivalPlace]) {
        placeViewController = [ArrivalTableViewController new];
    }
    [self.navigationController pushViewController:placeViewController animated:YES];
}

@end
