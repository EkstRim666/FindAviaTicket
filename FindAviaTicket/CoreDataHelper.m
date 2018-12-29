//
//  CoreDataHelper.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 29/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "CoreDataHelper.h"
#import "FavoriteTicket+CoreDataClass.h"

@interface CoreDataHelper ()

@property (strong, nonatomic) NSPersistentContainer *persistentContainer;

@end


@implementation CoreDataHelper

+(instancetype)sharedInstsnce {
    static CoreDataHelper *instance;
    static dispatch_once_t coreDataHelperOnceToken;
    dispatch_once(&coreDataHelperOnceToken, ^{
        instance = [CoreDataHelper new];
        [instance setupe];
    });
    return instance;
}

-(void)setupe {
    self.persistentContainer = [[NSPersistentContainer alloc] initWithName:@"AirTicketsBase"];
    [self.persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *description, NSError *error) {
        if (error != nil) {
            NSLog(@"Failed to load Core Data stack: %@", error);
            abort();
        }
    }];
}

-(void)save {
    NSError *error;
    if ([self.persistentContainer.viewContext hasChanges] && ![self.persistentContainer.viewContext save:&error]) {
        NSLog(@"Faild to save Core Data context");
        abort();
    }
}

-(FavoriteTicket *)favoriteFromTickets:(Ticket *)ticket {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
    return [[self.persistentContainer.viewContext executeFetchRequest:request error:nil] firstObject];
}

-(BOOL)isFavorite:(Ticket *)ticket {
    return [self favoriteFromTickets:ticket] != nil;
}

-(void)addToFavorite:(Ticket *)ticket {
    FavoriteTicket *favoriteTicket = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteTicket" inManagedObjectContext:self.persistentContainer.viewContext];
    favoriteTicket.price = ticket.price.integerValue;
    favoriteTicket.airline = ticket.airline;
    favoriteTicket.departure = ticket.departure;
    favoriteTicket.expires = ticket.expires;
    favoriteTicket.flightNumber = ticket.flightNumber.integerValue;
    favoriteTicket.returnDate = ticket.returnDate;
    favoriteTicket.from = ticket.from;
    favoriteTicket.to = ticket.to;
    favoriteTicket.created = [NSDate date];
    [self save];
}

-(void)removeFromFavorite:(Ticket *)ticket {
    FavoriteTicket *favoriteTicket = [self favoriteFromTickets:ticket];
    if (favoriteTicket) {
        [self.persistentContainer.viewContext deleteObject:favoriteTicket];
        [self save];
    }
}

-(NSArray *)favorites {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    return [self.persistentContainer.viewContext executeFetchRequest:request error:nil];
}

@end
