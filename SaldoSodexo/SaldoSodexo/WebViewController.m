//
//  WebViewController.m
//  SaldoSodexo
//
//  Created by Bruno Guidolim on 8/8/14.
//  Copyright (c) 2014 Bruno Guidolim. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *responseString = [self.dataToLoad base64EncodedStringWithOptions:0];
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:responseString options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSASCIIStringEncoding];
    
    [self.webView loadHTMLString:decodedString baseURL:[NSURL URLWithString:@"https://sodexosaldocartao.com.br/saldocartao/"]];
}

@end
