//
//  DatePickerViewController.m
//  core-data=hotel
//
//  Created by Kyle Hillman on 4/25/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import "DatePickerViewController.h"
#import "AvailabilityViewController.h"

@interface DatePickerViewController ()

@property(strong, nonatomic) UIDatePicker *endDate;

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
    
    if ([[NSDate date] timeIntervalSinceReferenceDate] > [endDate timeIntervalSinceReferenceDate]) {
        self.endDate.date = [NSDate date];
        return;
    }
    
    AvailabilityViewController *availabilityController = [[AvailabilityViewController alloc]init];
    availabilityController.endDate = endDate;
    [self.navigationController pushViewController:availabilityController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setupDatePickers {
    
    self.endDate = [[UIDatePicker alloc]init];
    self.endDate.datePickerMode = UIDatePickerModeDate;
    
    self.endDate.frame = CGRectMake(0, 84.0, self.view.frame.size.width, 200.0); //refactor for auto layout
    
    [self.view addSubview:self.endDate];
    
}

@end
