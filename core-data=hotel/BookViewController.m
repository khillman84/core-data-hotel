//
//  BookViewController.m
//  core-data=hotel
//
//  Created by Kyle Hillman on 4/25/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

@import Crashlytics;

#import "BookViewController.h"
#import "AppDelegate.h"
#import "Guest+CoreDataClass.h"
#import "Guest+CoreDataProperties.h"
#import "Reservation+CoreDataClass.h"
#import "Reservation+CoreDataProperties.h"
#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"
#import "AutoLayout.h"
#import "HotelsViewController.h"

@interface BookViewController ()

@property(strong, nonatomic) UITextField *firstNameField;
@property(strong, nonatomic) UITextField *lastNameField;
@property(strong, nonatomic) UITextField *emailField;

@end

@implementation BookViewController

-(void)loadView{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupLayout];
    [self setupSaveButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setupLayout {
    self.firstNameField = [[UITextField alloc]init];
    [self.view addSubview:self.firstNameField];
    self.firstNameField.translatesAutoresizingMaskIntoConstraints = NO;
    self.firstNameField.backgroundColor = [UIColor whiteColor];
    self.firstNameField.layer.cornerRadius=8.0f;
    self.firstNameField.layer.masksToBounds=YES;
    self.firstNameField.layer.borderColor=[[UIColor blackColor]CGColor];
    self.firstNameField.layer.borderWidth= 1.0f;
    self.firstNameField.placeholder = @"First Name";
    
    self.lastNameField = [[UITextField alloc]init];
    [self.view addSubview:self.lastNameField];
    self.lastNameField.translatesAutoresizingMaskIntoConstraints = NO;
    self.lastNameField.backgroundColor = [UIColor whiteColor];
    self.lastNameField.layer.cornerRadius=8.0f;
    self.lastNameField.layer.masksToBounds=YES;
    self.lastNameField.layer.borderColor=[[UIColor blackColor]CGColor];
    self.lastNameField.layer.borderWidth= 1.0f;
    self.lastNameField.placeholder = @"Last Name";
    
    self.emailField = [[UITextField alloc]init];
    [self.view addSubview:self.emailField];
    self.emailField.translatesAutoresizingMaskIntoConstraints = NO;
    self.emailField.backgroundColor = [UIColor whiteColor];
    self.emailField.layer.cornerRadius=8.0f;
    self.emailField.layer.masksToBounds=YES;
    self.emailField.layer.borderColor=[[UIColor blackColor]CGColor];
    self.emailField.layer.borderWidth= 1.0f;
    self.emailField.placeholder = @"Email";

    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat statusBarHeight = 20.0;
    CGFloat topMargin = navBarHeight + statusBarHeight;
    CGFloat windowHeight = self.view.frame.size.height;
    CGFloat height = ((windowHeight - topMargin - 16) / 6);
    
    NSDictionary *viewDictionary = @{@"firstNameField": self.firstNameField,@"lastNameField": self.lastNameField,@"emailField": self.emailField};
    
    NSDictionary *metricsDictionary = @{@"topMargin": [NSNumber numberWithFloat:topMargin], @"height": [NSNumber numberWithFloat:height]};
    
    NSString *visualFormatString = @"V:|-topMargin-[firstNameField(==firstNameField)][lastNameField(==firstNameField)][emailField(==firstNameField)]-16-|";
    
    [AutoLayout constraintsWithVFLForViewDictionary:viewDictionary forMetricsDictionary:metricsDictionary withOptions:0 withVisualFormat:visualFormatString];

    [AutoLayout equalWidthConstraintFrom:self.firstNameField toView:self.view withMultiplier:0.8];
    [AutoLayout equalWidthConstraintFrom:self.lastNameField toView:self.view withMultiplier:0.8];
    [AutoLayout equalWidthConstraintFrom:self.emailField toView:self.view withMultiplier:0.8];

    [AutoLayout genericConstraintFrom:self.firstNameField toView:self.view withAttribute:NSLayoutAttributeCenterX];
    [AutoLayout genericConstraintFrom:self.lastNameField toView:self.view withAttribute:NSLayoutAttributeCenterX];
    [AutoLayout genericConstraintFrom:self.emailField toView:self.view withAttribute:NSLayoutAttributeCenterX];

}

-(void)setupSaveButton {
    
    UIBarButtonItem *bookingSaveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(bookingSaveButtonPressed)];
    
    [self.navigationItem setRightBarButtonItem:bookingSaveButton];
    
}

-(void)bookingSaveButtonPressed {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    
    Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:context];
    
    reservation.startDate = [NSDate date];
    reservation.endDate = [NSDate date];
    reservation.room = self.room;
    
    
    reservation.guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:context];
    reservation.guest.firstName = self.firstNameField.text;
    reservation.guest.lastName = self.lastNameField.text;
    
    NSError *saveError;
    [context save:&saveError];
    
    if (saveError) {
        NSLog(@"Save error is %@", saveError);
        
    }else{
        NSLog(@"Save reservation successful");
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
