//
//  ContentViewController.m
//  FindAviaTicket
//
//  Created by Andrey Yusupov on 02/01/2019.
//  Copyright © 2019 Andrey Yusupov. All rights reserved.
//

#import "ContentFirstViewController.h"

@interface ContentFirstViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLable;
@property (strong, nonatomic) UILabel *content;

@end

@implementation ContentFirstViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        [self prepareUI];
    }
    return self;
}

float heightForText(NSString *text, UIFont *font, float width) {
    if (text && [text isKindOfClass:[NSString class]]) {
        CGRect needLabel = [text boundingRectWithSize:CGSizeMake(width, FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:font} context:nil];
        return ceilf(needLabel.size.height);
    }
    return 0;
}

#pragma mark - PrepareUI
-(void)prepareUI {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width / 2 - 100), (UIScreen.mainScreen.bounds.size.height / 2 - 100), 200, 200)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.cornerRadius = 8;
    self.imageView.clipsToBounds = YES;
    [self.view addSubview:self.imageView];
    
    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width / 2 - 100), (CGRectGetMinY(self.imageView.frame) - 61), 200, 21)];
    self.titleLable.font = [UIFont systemFontOfSize:20 weight:UIFontWeightHeavy];
    self.titleLable.numberOfLines = 0;
    self.titleLable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLable];
    
    self.content = [[UILabel alloc] initWithFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width / 2 - 100), (CGRectGetMaxY(self.imageView.frame) + 20), 200, 21)];
    self.content.font = [UIFont systemFontOfSize:17 weight:UIFontWeightHeavy];
    self.content.numberOfLines = 0;
    self.content.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.content];
}

#pragma mark - Setter
-(void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = image;
}

-(void)setTitle:(NSString *)title {
    _titleLable.text = title;
    float height = heightForText(title, self.titleLable.font, 200);
    self.titleLable.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width / 2 - 100), (CGRectGetMinY(self.imageView.frame) - 40 - height), 200, height);
}

-(void)setContentText:(NSString *)contentText {
    _contentText = contentText;
    self.content.text = contentText;
    float height = heightForText(contentText, self.content.font, 200);
    self.content.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width / 2 - 100), (CGRectGetMaxY(self.imageView.frame) + 20), 200, height);
}

@end
