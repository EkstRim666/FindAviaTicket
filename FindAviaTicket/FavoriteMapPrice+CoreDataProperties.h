//
//  FavoriteMapPrice+CoreDataProperties.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 31/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//
//

#import "FavoriteMapPrice+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FavoriteMapPrice (CoreDataProperties)

+ (NSFetchRequest<FavoriteMapPrice *> *)fetchRequest;

@property (nonatomic) BOOL actual;
@property (nullable, nonatomic, copy) NSDate *departure;
@property (nullable, nonatomic, copy) NSString *destination;
@property (nonatomic) int64_t distance;
@property (nonatomic) int16_t numberOfChanges;
@property (nullable, nonatomic, copy) NSString *origin;
@property (nullable, nonatomic, copy) NSDate *returnDate;
@property (nonatomic) int64_t value;
@property (nullable, nonatomic, copy) NSDate *created;

@end

NS_ASSUME_NONNULL_END
