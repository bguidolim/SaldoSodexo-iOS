//
//  ExtratoViewController.h
//  SaldoSodexo
//
//  Created by Bruno Guidolim on 10/3/14.
//  Copyright (c) 2014 Bruno Guidolim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionsViewController : UIViewController

@property (strong, nonatomic) NSArray *transactions;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saldoBarButton;

@end
