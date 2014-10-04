//
//  CaptchaViewController.h
//  SaldoSodexo
//
//  Created by Bruno Guidolim on 8/7/14.
//  Copyright (c) 2014 Bruno Guidolim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CaptchaViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) Card *card;

@end
