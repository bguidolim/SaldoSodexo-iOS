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

@interface TransactionsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) NSArray *fields;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TransactionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = [NSMutableArray new];
    self.fields = @[@"date",@"value",@"type",@"authorization",@"description"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *responseString = [self.dataToLoad base64EncodedStringWithOptions:0];
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:responseString options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSASCIIStringEncoding];
    
    HTMLDocument *document = [HTMLDocument documentWithString:decodedString];
    HTMLSelector *selector = [HTMLSelector selectorForString:@"#gridSaldo"];
    HTMLElement *elem = [document firstNodeMatchingParsedSelector:selector];
    __block HTMLElement *extrato;
    [elem.childElementNodes enumerateObjectsUsingBlock:^(HTMLElement *obj, NSUInteger idx, BOOL *stop) {
        if ([[obj tagName] isEqualToString:@"tbody"]) {
            extrato = (HTMLElement *)obj;
            *stop = YES;
        }
    }];
    
    [extrato.childElementNodes enumerateObjectsUsingBlock:^(HTMLElement *obj, NSUInteger idx, BOOL *stop) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [obj.childElementNodes enumerateObjectsUsingBlock:^(HTMLElement *elemNote, NSUInteger idx, BOOL *stop) {
            [dict setObject:elemNote.textContent forKey:[self.fields objectAtIndex:idx]];
        }];
        
        [self.data addObject:dict];
    }];
}

#pragma mark - TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionTableViewCell *cell = (TransactionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"TransactionCell" forIndexPath:indexPath];
    cell.dict = [self.data objectAtIndex:indexPath.row];
    
    return cell;
}

@end
