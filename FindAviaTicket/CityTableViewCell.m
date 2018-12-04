//
//  CityTableViewCell.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 03/12/2018.
//  Copyright © 2018 Andrey Yusupov. All rights reserved.
//

#import "CityTableViewCell.h"

@implementation CityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.cityName = [[UILabel alloc] initWithFrame:CGRectZero];
        self.cityName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.cityName];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat height = 20;
    CGRect frame = CGRectMake(16, (self.frame.size.height / 2 - height / 2), (self.frame.size.width - 2 * 16), height);
    self.cityName.frame = frame;
}

@end
