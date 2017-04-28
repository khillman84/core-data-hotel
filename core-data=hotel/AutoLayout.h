//
//  AutoLayout.h
//  core-data=hotel
//
//  Created by Kyle Hillman on 4/24/17.
//  Copyright © 2017 Kyle Hillman. All rights reserved.
//

@import UIKit;

@interface AutoLayout : NSObject

+(NSLayoutConstraint *)genericConstraintFrom:(UIView *)view
                                      toView:(UIView *)superView
                               withAttribute:(NSLayoutAttribute)attribute
                               andMultiplier:(CGFloat)multiplier;

+(NSLayoutConstraint *)genericConstraintFrom:(UIView *)view
                                      toView:(UIView *)superView
                               withAttribute:(NSLayoutAttribute)attribute;

+(NSArray *)fullScreenContraintsWithVFLForView:(UIView *)view;

+(NSLayoutConstraint *)equalHeightConstraintFromView:(UIView *)view
                                              toView:(UIView *)otherView
                                      withMultiplier:(CGFloat)multiplier;

+(NSLayoutConstraint *)leadingConstraintFrom:(UIView *)view
                                      toView:(UIView *)otherView;

+(NSLayoutConstraint *)trailingConstraintFrom:(UIView *)view
                                       toView:(UIView *)otherView;

+(NSLayoutConstraint *)setConstraintConstantsFrom: (UIView *)view
                                           toView:(UIView *)superView
                                    withAttribute: (NSLayoutAttribute)attribute
                                      andConstant: (CGFloat)constant;

+(NSLayoutConstraint *)equalWidthConstraintFrom:(UIView *)view
                                         toView:(UIView *)otherView
                                 withMultiplier:(CGFloat)multiplier;

+(NSArray *)constraintsWithVFLForViewDictionary:(NSDictionary *)viewDictionary
                           forMetricsDictionary:(NSDictionary *)metricsDictionary
                                    withOptions:(NSLayoutFormatOptions)options
                               withVisualFormat:(NSString *)visualFormat;

@end
