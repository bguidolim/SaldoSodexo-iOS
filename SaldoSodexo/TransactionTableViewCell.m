//
//  ExtratoTableViewCell.m
//  SaldoSodexo
//
//  Created by Bruno Guidolim on 10/3/14.
//  Copyright (c) 2014 Bruno Guidolim. All rights reserved.
//

#import "TransactionTableViewCell.h"

@interface TransactionTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation TransactionTableViewCell

- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.descriptionLabel.text = [self.dict objectForKey:@"description"];
    self.dateLabel.text = [self.dict objectForKey:@"date"];
    self.priceLabel.text = [self.dict objectForKey:@"value"];
}

@end
