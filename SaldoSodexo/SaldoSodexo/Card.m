//
//  Card.m
//  SaldoSodexo
//
//  Created by Bruno Guidolim on 8/7/14.
//  Copyright (c) 2014 Bruno Guidolim. All rights reserved.
//

#import "Card.h"

@implementation Card

+ (instancetype)cardWithDictionary:(NSDictionary *)dictionary {
    Card *card = [Card new];
    for (NSString *key in [dictionary allKeys]) {
        [card setValue:dictionary[key] forKey:key];
    }
    
    return card;
}

- (NSDictionary *)dictionary {
    return @{@"name":self.name,
             @"cardNumber":self.cardNumber,
             @"cpfNumber":self.cpfNumber};
}

@end
