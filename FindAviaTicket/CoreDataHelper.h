//
//  CoreDataHelper.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 29/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject

+(instancetype)sharedInstance;
-(BOOL)isFavorite:(Ticket *)ticket;
-(NSArray *)favorites;
-(void)addToFavorite:(Ticket *)ticket;
-(void)removeFromFavorite:(Ticket *)ticket;

@end

NS_ASSUME_NONNULL_END
