//
//  RoomsViewController.h
//  core-data=hotel
//
//  Created by Kyle Hillman on 4/24/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hotel+CoreDataClass.h"
#import "Hotel+CoreDataProperties.h"

@interface RoomsViewController : UIViewController

@property (strong, nonatomic) Hotel *hotel;

@end
