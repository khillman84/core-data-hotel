//
//  ViewController.m
//  core-data=hotel
//
//  Created by Kyle Hillman on 4/24/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import "ViewController.h"
#import "AutoLayout.h"
#import "HotelsViewController.h"
#import "AppDelegate.h"
#import "DatePickerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupLayout];
}

-(void)setupLayout {
    
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    
    UIButton *browseButton = [self createButtonWithTitle:@"Browse"];
    UIButton *bookButton = [self createButtonWithTitle:@"Book"];
    UIButton *lookupButton = [self createButtonWithTitle:@"Look UP"];
    
    browseButton.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:.75 alpha:1.0];
    bookButton.backgroundColor = [UIColor colorWithRed:.75 green:1.0 blue:1.0 alpha:1.0];
    lookupButton.backgroundColor = [UIColor colorWithRed:1.0 green:.75 blue:1.0 alpha:1.0];
    
    [AutoLayout leadingConstraintFrom:browseButton toView:self.view];
    [AutoLayout trailingConstraintFrom:browseButton toView:self.view];
    
    [AutoLayout leadingConstraintFrom:bookButton toView:self.view];
    [AutoLayout trailingConstraintFrom:bookButton toView:self.view];
    
    [AutoLayout leadingConstraintFrom:lookupButton toView:self.view];
    [AutoLayout trailingConstraintFrom:lookupButton toView:self.view];
    
    NSLayoutConstraint *browseButtonTop = [AutoLayout genericConstraintFrom:browseButton toView:self.view withAttribute:NSLayoutAttributeTop];
    NSLayoutConstraint *bookButtonCenter = [AutoLayout genericConstraintFrom:bookButton toView:self.view withAttribute:NSLayoutAttributeCenterY];
    
    browseButtonTop.constant = navBarHeight;
    bookButtonCenter.constant = navBarHeight / 2;
    
    [browseButton addTarget:self action:@selector(browseButtonSelected) forControlEvents:UIControlEventTouchUpInside];
    
    [bookButton addTarget:self action:@selector(bookButtonSelected) forControlEvents:UIControlEventTouchUpInside];
}

-(void)browseButtonSelected {
    HotelsViewController *vc = [[HotelsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)bookButtonSelected {
    DatePickerViewController *datePickerController = [[DatePickerViewController alloc]init];
    [self.navigationController pushViewController:datePickerController animated:YES];
}

-(void)lookupButtonSelected {
    NSLog(@"do stuff");
}

-(UIButton *)createButtonWithTitle:(NSString *)title {
    
    UIButton *button = [[UIButton alloc]init];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:button];
    
    return button;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
