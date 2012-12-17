//
//  SYGViewController.m
//  remindDemo
//
//  Created by YangBin on 12-12-17.
//  Copyright (c) 2012年 dacaiguoguo. All rights reserved.
//

#import "SYGViewController.h"
#import "SYGTableViewViewController.h"
@interface SYGViewController ()

@end

@implementation SYGViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)beginAction:(id)sender {
    SYGTableViewViewController *iTableViewVC = [[SYGTableViewViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:iTableViewVC animated:YES];
    [iTableViewVC release];
}
@end
