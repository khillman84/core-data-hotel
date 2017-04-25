//
//  RoomsViewController.m
//  core-data=hotel
//
//  Created by Kyle Hillman on 4/24/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import "RoomsViewController.h"
#import "AppDelegate.h"
#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"
#import "Room+CoreDataClass.h"
#import "Room+CoreDataProperties.h"

@interface RoomsViewController () <UITableViewDataSource>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSArray *allRooms;

@end

@implementation RoomsViewController

-(void)loadView {
    [super loadView];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    [self allRooms];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

-(NSArray *)allRooms {
    if (!_allRooms) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
        
        NSError *fetchError;
        NSArray *rooms = [context executeFetchRequest:request error:&fetchError];
        
        if (fetchError) {
            NSLog(@"There wan an error fetching rooms from Core Data");
        }
        
        _allRooms = rooms;
    }
    
    return _allRooms;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allRooms.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"cell" forIndexPath: indexPath];
    Room *currentRoom = self.allRooms[indexPath.row];
    
    cell.textLabel.text =  [NSString stringWithFormat:@"%d", currentRoom.number];
    return cell;
}


@end
