//
//  MainViewController.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 27/11/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "MainViewController.h"
#import "DataManager.h"

#define dataManager [DataManager sharedInstance]

@interface MainViewController ()

@property (nonatomic, strong) UILabel *nameAction;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [dataManager loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete) name:kDataManagerLoadDataDidComplete object:nil];
    
    [self prepareUI];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete object:nil];
}

-(void)loadDataComplete {
    self.view.backgroundColor = [UIColor grayColor];
}

#pragma mark PrepareUI
-(void)prepareUI {
    CGRect frameButton = CGRectMake(([UIScreen mainScreen].bounds.size.width / 2 - 100), ([UIScreen mainScreen].bounds.size.height / 2 - 25), 200, 50);
    UIButton *nextController =[UIButton buttonWithType:UIButtonTypeSystem];
    [nextController setTitle:@"Next" forState:UIControlStateNormal];
    nextController.backgroundColor = [UIColor blueColor];
    nextController.tintColor = [UIColor whiteColor];
    nextController.frame = frameButton;
    [nextController addTarget:self action:@selector(nextControllerDidTapInside:) forControlEvents:UIControlEventTouchUpInside];
    [nextController addTarget:self action:@selector(nextControllerTap:) forControlEvents:UIControlEventTouchDown];
    [nextController addTarget:self action:@selector(nextControllerDidTapOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view addSubview:nextController];
    
    CGRect frameLabelNameAction = CGRectMake(10, ([UIScreen mainScreen].bounds.size.height / 4), ([UIScreen mainScreen].bounds.size.width - 20), 50);
    self.nameAction = [[UILabel alloc] initWithFrame:frameLabelNameAction];
    self.nameAction.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    self.nameAction.textColor = [UIColor whiteColor];
    self.nameAction.textAlignment = NSTextAlignmentCenter;
    self.nameAction.backgroundColor = [UIColor grayColor];
    self.nameAction.text = @"Nil";
    [self.view addSubview:self.nameAction];
    
    CGRect frameLabelAction = CGRectMake(10, ([UIScreen mainScreen].bounds.size.height / 4), ([UIScreen mainScreen].bounds.size.width - 20), -50);
    UILabel *action = [[UILabel alloc] initWithFrame:frameLabelAction];
    action.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    action.textColor = [UIColor whiteColor];
    action.textAlignment = NSTextAlignmentCenter;
    action.backgroundColor = [UIColor grayColor];
    action.text = @"Action";
    [self.view addSubview:action];
}

#pragma mark IBAction
-(void)nextControllerDidTapInside:(UIButton *)sender {
    UIViewController *anotherViewController = [UIViewController new];
    anotherViewController.view.backgroundColor = [UIColor greenColor];
    self.nameAction.text = @"Nil";
    [self.navigationController pushViewController:anotherViewController animated:YES];
}

-(void)nextControllerTap:(UIButton *)sender {
    self.nameAction.text = @"Open anotherViewController";
}

-(void)nextControllerDidTapOutside:(UIButton *)sender {
    self.nameAction.text = @"Nil";
}

@end
