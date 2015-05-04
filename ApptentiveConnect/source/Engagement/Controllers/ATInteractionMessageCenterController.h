//
//  ATInteractionMessageCenterController.h
//  ApptentiveConnect
//
//  Created by Peter Kamb on 3/3/14.
//  Copyright (c) 2014 Apptentive, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ATInteraction;

@interface ATInteractionMessageCenterController : NSObject

@property (nonatomic, strong, readonly) ATInteraction *interaction;
@property (nonatomic, strong) UIViewController *viewController;

- (id)initWithInteraction:(ATInteraction *)interaction;
- (void)showMessageCenterFromViewController:(UIViewController *)viewController;

@end
