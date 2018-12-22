//
//  TicketsTableViewController.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 22/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TicketsTableViewController : UITableViewController

-(instancetype)initWithTickets:(NSArray *)tickets;

@end

NS_ASSUME_NONNULL_END
