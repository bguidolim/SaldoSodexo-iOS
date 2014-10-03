//
//  CardsTableViewController.m
//  SaldoSodexo
//
//  Created by Bruno Guidolim on 8/7/14.
//  Copyright (c) 2014 Bruno Guidolim. All rights reserved.
//

#import "CardsTableViewController.h"
#import "Card.h"
#import "CaptchaViewController.h"

@interface CardsTableViewController ()

@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation CardsTableViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.cards = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"Cards"]];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CaptchaSegue"]) {
        CaptchaViewController *vc = (CaptchaViewController *)segue.destinationViewController;
        vc.card = (Card *)sender;
    }
}

#pragma mark - UITableView Datasource and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CardCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    Card *card = [Card cardWithDictionary:[self.cards objectAtIndex:indexPath.row]];
    
    cell.textLabel.text = card.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@",card.cardNumber, card.cpfNumber];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Card *card = [Card cardWithDictionary:[self.cards objectAtIndex:indexPath.row]];
    [self performSegueWithIdentifier:@"CaptchaSegue" sender:card];
}

@end
