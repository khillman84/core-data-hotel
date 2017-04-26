//
//  BookViewController.m
//  core-data=hotel
//
//  Created by Kyle Hillman on 4/25/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import "BookViewController.h"
#import "Guest+CoreDataClass.h"
#import "Guest+CoreDataProperties.h"
#import "Reservation+CoreDataClass.h"
#import "Room+CoreDataProperties.h"

@interface BookViewController ()

@property(strong, nonatomic) UITextField *firstNameField;

@end

@implementation BookViewController

-(void)loadView{
    [super loadView];
    
    [self setupLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setupLayout {
    self.firstNameField = [[UITextField alloc]init];
    [self.view addSubview:self.firstNameField];
}


@end
