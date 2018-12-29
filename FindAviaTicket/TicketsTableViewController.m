//
//  TicketsTableViewController.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 22/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "TicketsTableViewController.h"
#import "TicketTableViewCell.h"
#import "CoreDataHelper.h"

#define coreDataHelper [CoreDataHelper sharedInstance]

#define reuseIdentifierCell @"ticketTableViewCell"

@interface TicketsTableViewController ()

@property (strong, nonatomic) NSArray *tickets;

@end

@implementation TicketsTableViewController {
    BOOL isFavorites;
}

-(instancetype)initFavoriteTicketsTableViewController {
    self = [super init];
    if (self) {
        isFavorites = YES;
        _tickets = [NSArray new];
        self.title = @"Favorites";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:reuseIdentifierCell];
    }
    return self;
}

-(instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self) {
        _tickets = tickets;
        self.title = @"Tickets";
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:reuseIdentifierCell];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isFavorites) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        _tickets = [coreDataHelper favorites];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tickets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifierCell forIndexPath:indexPath];
    if (isFavorites) {
        cell.favoriteTicket = [self.tickets objectAtIndex:indexPath.row];
    } else {
        cell.ticket = [self.tickets objectAtIndex:indexPath.row];
    }
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isFavorites) return;
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ticket Actions" message:@"What do you want to do with ticket?" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *favoriteAction;
        if ([coreDataHelper isFavorite:[self.tickets objectAtIndex:indexPath.row]]) {
            favoriteAction = [UIAlertAction actionWithTitle:@"Delete from favorites" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [coreDataHelper removeFromFavorite:[self.tickets objectAtIndex:indexPath.row]];
            }];
        } else {
            favoriteAction = [UIAlertAction actionWithTitle:@"Add to favorites" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [coreDataHelper addToFavorite:[self.tickets objectAtIndex:indexPath.row]];
            }];
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:favoriteAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
