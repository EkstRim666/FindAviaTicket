//
//  CoreDataHelper.h
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 29/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

typedef enum Favorite {
    favoriteTicket,
    favoriteMapPrice
} Favorite;

typedef enum FavoriteClassOfElement {
    FavoriteClassOfElementTicket,
    FavoriteClassOfElementMapPrice,
    FavoriteClassOfElementFavoriteTicket,
    FavoriteClassOfElementFavoriteMapPrice
} FavoriteClassOfElement;

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataHelper : NSObject

+(instancetype)sharedInstance;
-(BOOL)isFavorite:(id)element withFavorite:(Favorite)favorite;
-(NSArray *)favorites:(Favorite)favorite;
-(void)addToFavorite:(id)element withFavorite:(Favorite)favorite;
-(void)removeFromFavorite:(id)element withFavoriteClassofElement:(FavoriteClassOfElement)favoriteClass andFavorite:(Favorite)favorite;

@end

NS_ASSUME_NONNULL_END
