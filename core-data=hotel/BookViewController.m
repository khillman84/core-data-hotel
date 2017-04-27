//
//  BookViewController.m
//  core-data=hotel
//
//  Created by Kyle Hillman on 4/25/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

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
    
    [AutoLayout setConstraintConstantsFrom:self.firstNameField toView:self.view withAttribute:NSLayoutAttributeTop andConstant:200];
    [AutoLayout setConstraintConstantsFrom:self.firstNameField toView:self.view withAttribute:NSLayoutAttributeLeft andConstant:40];
    [AutoLayout setConstraintConstantsFrom:self.firstNameField toView:self.view withAttribute:NSLayoutAttributeRight andConstant:-40];
    self.firstNameField.placeholder = @"First Name";
    
    self.lastNameField = [[UITextField alloc]init];
    [self.view addSubview:self.lastNameField];
    self.lastNameField.translatesAutoresizingMaskIntoConstraints = NO;
    self.lastNameField.backgroundColor = [UIColor whiteColor];
    
    [AutoLayout setConstraintConstantsFrom:self.lastNameField toView:self.view withAttribute:NSLayoutAttributeTop andConstant:200];
    [AutoLayout setConstraintConstantsFrom:self.lastNameField toView:self.view withAttribute:NSLayoutAttributeLeft andConstant:40];
    [AutoLayout setConstraintConstantsFrom:self.lastNameField toView:self.view withAttribute:NSLayoutAttributeRight andConstant:-40];
    self.firstNameField.placeholder = @"Last Name";

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
