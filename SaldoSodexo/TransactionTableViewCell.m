//
//  ExtratoTableViewCell.m
//  SaldoSodexo
//
//  Created by Bruno Guidolim on 10/3/14.
//  Copyright (c) 2014 Bruno Guidolim. All rights reserved.
//

#import "TransactionTableViewCell.h"
#import "Constants.h"

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
    
    NSString *priceFormat = CURRENCY_FORMAT;
    NSString *price       = @"";
    
    if ([[self.dict objectForKey:@"type"] isEqualToString:@"DÉBITO"]) {
        
//        priceFormat = [NSString stringWithFormat:@"-%@", CURRENCY_FORMAT];
        [self.priceLabel setTextColor:[UIColor colorWithRed:1.0f green:0.5f blue:0.5f alpha:1.0f]];
    }
    else {
//        priceFormat = [NSString stringWithFormat:@"+%@", CURRENCY_FORMAT];
        [self.priceLabel setTextColor:[UIColor colorWithRed:0.0f green:0.7f blue:0.2f alpha:1.0f]];
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    price = [self.dict objectForKey:@"value"];
    price = [price stringByReplacingOccurrencesOfString:@"." withString:[formatter decimalSeparator]];
    
    self.descriptionLabel.text = [[self.dict objectForKey:@"description"] capitalizedStringWithLocale:nil];
    self.dateLabel.text        = [self.dict objectForKey:@"date"];
    self.priceLabel.text       = [NSString stringWithFormat:priceFormat, price];
    
}

@end
