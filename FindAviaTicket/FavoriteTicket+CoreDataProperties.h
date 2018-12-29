//
//  FavoriteTicket+CoreDataProperties.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 29/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//
//

#import "FavoriteTicket+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FavoriteTicket (CoreDataProperties)

+ (NSFetchRequest<FavoriteTicket *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *airline;
@property (nullable, nonatomic, copy) NSString *from;
@property (nullable, nonatomic, copy) NSString *to;
@property (nullable, nonatomic, copy) NSDate *created;
@property (nullable, nonatomic, copy) NSDate *expires;
@property (nullable, nonatomic, copy) NSDate *departure;
@property (nullable, nonatomic, copy) NSDate *returnDate;
@property (nonatomic) int16_t flightNumber;
@property (nonatomic) int64_t price;



@end

NS_ASSUME_NONNULL_END
