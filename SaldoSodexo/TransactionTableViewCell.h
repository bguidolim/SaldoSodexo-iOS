//
//  ExtratoTableViewCell.h
//  SaldoSodexo
//
//  Created by Bruno Guidolim on 10/3/14.
//  Copyright (c) 2014 Bruno Guidolim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transaction.h"

@interface TransactionTableViewCell : UITableViewCell

@property (strong, nonatomic) Transaction *transaction;

@end
