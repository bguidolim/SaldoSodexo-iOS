//
//  ExtratoViewController.m
//  SaldoSodexo
//
//  Created by Bruno Guidolim on 10/3/14.
//  Copyright (c) 2014 Bruno Guidolim. All rights reserved.
//

#import "TransactionsViewController.h"
#import "TransactionTableViewCell.h"
#import "Transaction.h"

@interface TransactionsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSArray *fields;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TransactionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data   = [NSMutableArray new];
    
    __block NSString *lastMonth;
    
    [self.transactions enumerateObjectsUsingBlock:^(Transaction *transaction, NSUInteger idx, BOOL *stop) {
        NSString *currentMonth = [transaction.date substringWithRange:NSMakeRange(3, 2)];
        
        if (lastMonth && [currentMonth isEqualToString:lastMonth]) {
            if ([[self.data lastObject] isKindOfClass:[NSMutableArray class]]) {
                [[self.data lastObject] addObject:transaction];
            }
        } else {
            [self.data addObject:[NSMutableArray arrayWithObject:transaction]];
        }
        
        lastMonth = currentMonth;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.saldoBarButton.tintColor = [UIColor colorWithRed:0.0f green:0.7f blue:0.2f alpha:1.0f];
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.data objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *month = [(NSString*)[[[self.data objectAtIndex:section] firstObject] valueForKey:@"date" ] substringWithRange:NSMakeRange(3,2)];
    NSString *title;
    
    switch ([month integerValue])
    {
        case  1: title = @"Janeiro"; break;
        case  2: title = @"Fevereiro"; break;
        case  3: title = @"Março"; break;
        case  4: title = @"Abril"; break;
        case  5: title = @"Maio"; break;
        case  6: title = @"Junho"; break;
        case  7: title = @"Julho"; break;
        case  8: title = @"Agosto"; break;
        case  9: title = @"Setembro"; break;
        case 10: title = @"Outubro"; break;
        case 11: title = @"Novembro"; break;
        case 12: title = @"Dezembro"; break;
    }
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionTableViewCell *cell = (TransactionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TransactionCell" forIndexPath:indexPath];
    cell.transaction = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

@end
