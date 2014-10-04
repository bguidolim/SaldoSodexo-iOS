//
//  ExtratoViewController.m
//  SaldoSodexo
//
//  Created by Bruno Guidolim on 10/3/14.
//  Copyright (c) 2014 Bruno Guidolim. All rights reserved.
//

#import "TransactionsViewController.h"
#import "TransactionTableViewCell.h"
#import <HTMLReader/HTMLReader.h>
#import "Constants.h"

@interface TransactionsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSArray *fields;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saldoBarButton;

@end

@implementation TransactionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data   = [NSMutableArray new];
    self.fields = @[@"date",@"value",@"type",@"authorization",@"description"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *responseString = [self.dataToLoad base64EncodedStringWithOptions:0];
    NSData   *decodedData    = [[NSData alloc] initWithBase64EncodedString:responseString options:0];
    NSString *decodedString  = [[NSString alloc] initWithData:decodedData encoding:NSASCIIStringEncoding];
    
    HTMLDocument *document   = [HTMLDocument documentWithString:decodedString];
    
    HTMLSelector *selector    = [HTMLSelector selectorForString:@"#balance"];
    HTMLElement  *elem        = [document firstNodeMatchingParsedSelector:selector];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [elem.childElementNodes enumerateObjectsUsingBlock:^(HTMLElement *elemNote, NSUInteger idx, BOOL *stop) {
        if (idx == 0) {
            [dict setObject:[elemNote.textContent uppercaseString] forKey:@"description"];
        } else {
            NSArray *parts    = [elemNote.textContent componentsSeparatedByString:@":"];
            NSString *date    = [[parts objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *balance = [[parts objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            [dict setObject:date forKey:@"date"];
            [dict setObject:balance forKey:@"value"];
        }
    }];
    
    NSString *balance = [dict objectForKey:@"value"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    self.saldoBarButton.title = [balance stringByReplacingOccurrencesOfString:@"." withString:[formatter decimalSeparator]];
    self.saldoBarButton.tintColor = [UIColor colorWithRed:0.0f green:0.7f blue:0.2f alpha:1.0f];
    
    selector = [HTMLSelector selectorForString:@"#gridSaldo"];
    elem = [document firstNodeMatchingParsedSelector:selector];
    __block HTMLElement *extrato;
    [elem.childElementNodes enumerateObjectsUsingBlock:^(HTMLElement *obj, NSUInteger idx, BOOL *stop) {
        if ([[obj tagName] isEqualToString:@"tbody"]) {
            extrato = (HTMLElement *)obj;
            *stop = YES;
        }
    }];
    
    __block NSString *lastMonth;
    
    [extrato.childElementNodes enumerateObjectsUsingBlock:^(HTMLElement *obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [obj.childElementNodes enumerateObjectsUsingBlock:^(HTMLElement *elemNote, NSUInteger idx, BOOL *stop) {
            [dict setObject:[elemNote.textContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:[self.fields objectAtIndex:idx]];
        }];
        
        if ([dict objectForKey:@"date"]) {
            NSString *currentMonth = [(NSString*)[dict objectForKey:@"date"] substringWithRange:NSMakeRange(3,2)];
            
            if (lastMonth && [currentMonth isEqualToString:lastMonth]) {
                if ([[self.data lastObject] isKindOfClass:[NSMutableArray class]]) {
                    [[self.data lastObject] addObject:dict];
                }
            } else {
                [self.data addObject:[NSMutableArray arrayWithObject:dict]];
            }
            
            lastMonth = currentMonth;
        }
    }];
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
    cell.dict = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

@end
