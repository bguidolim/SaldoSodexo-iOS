//
//  Transaction.m
//  SaldoSodexo
//
//  Created by Bruno Guidolim on 2/4/15.
//  Copyright (c) 2015 Bruno Guidolim. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction

+ (instancetype)transactionWithDictionary:(NSDictionary *)dictionary {
    Transaction *transaction = [Transaction new];
    for (NSString *key in [dictionary allKeys]) {
        [transaction setValue:dictionary[key] forKey:key];
    }
    
    return transaction;
}

@end
