//
//  AutoLayout.m
//  core-data=hotel
//
//  Created by Kyle Hillman on 4/24/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

#import "AutoLayout.h"

@implementation AutoLayout

+(NSArray *)fullScreenContraintsWithVFLForView:(UIView *)view{
    NSMutableArray *constraints = [[NSMutableArray alloc]init];
    
    NSDictionary *viewDictionary = @{@"view": view};
    
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewDictionary];
    
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewDictionary];
    
    [constraints addObjectsFromArray:horizontalConstraints];
    [constraints addObjectsFromArray:verticalConstraints];
    
    [NSLayoutConstraint activateConstraints:constraints];
    
    return constraints.copy;
    
}

+(NSLayoutConstraint *)genericConstraintFrom:(UIView *)view
                                      toView:(UIView *)superView
                               withAttribute:(NSLayoutAttribute)attribute
                               andMultiplier:(CGFloat)multiplier {
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:attribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:superView
                                                                  attribute:attribute
                                                                 multiplier:multiplier
                                                                   constant:0.0];
    
    constraint.active = YES;
    
    return constraint;
    
}

+(NSLayoutConstraint *)setConstraintConstantsFrom: (UIView *)view
                                           toView:(UIView *)superView
                                    withAttribute: (NSLayoutAttribute)attribute
                                      andConstant: (CGFloat)constant{
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view
                                                                  attribute:attribute
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:superView
                                                                  attribute:attribute
                                                                 multiplier:1.0
                                                                   constant:constant];
    
    constraint.active = YES;
    
    return constraint;
    
}


+(NSLayoutConstraint *)genericConstraintFrom:(UIView *)view
                                      toView:(UIView *)superView
                               withAttribute:(NSLayoutAttribute)attribute {
    
    return [AutoLayout genericConstraintFrom:view toView:superView withAttribute:attribute andMultiplier:1.0];
}

+(NSLayoutConstraint *)equalHeightConstraintFromView:(UIView *)view
                                              toView:(UIView *)otherView
                                      withMultiplier:(CGFloat)multiplier {
    
    NSLayoutConstraint *heightConstraint = [AutoLayout genericConstraintFrom:view toView:otherView withAttribute:NSLayoutAttributeHeight andMultiplier:multiplier];
    
    return heightConstraint;
    
}

+(NSLayoutConstraint *)leadingConstraintFrom:(UIView *)view
                                      toView:(UIView *)otherView {
    
    return [AutoLayout genericConstraintFrom:view toView:otherView withAttribute:NSLayoutAttributeLeading];
    
}

+(NSLayoutConstraint *)trailingConstraintFrom:(UIView *)view
                                       toView:(UIView *)otherView {
    
    return [AutoLayout genericConstraintFrom:view toView:otherView withAttribute:NSLayoutAttributeTrailing];
    
}

+(NSLayoutConstraint *)equalWidthConstraintFrom:(UIView *)view
                                         toView:(UIView *)otherView
                                 withMultiplier:(CGFloat)multiplier{
    NSLayoutConstraint *widthConstraint = [AutoLayout genericConstraintFrom:view toView:otherView withAttribute:NSLayoutAttributeWidth andMultiplier:multiplier];
    
    return widthConstraint;
}

+(NSArray *)constraintsWithVFLForViewDictionary:(NSDictionary *)viewDictionary
                           forMetricsDictionary:(NSDictionary *)metricsDictionary
                                    withOptions:(NSLayoutFormatOptions)options
                               withVisualFormat:(NSString *)visualFormat{
    NSArray *constraints = [[NSArray alloc]init];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                          options:options
                                                          metrics:metricsDictionary
                                                            views:viewDictionary];
    [NSLayoutConstraint activateConstraints:constraints];
    return constraints.copy;
}


@end









































