//
//  AvailabilityViewController.m
//  core-data=hotel
//
//  Created by Kyle Hillman on 4/25/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import "AvailabilityViewController.h"
#import "AutoLayout.h"
#import "AppDelegate.h"
#import "Reservation+CoreDataClass.h"
#import "Reservation+CoreDataProperties.h"
#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"
#import "BookViewController.h"
#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"

@interface AvailabilityViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSFetchedResultsController *availableRooms;

@end

@implementation AvailabilityViewController

-(NSFetchedResultsController *)availableRooms {
    
    if (!_availableRooms) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        
        request.predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@", self.endDate, self.startDate]; 
        
        NSError *roomError;
        NSArray *results = [appDelegate.persistentContainer.viewContext executeFetchRequest:request error: &roomError];
        
        NSMutableArray *unavailableRooms = [[NSMutableArray alloc]init];
        
        for (Reservation *reservation in results) {
            [unavailableRooms addObject:reservation.room];
        }
        
        NSFetchRequest *roomRequest = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
        roomRequest.predicate = [NSPredicate predicateWithFormat:@"NOT self IN %@", unavailableRooms];
        
        NSSortDescriptor *roomSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"hotel.name" ascending:YES];
        
        roomRequest.sortDescriptors = @[roomSortDescriptor];
        
        NSError *availableRoomError;
        
        _availableRooms = [[[NSFetchedResultsController alloc]init] initWithFetchRequest:roomRequest managedObjectContext:appDelegate.persistentContainer.viewContext sectionNameKeyPath:@"hotel.name" cacheName:nil];
        
        [_availableRooms performFetch: &availableRoomError];
//        _availableRooms = [appDelegate.persistentContainer.viewContext executeFetchRequest:roomRequest error: &availableRoomError];
    }
    
    return _availableRooms;
}

-(void)loadView {
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setupTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setupTableView {
    
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [AutoLayout fullScreenContraintsWithVFLForView:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.availableRooms sections]objectAtIndex:section];
    return sectionInfo.numberOfObjects;
    
//    return self.availableRooms.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Room *currentRoom = [self.availableRooms objectAtIndexPath:indexPath];
    
//    Room *currentRoom = self.availableRooms[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%i", currentRoom.number];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Room *currentRoom = [self.availableRooms objectAtIndexPath:indexPath];
    
    BookViewController *book = [[BookViewController alloc]init];
    book.room = currentRoom;
//    book.endDate = self.endDate;
    [self.navigationController pushViewController:book animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.availableRooms.sections.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.availableRooms.sections objectAtIndex:section];
    
    return sectionInfo.name;
}

@end
























