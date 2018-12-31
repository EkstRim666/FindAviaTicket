//
//  CoreDataHelper.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 29/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "CoreDataHelper.h"
#import "FavoriteTicket+CoreDataClass.h"
#import "FavoriteMapPrice+CoreDataClass.h"

@interface CoreDataHelper ()

@property (strong, nonatomic) NSPersistentContainer *persistentContainer;

@end


@implementation CoreDataHelper

+(instancetype)sharedInstance {
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

-(id)favoriteFromTickets:(id)element
            withFavorite:(Favorite)favorite
{
    NSFetchRequest *request;
    switch (favorite) {
            case favoriteTicket: {
                Ticket *ticket = element;
                request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
                request.predicate = [NSPredicate predicateWithFormat:@"price == %ld AND airline == %@ AND from == %@ AND to == %@ AND departure == %@ AND expires == %@ AND flightNumber == %ld", (long)ticket.price.integerValue, ticket.airline, ticket.from, ticket.to, ticket.departure, ticket.expires, (long)ticket.flightNumber.integerValue];
            }
            break;
            case favoriteMapPrice: {
                MapPrice *mapPrice = element;
                request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPrice"];
                request.predicate = [NSPredicate predicateWithFormat:@"value == %ld AND origin == %@ AND destination == %@ AND departure == %@ AND distance == %ld AND actual == %@ AND numberOfChanges == %d", mapPrice.value.integerValue, mapPrice.origin.name, mapPrice.destination.name, mapPrice.departure, mapPrice.distance.integerValue, mapPrice.actual, mapPrice.numberOfChanges.integerValue];
            }
            break;
    }
    
    return [[self.persistentContainer.viewContext executeFetchRequest:request error:nil] firstObject];
}

-(BOOL)isFavorite:(id)element
     withFavorite:(Favorite)favorite
{
    return [self favoriteFromTickets:element withFavorite:favorite] != nil;
}

-(void)addToFavorite:(id)element
        withFavorite:(Favorite)favorite
{
    switch (favorite) {
            case favoriteTicket: {
                Ticket *ticket = element;
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
            }
            break;
            case favoriteMapPrice: {
                MapPrice *mapPrice = element;
                FavoriteMapPrice *favoriteMapPrice = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteMapPrice" inManagedObjectContext:self.persistentContainer.viewContext];
                favoriteMapPrice.value = mapPrice.value.integerValue;
                favoriteMapPrice.distance = mapPrice.distance.integerValue;
                favoriteMapPrice.actual = mapPrice.actual;
                favoriteMapPrice.origin = mapPrice.origin.name;
                favoriteMapPrice.destination = mapPrice.destination.name;
                favoriteMapPrice.numberOfChanges = mapPrice.numberOfChanges.integerValue;
                favoriteMapPrice.departure = mapPrice.departure;
                favoriteMapPrice.returnDate = mapPrice.returnDate;
                favoriteMapPrice.created = [NSDate date];
            }
            break;
    }
    
    [self save];
}

-(void)removeFromFavorite:(id)element
             withFavorite:(Favorite)favorite
{
    switch (favorite) {
            case favoriteTicket: {
                FavoriteTicket *favoriteTicket = [self favoriteFromTickets:(Ticket *)element withFavorite:favorite];
                if (favoriteTicket) {
                    [self.persistentContainer.viewContext deleteObject:favoriteTicket];
                    [self save];
                }
            }
            break;
            case favoriteMapPrice: {
                FavoriteMapPrice *favoriteMapPrice = [self favoriteFromTickets:(MapPrice *)element withFavorite:favorite];
                if (favoriteMapPrice) {
                    [self.persistentContainer.viewContext deleteObject:favoriteMapPrice];
                    [self save];
                }
            }
            break;
    }
}

-(NSArray *)favorites:(Favorite)favorite {
    NSFetchRequest *request;
    switch (favorite) {
            case favoriteTicket:
            request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteTicket"];
            break;
            case favoriteMapPrice:
            request = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteMapPrice"];
            break;
    }
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO]];
    return [self.persistentContainer.viewContext executeFetchRequest:request error:nil];
}

@end
