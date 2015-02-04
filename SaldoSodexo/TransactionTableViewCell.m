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

- (void)setTransaction:(Transaction *)transaction {
    _transaction = transaction;
    
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([[self.transaction.type uppercaseString] isEqualToString:@"DÉBITO"]) {
        [self.priceLabel setTextColor:[UIColor colorWithRed:1.0f green:0.5f blue:0.5f alpha:1.0f]];
    } else {
        [self.priceLabel setTextColor:[UIColor colorWithRed:0.0f green:0.7f blue:0.2f alpha:1.0f]];
    }

    self.descriptionLabel.text = [self.transaction.history capitalizedStringWithLocale:nil];
    self.dateLabel.text        = self.transaction.date;
    self.priceLabel.text       = self.transaction.value;
}

@end
