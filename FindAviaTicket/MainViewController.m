//
//  MainViewController.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 27/11/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "MainViewController.h"
#import "DataManager.h"

@interface MainViewController ()

@property (strong, nonatomic) UIButton *departureButton;
@property (strong, nonatomic) UIButton *arrivalButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self prepareUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataDidLoad:) name:dataManagerLoadDataDidComplete object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:dataManagerLoadDataDidComplete object:nil];
}

#pragma mark - Work with notifications
-(void)dataDidLoad:(NSNotification *)notification {
    [self.departureButton setEnabled:YES];
    [self.arrivalButton setEnabled:YES];
}

#pragma mark - PrepareUI
-(void)prepareUI {
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.title = @"Search";
    
    self.departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.departureButton setTitle:@"Departure" forState:UIControlStateNormal];
    self.departureButton.tintColor = UIColor.blackColor;
    self.departureButton.frame = CGRectMake(30, (CGRectGetMaxY(self.navigationController.navigationBar.frame) + 40), (UIScreen.mainScreen.bounds.size.width - 60), 60);
    self.departureButton.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.3];
    [self.departureButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.departureButton setEnabled:NO];
    [self.view addSubview:self.departureButton];
    
    self.arrivalButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.arrivalButton setTitle:@"Arrival" forState:UIControlStateNormal];
    self.arrivalButton.tintColor = UIColor.blackColor;
    self.arrivalButton.frame = CGRectMake(30, (CGRectGetMaxY(self.departureButton.frame) + 20), (UIScreen.mainScreen.bounds.size.width - 60), 60);
    self.arrivalButton.backgroundColor = [UIColor.lightGrayColor colorWithAlphaComponent:0.3];
    [self.arrivalButton addTarget:self action:@selector(placeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.arrivalButton setEnabled:NO];
    [self.view addSubview:self.arrivalButton];
}

#pragma mark - IBAction
-(void)placeButtonDidTap:(UIButton *)sender{
    
}

@end
