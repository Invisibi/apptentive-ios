//
//  ATInteractionFeedbackDialogController.h
//  ApptentiveConnect
//
//  Created by Peter Kamb on 3/3/14.
//  Copyright (c) 2014 Apptentive, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATMessagePanelViewController.h"
@class ATInteraction;

@interface ATInteractionFeedbackDialogController : NSObject <ATMessagePanelDelegate, UIAlertViewDelegate>

@property (nonatomic, strong, readonly) ATInteraction *interaction;
@property (nonatomic, strong) UIViewController *viewController;

- (id)initWithInteraction:(ATInteraction *)interaction;
- (void)showFeedbackDialogFromViewController:(UIViewController *)viewController;

@end
