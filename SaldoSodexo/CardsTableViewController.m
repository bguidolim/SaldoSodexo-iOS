//
//  CardsTableViewController.m
//  SaldoSodexo
//
//  Created by Bruno Guidolim on 8/7/14.
//  Copyright (c) 2014 Bruno Guidolim. All rights reserved.
//

#import "CardsTableViewController.h"
#import "TransactionsViewController.h"
#import "Card.h"
#import "Transaction.h"
#import "AFNetworking.h"
#import "JGProgressHUD.h"

@interface CardsTableViewController ()

@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

@implementation CardsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://www.app.sodexo.com.br/PMobileServer/"]];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.cards = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"Cards"]];
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TransactionsSegue"]) {
        TransactionsViewController *vc = (TransactionsViewController *)segue.destinationViewController;
        vc.saldoBarButton.title = [(NSArray *)sender objectAtIndex:0];
        vc.transactions = [(NSArray *)sender objectAtIndex:1];
    }
}

- (void)saveCards {
    [[NSUserDefaults standardUserDefaults] setObject:self.cards forKey:@"Cards"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.cards removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [self saveCards];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Apagar";
}

#pragma mark - UITableView Datasource and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cards.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CardCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    Card *card = [Card cardWithDictionary:[self.cards objectAtIndex:indexPath.row]];
    
    cell.textLabel.text         = card.name;
    cell.detailTextLabel.text   = [NSString stringWithFormat:@"%@",card.cardNumber];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Card *card = [Card cardWithDictionary:[self.cards objectAtIndex:indexPath.row]];
    
    JGProgressHUD *hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    [hud showInView:self.view animated:YES];
    
    [self.manager POST:@"Primeth" parameters:@{@"th":@"thsaldo", @"cardNumber":card.cardNumber, @"document":card.cpfNumber} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud dismiss];
        
        NSMutableArray *array = [NSMutableArray new];
        NSString *balanceAmount;
        
        if ([responseObject objectForKey:@"balanceAmount"]) {
            balanceAmount = [responseObject objectForKey:@"balanceAmount"];
        }
        
        if ([responseObject objectForKey:@"transactions"]) {
            [[responseObject objectForKey:@"transactions"] enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
                Transaction *transaction = [Transaction transactionWithDictionary:dict];
                [array addObject:transaction];
            }];
        }
        
        [self performSegueWithIdentifier:@"TransactionsSegue" sender:@[balanceAmount,array]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud dismiss];
        [[[UIAlertView alloc] initWithTitle:@"Erro" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }];
}

- (IBAction)unwindToCardsViewController:(UIStoryboardSegue *)segue {
    //nothing goes here
}

@end
