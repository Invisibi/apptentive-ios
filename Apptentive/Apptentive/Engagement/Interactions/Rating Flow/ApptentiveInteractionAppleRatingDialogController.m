//
//  ApptentiveInteractionAppleRatingDialogController.m
//  Apptentive
//
//  Created by Frank Schmitt on 3/6/17.
//  Copyright © 2017 Apptentive, Inc. All rights reserved.
//

#import "ApptentiveInteractionAppleRatingDialogController.h"
#import "ApptentiveInteraction.h"
#import "Apptentive_Private.h"
#import "ApptentiveBackend+Engagement.h"
#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN

NSString *const ApptentiveInteractionAppleRatingDialogEventLabelRequest = @"request";
NSString *const ApptentiveInteractionAppleRatingDialogEventLabelShown = @"shown";
NSString *const ApptentiveInteractionAppleRatingDialogEventLabelNotShown = @"not_shown";
NSString *const ApptentiveInteractionAppleRatingDialogEventLabelFallback = @"fallback";

#define REVIEW_WINDOW_TIMEOUT 1.0


@interface ApptentiveInteractionAppleRatingDialogController ()

@property (assign, nonatomic) BOOL didShowReviewController;

@end


@implementation ApptentiveInteractionAppleRatingDialogController

+ (void)load {
	[self registerInteractionControllerClass:self forType:@"AppleRatingDialog"];
}

- (void)presentInteractionFromViewController:(nullable UIViewController *)viewController {
	[super presentInteractionFromViewController:viewController];

	[self.interaction engage:ApptentiveInteractionAppleRatingDialogEventLabelRequest fromViewController:viewController];

// Guard against not having store review controller class in OS and/or SDK
#ifdef __IPHONE_10_3
	if ([[SKStoreReviewController class] respondsToSelector:@selector(requestReview)]) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidBecomeVisible:) name:UIWindowDidBecomeVisibleNotification object:nil];

		[SKStoreReviewController performSelector:@selector(requestReview)];

		// Give the window a sec to appear before (possibly) invoking fallback
		[self performSelector:@selector(checkIfAppleRatingDialogShowed) withObject:nil afterDelay:REVIEW_WINDOW_TIMEOUT];
	} else {
		[self invokeNotShownInteractionFromViewController:viewController withReason:@"os too old"];
	}
#else
	[self invokeNotShownInteractionFromViewController:viewController withReason:@"tools too old"];
#endif
}

- (void)windowDidBecomeVisible:(NSNotification *)notification {
	if ([NSStringFromClass([notification.object class]) hasPrefix:@"SKStoreReview"]) {
		// Review window was shown
		self.didShowReviewController = YES;
		ApptentiveLogInfo(@"Apple Rating Dialog did appear.");
	}
}

- (void)checkIfAppleRatingDialogShowed {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];

	if (self.didShowReviewController) {
		[self.interaction engage:ApptentiveInteractionAppleRatingDialogEventLabelShown fromViewController:self.presentingViewController];
	} else {
		[self invokeNotShownInteractionFromViewController:self.presentingViewController withReason:nil];
	}
}

- (void)invokeNotShownInteractionFromViewController:(UIViewController *)viewController withReason:(nullable NSString *)notShownReason {
	NSDictionary *userInfo = nil;

	if (notShownReason != nil) {
		userInfo = @{ @"cause": notShownReason };
	} else {
		// Don't include nil notShownReason in userinfo, but explain in log message
		notShownReason = @"reached limit or user disabled";
	}

	ApptentiveLogInfo(@"Apple Rating Dialog did not appear (reason: %@)", notShownReason);

	[self.interaction engage:ApptentiveInteractionAppleRatingDialogEventLabelNotShown fromViewController:viewController userInfo:userInfo];

	NSString *notShownInteractionIdentifier = self.interaction.configuration[@"not_shown_interaction"];

	if (notShownInteractionIdentifier != nil) {
		ApptentiveInteraction *interaction = [Apptentive.shared.backend interactionForIdentifier:notShownInteractionIdentifier];

		if (interaction) {
			[self.interaction engage:ApptentiveInteractionAppleRatingDialogEventLabelFallback fromViewController:viewController userInfo:@{ @"fallback_interaction_id": notShownInteractionIdentifier }];

			[[Apptentive sharedConnection].backend presentInteraction:interaction fromViewController:viewController];
		} else {
			ApptentiveLogError(@"Apple rating dialog fallback interaction has invalid id: %@", notShownInteractionIdentifier);
		}
	} else {
		ApptentiveLogInfo(@"Apple Rating Dialog fallback interaction not configured.");
	}
}

@end

NS_ASSUME_NONNULL_END
