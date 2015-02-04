//
//  Transaction.h
//  SaldoSodexo
//
//  Created by Bruno Guidolim on 2/4/15.
//  Copyright (c) 2015 Bruno Guidolim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject

@property (strong, nonatomic) NSString *history;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *value;
@property (strong, nonatomic) NSString *authorizationNumber;

+ (instancetype)transactionWithDictionary:(NSDictionary *)dictionary;

@end
