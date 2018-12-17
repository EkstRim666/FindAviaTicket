//
//  PlaceTableViewController.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 17/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum PlaceType {
    PlaceTypeDeparture,
    PlaceTypeArrival
} PlaceType;

NS_ASSUME_NONNULL_BEGIN

@interface PlaceTableViewController : UITableViewController

-(instancetype)initWithType:(PlaceType)type;

@end

NS_ASSUME_NONNULL_END
