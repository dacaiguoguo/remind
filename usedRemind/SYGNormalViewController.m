//
//  SYGNormalViewController.m
//  usedRemind
//
//  Created by YangBin on 12-11-27.
//  Copyright (c) 2012年 dacaiguoguo. All rights reserved.
//

#import "SYGNormalViewController.h"
#import "UIImage+SYGImage.h"
@interface SYGNormalViewController ()

@end

@implementation SYGNormalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    @autoreleasepool {
        
//        UIImage *oldImage = [UIImage imageNamed:@"login_04.png"];
//        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.0);
//        [oldImage drawInRect:self.view.bounds];
//        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage resizeImage:[UIImage imageNamed:@"jek.png"] resizeSize:self.view.bounds.size]];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
