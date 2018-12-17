//
//  PlaceTableViewController.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 17/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"

typedef enum PlaceType {
    PlaceTypeDeparture,
    PlaceTypeArrival
} PlaceType;

NS_ASSUME_NONNULL_BEGIN

@protocol PlaceTableViewControllerDelegate <NSObject>

-(void)selectedPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType;

@end

@interface PlaceTableViewController : UITableViewController

@property (weak, nonatomic) id<PlaceTableViewControllerDelegate> delegate;

-(instancetype)initWithType:(PlaceType)type;

@end

NS_ASSUME_NONNULL_END
