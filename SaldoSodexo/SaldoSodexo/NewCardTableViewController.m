//
//  NewCardTableViewController.m
//  SaldoSodexo
//
//  Created by Bruno Guidolim on 8/7/14.
//  Copyright (c) 2014 Bruno Guidolim. All rights reserved.
//

#import "NewCardTableViewController.h"
#import "Card.h"

@implementation NewCardTableViewController

- (IBAction)saveCard:(id)sender {
    Card *card = [Card new];
    card.name = self.nameTextField.text;
    card.cardNumber = self.cardNumberTextField.text;
    card.cpfNumber = self.cpfNumberTextField.text;
    
    NSMutableArray *cards = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"Cards"]];
    [cards addObject:[card dictionary]];
    [[NSUserDefaults standardUserDefaults] setObject:cards forKey:@"Cards"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
