//
//  TicketTableViewCell.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 22/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "FavoriteTicket+CoreDataClass.h"
#import "FavoriteMapPrice+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketTableViewCell : UITableViewCell

@property (strong, nonatomic) Ticket *ticket;
@property (strong, nonatomic) FavoriteTicket *favoriteTicket;
@property (strong, nonatomic) FavoriteMapPrice *favoriteMapPrice;

@end

NS_ASSUME_NONNULL_END
