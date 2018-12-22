//
//  TicketTableViewCell.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 22/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface TicketTableViewCell : UITableViewCell

@property (strong, nonatomic) Ticket *ticket;

@end

NS_ASSUME_NONNULL_END
