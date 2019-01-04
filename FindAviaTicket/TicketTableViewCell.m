//
//  TicketTableViewCell.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 22/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "TicketTableViewCell.h"
#import <YYWebImage/YYWebImage.h>

@interface TicketTableViewCell()

@property (strong, nonatomic) UILabel *price;
@property (strong, nonatomic) UILabel *places;
@property (strong, nonatomic) UILabel *date;
//@property (strong, nonatomic) UIImageView *airlineLogo;

@end

@implementation TicketTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.layer.shadowOffset = CGSizeMake(1, 1);
        self.contentView.layer.shadowRadius = 10;
        self.contentView.layer.shadowOpacity = 1;
        self.contentView.layer.cornerRadius = 6;
        self.contentView.backgroundColor = UIColor.whiteColor;
        
        _price = [[UILabel alloc] initWithFrame:self.bounds];
        _price.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
        [self.contentView addSubview:self.price];
        
        _places = [[UILabel alloc] initWithFrame:self.bounds];
        _places.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
        _places.textColor = UIColor.darkGrayColor;
        [self.contentView addSubview:self.places];
        
        _date = [[UILabel alloc] initWithFrame:self.bounds];
        _date.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        [self.contentView addSubview:self.date];
        
        _airlineLogo = [[UIImageView alloc] initWithFrame:self.bounds];
        _airlineLogo.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.airlineLogo];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = CGRectMake(10, 10, (UIScreen.mainScreen.bounds.size.width - 20), (self.frame.size.height - 20));
    
    _price.frame = CGRectMake(10, 10, (self.contentView.frame.size.width - 110), 40);
    
    _places.frame = CGRectMake(10, (CGRectGetMaxY(self.price.frame) + 16), 100, 20);
    
    _date.frame = CGRectMake(10, (CGRectGetMaxY(self.places.frame) + 8), (self.contentView.frame.size.width - 20), 20);
    
    _airlineLogo.frame = CGRectMake((CGRectGetMaxX(self.price.frame) + 10), 10, 80, 80);
}

-(void)setTicket:(Ticket *)ticket {
    _ticket = ticket;
    
    _price.text = [NSString stringWithFormat:@"%@ rub", ticket.price];
    
    _places.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _date.text = [dateFormatter stringFromDate:ticket.departure];
    
    NSURL *urlLogo = [NSURL URLWithString:[NSString stringWithFormat:@"https://pics.avs.io/200/200/%@.png", ticket.airline]];
    [_airlineLogo yy_setImageWithURL:urlLogo options:YYWebImageOptionSetImageWithFadeAnimation];
}

-(void)setFavoriteTicket:(FavoriteTicket *)favoriteTicket {
    _favoriteTicket = favoriteTicket;
    
    _price.text = [NSString stringWithFormat:@"%lld rub", favoriteTicket.price];
    
    _places.text = [NSString stringWithFormat:@"%@ - %@", favoriteTicket.from, favoriteTicket.to];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _date.text = [dateFormatter stringFromDate:favoriteTicket.departure];
    
    NSURL *urlLogo = [NSURL URLWithString:[NSString stringWithFormat:@"https://pics.avs.io/200/200/%@.png", favoriteTicket.airline]];
    [_airlineLogo yy_setImageWithURL:urlLogo options:YYWebImageOptionSetImageWithFadeAnimation];
}

- (void)setFavoriteMapPrice:(FavoriteMapPrice *)favoriteMapPrice {
    _favoriteMapPrice = favoriteMapPrice;
    
    _price.text = [NSString stringWithFormat:@"%lld rub", favoriteMapPrice.value];
    
    _places.text = [NSString stringWithFormat:@"%@ - %@", favoriteMapPrice.origin, favoriteMapPrice.destination];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _date.text = [dateFormatter stringFromDate:favoriteMapPrice.departure];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.price.text = nil;
    self.places.text = nil;
    self.date.text = nil;
    self.airlineLogo.image = nil;
}

@end
