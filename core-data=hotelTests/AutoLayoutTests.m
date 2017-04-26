//
//  AutoLayoutTests.m
//  core-data=hotel
//
//  Created by Kyle Hillman on 4/26/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AutoLayout.h"

@interface AutoLayoutTests : XCTestCase

@property(strong, nonatomic) UIViewController *testController;
@property(strong, nonatomic) UIView *testView1;
@property(strong, nonatomic) UIView *testView2;

@end

@implementation AutoLayoutTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.testController = [[UIViewController alloc]init];
    self.testView1 =[[UIView alloc]init];
    self.testView2 =[[UIView alloc]init];
    
    [self.testController.view addSubview:self.testView1];
    [self.testController.view addSubview:self.testView2];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.testController = nil;
    
    [super tearDown];
}

-(void)testGenericConstraintFromtoViewwithAttribute {
    
    XCTAssertNotNil(self.testController, @"The testController is nil");
    XCTAssertNotNil(self.testView1, @"self.testView1 is nil");
    XCTAssertNotNil(self.testView2, @"self.testView2 is nil");
    
    id constraint = [AutoLayout genericConstraintFrom:self.testView1 toView:self.testView2 withAttribute:NSLayoutAttributeTop];
    
    XCTAssert([constraint isKindOfClass:[NSLayoutConstraint class]], @"constraint is not an instance of NSLayoutContraint");
    
    XCTAssertTrue([(NSLayoutConstraint *)constraint isActive], @"Constraint was not activated");
    
}

@end
