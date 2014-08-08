//
//  CaptchaViewController.m
//  SaldoSodexo
//
//  Created by Bruno Guidolim on 8/7/14.
//  Copyright (c) 2014 Bruno Guidolim. All rights reserved.
//

#import "CaptchaViewController.h"
#import "AFNetworking.h"
#import "WebViewController.h"

@interface CaptchaViewController ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;
@property (strong, nonatomic) NSString *sessionID;
@property (weak, nonatomic) IBOutlet UIImageView *captchaImageView;
@property (weak, nonatomic) IBOutlet UITextField *captchaTextField;

@end

@implementation CaptchaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://sodexosaldocartao.com.br/saldocartao/"]];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"WebSegue"]) {
        WebViewController *vc = (WebViewController *)segue.destinationViewController;
        vc.dataToLoad = (NSData *)sender;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.manager GET:@"consultaSaldo.do?operation=setUp" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:self.manager.baseURL];
        for (NSHTTPCookie *cookie in cookies) {
            if ([cookie.name isEqualToString:@"JSESSIONID"]) {
                self.sessionID = cookie.value;
                break;
            }
        }
        
        NSMutableURLRequest *request = [self.manager.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:@"jcaptcha.do" relativeToURL:self.manager.baseURL] absoluteString] parameters:nil error:nil];
        [request setValue:[NSString stringWithFormat:@"JSESSIONID=%@",self.sessionID] forHTTPHeaderField:@"Cookie"];
        [request setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
        [request setValue:@"keep-alive" forHTTPHeaderField:@"Proxy-Connection"];
        self.manager.responseSerializer = [AFImageResponseSerializer serializer];
        
        AFHTTPRequestOperation *requestOperation = [self.manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.captchaImageView.image = (UIImage *)responseObject;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [[[UIAlertView alloc] initWithTitle:@"Erro" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }];
        [self.manager.operationQueue addOperation:requestOperation];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Erro" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }];
}

- (IBAction)loginButtonTapped:(id)sender {
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *params = [NSString stringWithFormat:@"service=5%%3B1%%3B6&cardNumber=%@&cpf=%@&jcaptcha_response=%@&x=6&y=9",
                        self.card.cardNumber,self.card.cpfNumber,self.captchaTextField.text];
    NSData *dataBody = [params dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    NSString *dataLength = [NSString stringWithFormat:@"%d", [dataBody length]];
    
    NSMutableURLRequest *request = [self.manager.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:@"consultaSaldo.do?operation=consult" relativeToURL:self.manager.baseURL] absoluteString] parameters:params error:nil];
    [request setValue:[NSString stringWithFormat:@"JSESSIONID=%@",self.sessionID] forHTTPHeaderField:@"Cookie"];
    [request setValue:dataLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"en-us" forHTTPHeaderField:@"Accept-Language"];
    [request setValue:@"https://sodexosaldocartao.com.br/saldocartao/consultaSaldo.do?operation=setUp" forHTTPHeaderField:@"Referer"];
    [request setValue:@"https://sodexosaldocartao.com.br" forHTTPHeaderField:@"Origin"];
    [request setHTTPBody:dataBody];
    
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    
    AFHTTPRequestOperation *requestOperation = [self.manager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, NSData *responseObject) {

        [self performSegueWithIdentifier:@"WebSegue" sender:responseObject];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Erro" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }];
    [self.manager.operationQueue addOperation:requestOperation];
}

@end
