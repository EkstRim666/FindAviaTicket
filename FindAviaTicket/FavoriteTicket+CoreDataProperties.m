//
//  FavoriteTicket+CoreDataProperties.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 29/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//
//

#import "FavoriteTicket+CoreDataProperties.h"

@implementation FavoriteTicket (CoreDataProperties)

+ (NSFetchRequest<FavoriteTicket *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
}

@dynamic airline;
@dynamic from;
@dynamic to;
@dynamic created;
@dynamic expires;
@dynamic departure;
@dynamic returnDate;
@dynamic flightNumber;
@dynamic price;



@end
