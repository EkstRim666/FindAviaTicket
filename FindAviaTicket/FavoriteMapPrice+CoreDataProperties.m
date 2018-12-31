//
//  FavoriteMapPrice+CoreDataProperties.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 31/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//
//

#import "FavoriteMapPrice+CoreDataProperties.h"

@implementation FavoriteMapPrice (CoreDataProperties)

+ (NSFetchRequest<FavoriteMapPrice *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPrice"];
}

@dynamic actual;
@dynamic departure;
@dynamic destination;
@dynamic distance;
@dynamic numberOfChanges;
@dynamic origin;
@dynamic returnDate;
@dynamic value;
@dynamic created;

@end
