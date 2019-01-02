//
//  FirstViewController.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 02/01/2019.
//  Copyright © 2019 Andrey Yusupov. All rights reserved.
//

#import "FirstViewController.h"
#import "ContentFirstViewController.h"

#define CONTETN_COUNT 4

@interface FirstViewController ()

@property (strong, nonatomic) UIButton *next;
@property (strong, nonatomic) UIButton *before;
@property (strong, nonatomic) UIButton *close;
@property (strong, nonatomic) UIPageControl *pageControll;

@end

@implementation FirstViewController {
    struct firstContentData {
        __unsafe_unretained NSString *title;
        __unsafe_unretained NSString *content;
        __unsafe_unretained NSString *imageName;
    } contentData[CONTETN_COUNT];
}

-(void)createContentDataArray {
    NSArray *titles = @[@"ABOUT APPLICATION", @"AVIATICKET", @"MAP PRICE", @"FAVORITE"];
    NSArray *contents = @[@"The application is to search for aviatickets", @"You can to find the cheapest aviaticket", @"You can to view to map price", @"You can to save a selected aviaticket in favorite"];
    for (int i = 0; i < 4; ++i) {
        contentData[i].title = [titles objectAtIndex:i];
        contentData[i].content = [contents objectAtIndex:i];
        contentData[i].imageName = [NSString stringWithFormat:@"first_%d",i+1];
    }
}

-(ContentFirstViewController *)viewControllerAtIndex:(int)index {
    if (index < 0 || index >= CONTETN_COUNT) return nil;
    ContentFirstViewController *contentFirstViewController = [ContentFirstViewController new];
    contentFirstViewController.title = contentData[index].title;
    contentFirstViewController.contentText = contentData[index].content;
    contentFirstViewController.index = index;
    contentFirstViewController.image = [UIImage imageNamed:contentData[index].imageName];
    return contentFirstViewController;
}

-(void)updateButtonWithIndex:(int)index {
    switch (index) {
        case 0:
            self.before.frame = CGRectZero;
            [self.next setTitle:@"NEXT" forState:UIControlStateNormal];
            break;
        case 1:
        case 2:
            self.before.frame = CGRectMake(0, (UIScreen.mainScreen.bounds.size.height - 50), 100, 50);
            [self.before setTitle:@"BEFORE" forState:UIControlStateNormal];
            [self.next setTitle:@"NEXT" forState:UIControlStateNormal];
            self.next.tag = 0;
            break;
        case 3:
            self.before.frame = CGRectMake(0, (UIScreen.mainScreen.bounds.size.height - 50), 100, 50);
            [self.before setTitle:@"BEFORE" forState:UIControlStateNormal];
            [self.next setTitle:@"CLOSE" forState:UIControlStateNormal];
            self.next.tag = 1;
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createContentDataArray];
    
    self.dataSource = self;
    self.delegate = self;
    
    [self prepareUI];
}

#pragma mark - PrepareUI
-(void) prepareUI {
    self.view.backgroundColor = UIColor.whiteColor;
    [self setViewControllers:@[[self viewControllerAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, (self.view.bounds.size.height - 50), self.view.bounds.size.width, 50)];
    self.pageControll.numberOfPages = CONTETN_COUNT;
    self.pageControll.currentPage = 0;
    self.pageControll.pageIndicatorTintColor = UIColor.darkGrayColor;
    self.pageControll.currentPageIndicatorTintColor = UIColor.blackColor;
    [self.view addSubview:self.pageControll];
    
    self.next = [UIButton buttonWithType:UIButtonTypeSystem];
    self.next.frame = CGRectMake((self.view.bounds.size.width - 100), (self.view.bounds.size.height - 50), 100, 50);
    [self.next addTarget:self action:@selector(nextButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.next setTintColor:UIColor.blackColor];
    [self.view addSubview:self.next];
    
    self.before = [UIButton buttonWithType:UIButtonTypeSystem];
    self.before.frame = CGRectMake(0, (self.view.bounds.size.height - 50), 100, 50);
    [self.before addTarget:self action:@selector(beforeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.before setTintColor:UIColor.blackColor];
    [self.view addSubview:self.before];
    
    self.close = [UIButton buttonWithType:UIButtonTypeSystem];
    self.close.frame = CGRectMake((self.view.bounds.size.width - 100), 10, 100, 50);
    [self.close addTarget:self action:@selector(closeButtonDidTap) forControlEvents:UIControlEventTouchUpInside];
    [self.close setTintColor:UIColor.blackColor];
    [self.close setTitle:@"CLOSE" forState:UIControlStateNormal];
    [self.view addSubview:self.close];
    
    [self updateButtonWithIndex:0];
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        int index = ((ContentFirstViewController *)[pageViewController.viewControllers firstObject]).index;
        self.pageControll.currentPage = index;
        [self updateButtonWithIndex:index];
    }
}

#pragma mark - UIPageViewControllerDataSource
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    int index = ((ContentFirstViewController *)viewController).index;
    index--;
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    int index = ((ContentFirstViewController *)viewController).index;
    index++;
    return [self viewControllerAtIndex:index];
}

#pragma mark - IBAction
-(void)nextButtonDidTap:(UIButton *)sender {
    int index = ((ContentFirstViewController *)[self.viewControllers firstObject]).index;
    if (sender.tag) {
        [self closeButtonDidTap];
    } else {
        __weak typeof (self) weakSelf = self;
        [self setViewControllers:@[[self viewControllerAtIndex:(index + 1)]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            weakSelf.pageControll.currentPage = index + 1;
            [weakSelf updateButtonWithIndex:(index + 1)];
        }];
    }
}

-(void)beforeButtonDidTap:(UIButton *)sender {
    int index = ((ContentFirstViewController *)[self.viewControllers firstObject]).index;
    __weak typeof (self) weakSelf = self;
    [self setViewControllers:@[[self viewControllerAtIndex:(index - 1)]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        weakSelf.pageControll.currentPage = index - 1;
        [weakSelf updateButtonWithIndex:(index - 1)];
    }];
}

-(void)closeButtonDidTap {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_start"];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
