//
//  Card.h
//  SaldoSodexo
//
//  Created by Bruno Guidolim on 8/7/14.
//  Copyright (c) 2014 Bruno Guidolim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *cardNumber;
@property (strong, nonatomic) NSString *cpfNumber;

+ (instancetype)cardWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionary;

@end
