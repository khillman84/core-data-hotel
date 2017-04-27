//
//  LookUpViewController.m
//  core-data=hotel
//
//  Created by Kyle Hillman on 4/27/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import "LookUpViewController.h"
#import "AutoLayout.h"
#import "AppDelegate.h"
#import "Reservation+CoreDataProperties.h"
#import "Reservation+CoreDataClass.h"
#import "Guest+CoreDataClass.h"
#import "Guest+CoreDataProperties.h"
#import "RoomsViewController.h"
#import "Reservation+CoreDataProperties.h"
#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"
#import "ViewController.h"

@interface LookUpViewController () <UITableViewDataSource>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSFetchedResultsController *reservations;

@end

@implementation LookUpViewController

-(void)loadView{
    [super loadView];
    [self setupLayoutTableView];
}

-(void)setupLayoutTableView{
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [AutoLayout fullScreenContraintsWithVFLForView:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

-(NSFetchedResultsController *)reservations{
    if (!_reservations) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        
        NSError *reservationError;
        NSArray *results = [appDelegate.persistentContainer.viewContext executeFetchRequest:request error:&reservationError];
        
        NSMutableArray *reservedGuests = [[NSMutableArray alloc]init];
        for (Reservation *reservation in results) {
            [reservedGuests addObject:reservation.guest];
        }
        
        NSFetchRequest *guestRequest = [NSFetchRequest fetchRequestWithEntityName:@"Guest"];
        guestRequest.predicate = [NSPredicate predicateWithFormat:@"self IN %@", reservedGuests];
        
        NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
        NSSortDescriptor *hotelSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"reservation.room.hotel.name" ascending:YES];
        
        guestRequest.sortDescriptors = @[nameSortDescriptor, hotelSortDescriptor];
        
        NSError *guestError;
        
        _reservations = [[NSFetchedResultsController alloc]initWithFetchRequest:guestRequest managedObjectContext:appDelegate.persistentContainer.viewContext sectionNameKeyPath:@"reservation.room.hotel.name" cacheName:nil];
        
        [_reservations performFetch:&guestError];
    }
    
    return _reservations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.reservations sections]objectAtIndex:section];
    
    return sectionInfo.numberOfObjects;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Guest *currentReservation = [self.reservations objectAtIndexPath:indexPath];
    
    //    cell.textLabel.text = [NSString stringWithFormat:@"Room: %i (%i beds, $%f per night)", currentRoom.number, currentRoom.beds, currentRoom.rate];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", currentReservation.firstName];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.reservations.sections objectAtIndex:section];
    
    return sectionInfo.name;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.reservations.sections.count;
}

@end
