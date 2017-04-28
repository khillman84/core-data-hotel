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

@interface LookUpViewController () <UITableViewDataSource, UISearchBarDelegate>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSFetchedResultsController *reservations;
@property(strong, nonatomic) UISearchBar *searchBar;
@property(strong, nonatomic) NSArray *searchResult;
@property(strong, nonatomic) NSMutableArray *filteredReservation;
@property(strong, nonatomic) NSArray *reservationDetails;

@end

@implementation LookUpViewController

BOOL isSearching;

-(void)loadView{
    [super loadView];
    [self setupLayoutTableView];
}

-(void)setupLayoutTableView{
    self.searchBar = [[UISearchBar alloc]init];
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchBar];
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    float navBarHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat statusBarHeight = 20.0;
    CGFloat topMargin = navBarHeight + statusBarHeight;
    CGFloat windowHeight = self.view.frame.size.height;
    CGFloat height = ((windowHeight - topMargin - 16) / 6);
    
    NSDictionary *viewDictionary = @{@"searchBar": self.searchBar, @"tableView": self.tableView};
    
    NSDictionary *metricsDictionary = @{@"topMargin": [NSNumber numberWithFloat:topMargin], @"height": [NSNumber numberWithFloat:height]};
    
    NSString *visualformatString = @"V:|-topMargin-[searchBar(==topMargin)][tableView(==height)]|";
    
    [AutoLayout leadingConstraintFrom:self.searchBar toView:self.view];
    [AutoLayout trailingConstraintFrom:self.searchBar toView:self.view];
    [AutoLayout leadingConstraintFrom:self.tableView toView:self.view];
    [AutoLayout trailingConstraintFrom:self.tableView toView:self.view];
    
    [AutoLayout constraintsWithVFLForViewDictionary:viewDictionary forMetricsDictionary:metricsDictionary withOptions:0 withVisualFormat:visualformatString];
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

- (NSArray *)reservationDetails {
    if (!_reservationDetails) {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
        
        NSError *reservationError;
        
        NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
        
        NSArray *reservationDetails = [context executeFetchRequest:request error:&reservationError];
        
        if (reservationError) {
            NSLog(@"There was a reservation fetch error.");
        }
        _reservationDetails = reservationDetails;
        
    }
    return _reservationDetails;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.reservations sections]objectAtIndex:section];
//
//    return sectionInfo.numberOfObjects;
    
    if (isSearching) {
        return self.filteredReservation.count;
    } else {
        return self.reservationDetails.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    
//    Guest *currentReservation = [self.reservations objectAtIndexPath:indexPath];
    Reservation *reservations;
    if (self.filteredReservation == nil) {
        reservations = self.reservationDetails[indexPath.row];
    } else {
        reservations = self.filteredReservation[indexPath.row];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    
    
    NSString *formattedStartDateString = [dateFormatter stringFromDate:reservations.startDate];
    
    NSString *formattedEndDateString = [dateFormatter stringFromDate:reservations.endDate];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ From: %@ Check-Out: %@", reservations.guest.firstName, reservations.guest.lastName, formattedStartDateString, formattedEndDateString];
    cell.textLabel.numberOfLines = 0;
    
    //    cell.textLabel.text = [NSString stringWithFormat:@"Room: %i (%i beds, $%f per night)", currentRoom.number, currentRoom.beds, currentRoom.rate];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@", currentReservation.firstName];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.reservations.sections objectAtIndex:section];
    
    return sectionInfo.name;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.reservations.sections.count;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    isSearching = YES;
    if ([searchText isEqualToString:@""]) {
        isSearching = NO;
        self.filteredReservation = nil;
    } else {
        self.filteredReservation = [[NSMutableArray alloc]init];
        self.filteredReservation = [[self.reservationDetails filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"guest.lastName CONTAINS[c] %@ OR guest.firstName CONTAINS[c] %@", searchBar.text, searchBar.text]] mutableCopy];
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    self.filteredReservation = nil;
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
    isSearching = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar.text != nil) {
        self.filteredReservation = [[NSMutableArray alloc]init];
        self.filteredReservation = [[self.reservationDetails filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"guest.lastName CONTAINS[c] %@ OR guest.firstName CONTAINS[c] %@", searchBar.text, searchBar.text]] mutableCopy];
    }
    isSearching = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    isSearching = NO;
}

@end
