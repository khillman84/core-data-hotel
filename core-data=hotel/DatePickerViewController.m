//
//  DatePickerViewController.m
//  core-data=hotel
//
//  Created by Kyle Hillman on 4/25/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import "DatePickerViewController.h"
#import "AvailabilityViewController.h"
#import "AutoLayout.h"

@interface DatePickerViewController ()

@property(strong, nonatomic) UIDatePicker *endDate;
@property(strong, nonatomic) UIDatePicker *startDate;

@end

@implementation DatePickerViewController

-(void)loadView {
    [super loadView];
    
    [self setupDatePickers];
    [self setupDoneButton];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

-(void)setupDoneButton {
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    
    [self.navigationItem setRightBarButtonItem:doneButton];
    
}

-(void)doneButtonPressed {
    
    NSDate *endDate = self.endDate.date;
    NSDate *startDate = self.startDate.date;
    
    if ([[NSDate date] timeIntervalSinceReferenceDate] > [endDate timeIntervalSinceReferenceDate]) {
        self.endDate.date = [NSDate date];
        return;
    }
    
    if ([[NSDate date] timeIntervalSinceReferenceDate] > [startDate timeIntervalSinceReferenceDate]) {
        self.startDate.date = [NSDate date];
        return;
    }
    
    AvailabilityViewController *availabilityController = [[AvailabilityViewController alloc]init];
    availabilityController.endDate = endDate;
    availabilityController.startDate = startDate;
    [self.navigationController pushViewController:availabilityController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setupDatePickers {
    
    // End Date
    self.endDate = [[UIDatePicker alloc]init];
    self.endDate.datePickerMode = UIDatePickerModeDate;
    
    [self.view addSubview:self.endDate];
    
    // Start Date
    self.startDate = [[UIDatePicker alloc]init];
    self.startDate.datePickerMode = UIDatePickerModeDate;

    
    [self.view addSubview:self.startDate];
    
        self.endDate.frame = CGRectMake(0, 84.0, self.view.frame.size.width, 200.0);
        self.startDate.frame = CGRectMake(0, 284.0, self.view.frame.size.width, 200.00);
}

@end
