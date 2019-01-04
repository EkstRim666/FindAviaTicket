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
#import "NotificationCenter.h"

#define coreDataHelper [CoreDataHelper sharedInstance]
#define notificationCenter [NotificationCenter sharedInstance]

#define reuseIdentifierCell @"ticketTableViewCell"

@interface TicketsTableViewController ()

@property (strong, nonatomic) UISegmentedControl *navigationSegmentedControl;
@property (strong, nonatomic) NSArray *tickets;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UITextField *dateTextField;

@end

@implementation TicketsTableViewController {
    BOOL isFavorites;
    TicketTableViewCell *notificationCell;
}

-(instancetype)initFavoriteTicketsTableViewController {
    self = [super init];
    if (self) {
        isFavorites = YES;
        _tickets = [NSArray new];
        self.title = NSLocalizedString(@"titleFavorite", nil);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:reuseIdentifierCell];
        self.navigationSegmentedControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"From Search", nil), NSLocalizedString(@"From Map Price", nil)]];
        self.navigationSegmentedControl.tintColor = UIColor.blackColor;
        self.navigationSegmentedControl.selectedSegmentIndex = 0;
        [self.navigationSegmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = self.navigationSegmentedControl;
        [self changeSource];
        [self prepareUI];
    }
    return self;
}

-(instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (self) {
        _tickets = tickets;
        self.title = NSLocalizedString(@"titleTicket", nil);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:reuseIdentifierCell];
        [self prepareUI];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (isFavorites) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        [self changeSource];
        [self.tableView reloadData];
    }
}

#pragma mark - IBAction
-(void)changeSource {
    switch (self.navigationSegmentedControl.selectedSegmentIndex) {
        case 0:
            self.tickets = [coreDataHelper favorites:favoriteTicket];
            break;
        case 1:
        default:
            self.tickets = [coreDataHelper favorites:favoriteMapPrice];
            break;
    }
    [self.tableView reloadData];
}

-(void)doneButtonDidTap:(UIBarButtonItem *)sender {
    if (self.datePicker.date && notificationCell) {
        NSString *message;
        NSURL *imageUrl;
        if (isFavorites) {
            if (self.navigationSegmentedControl.selectedSegmentIndex == 0) {
                message = [NSString stringWithFormat:@"%@ %@ - %@ %@ %lld %@.", NSLocalizedString(@"Flight", nil), notificationCell.favoriteTicket.from, notificationCell.favoriteTicket.to, NSLocalizedString(@"for", nil), notificationCell.favoriteTicket.price, NSLocalizedString(@"currency", nil)];
                if (notificationCell.airlineLogo.image) {
                    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@.png", notificationCell.favoriteTicket.airline]];
                    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                        UIImage *logo = notificationCell.airlineLogo.image;
                        NSData *pngData = UIImagePNGRepresentation(logo);
                        [pngData writeToFile:path atomically:YES];
                    }
                    imageUrl = [NSURL fileURLWithPath:path];
                }
            } else if (self.navigationSegmentedControl.selectedSegmentIndex == 1) {
                message = [NSString stringWithFormat:@"%@ %@ - %@ %@ %lld %@.", NSLocalizedString(@"Flight", nil), notificationCell.favoriteMapPrice.origin, notificationCell.favoriteMapPrice.destination, NSLocalizedString(@"for", nil), notificationCell.favoriteMapPrice.value, NSLocalizedString(@"currency", nil)];
                imageUrl = nil;
            }
        } else {
            message = [NSString stringWithFormat:@"%@ %@ - %@ %@ %@ %@.", NSLocalizedString(@"Flight", nil), notificationCell.ticket.from, notificationCell.ticket.to, NSLocalizedString(@"for", nil), notificationCell.ticket.price, NSLocalizedString(@"currency", nil)];
            if (notificationCell.airlineLogo.image) {
                NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@.png", notificationCell.ticket.airline]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                    UIImage *logo = notificationCell.airlineLogo.image;
                    NSData *pngData = UIImagePNGRepresentation(logo);
                    [pngData writeToFile:path atomically:YES];
                }
                imageUrl = [NSURL fileURLWithPath:path];
            }
        }
        
        Notification notification = NotificationMake(NSLocalizedString(@"Remember about ticket", nil), message, self.datePicker.date, imageUrl);
        [notificationCenter sendNotification:notification];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Success", nil) message:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Remember will be sent at", nil), self.datePicker.date] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Close", nil) style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    self.datePicker.date = [NSDate date];
    notificationCell = nil;
    [self.view endEditing:YES];
}

#pragma mark - PrepareUI
-(void)prepareUI {
    self.datePicker = [UIDatePicker new];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.datePicker.minimumDate = [NSDate date];
    
    UIToolbar *keyboardToolbar = [UIToolbar new];
    [keyboardToolbar sizeToFit];
    keyboardToolbar.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:@selector(doneButtonDidTap:)]];
    
    self.dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
    self.dateTextField.hidden = YES;
    self.dateTextField.inputView = self.datePicker;
    self.dateTextField.inputAccessoryView = keyboardToolbar;
    [self.view addSubview:self.dateTextField];
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
        switch (self.navigationSegmentedControl.selectedSegmentIndex) {
            case 0:
                cell.favoriteTicket = [self.tickets objectAtIndex:indexPath.row];
                break;
            case 1:
            default:
                cell.favoriteMapPrice = [self.tickets objectAtIndex:indexPath.row];
                break;
        }
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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Ticket Actions", nil) message:NSLocalizedString(@"What do you want to do with ticket?", nil) preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Remember", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self->notificationCell = [tableView cellForRowAtIndexPath:indexPath];
        [self.dateTextField becomeFirstResponder];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close", nil) style:UIAlertActionStyleCancel handler:nil];
    if (isFavorites) {
        if (self.navigationSegmentedControl.selectedSegmentIndex == 0) {
            favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete from favorites", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [coreDataHelper removeFromFavorite:[self.tickets objectAtIndex:indexPath.row] withFavoriteClassofElement:FavoriteClassOfElementFavoriteTicket andFavorite:favoriteTicket];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }];
        } else if (self.navigationSegmentedControl.selectedSegmentIndex == 1) {
            favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete from favorites", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [coreDataHelper removeFromFavorite:[self.tickets objectAtIndex:indexPath.row] withFavoriteClassofElement:FavoriteClassOfElementFavoriteMapPrice andFavorite:favoriteMapPrice];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }];
        }
    } else {
        if ([coreDataHelper isFavorite:[self.tickets objectAtIndex:indexPath.row] withFavorite:favoriteTicket]) {
            favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete from favorites", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [coreDataHelper removeFromFavorite:[self.tickets objectAtIndex:indexPath.row] withFavoriteClassofElement:FavoriteClassOfElementTicket andFavorite:favoriteTicket];
            }];
        } else {
            favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add to favorites", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [coreDataHelper addToFavorite:[self.tickets objectAtIndex:indexPath.row] withFavorite:favoriteTicket];
            }];
        }
    }
    [alertController addAction:favoriteAction];
    [alertController addAction:notificationAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
