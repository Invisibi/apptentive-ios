//
//  ApptentiveAppRelease.h
//  Apptentive
//
//  Created by Frank Schmitt on 11/15/16.
//  Copyright © 2016 Apptentive, Inc. All rights reserved.
//

#import "ApptentiveState.h"

NS_ASSUME_NONNULL_BEGIN

@class ApptentiveVersion;


/**
 An `ApptentiveAppRelease` represents a release of an application that has
 integrated the Apptentive SDK.
 */
@interface ApptentiveAppRelease : ApptentiveState

/**
 Indicates the type of app release. Will always be "ios".
 */
@property (readonly, strong, nonatomic) NSString *type;

/**
 The version object corresponding to the value of the
 `CFBundleShortVersionString` key in the application's `Info.plist` file.
 */
@property (readonly, strong, nonatomic) ApptentiveVersion *version;

/**
 The version object corresponding to the value of the `CFBundleVersion` key in
 the application's `Info.plist` file.
 */
@property (readonly, strong, nonatomic) ApptentiveVersion *build;


/**
 Indicates whether the file specified by the application's `appStoreRecieptURL`
 contains data.
 */
@property (readonly, assign, nonatomic) BOOL hasAppStoreReceipt;


/**
 Indicates whether the APPTENTIVE_DEBUG preprocessor directive is defined.
 */
@property (readonly, assign, nonatomic, getter=isDebugBuild) BOOL debugBuild;


/**
 Indicates whether the developer has accessed the style sheet object.
 */
@property (readonly, assign, nonatomic, getter=isOverridingStyles) BOOL overridingStyles;


/**
 Indicates whether the version has changed since the first release that 
 included the Apptentive SDK.
 */
@property (readonly, assign, nonatomic, getter=isUpdateVersion) BOOL updateVersion;


/**
 Indicates whether the build has changed since the first release that included
 the Apptentive SDK.
 */
@property (readonly, assign, nonatomic, getter=isUpdateBuild) BOOL updateBuild;


/**
 Records the time at which the SDK was first installed as part of the app.
 */
@property (readonly, strong, nonatomic) NSDate *timeAtInstallTotal;


/**
 Records the time at which the version changed to the current version.
 */
@property (readonly, strong, nonatomic) NSDate *timeAtInstallVersion;


/**
 Records the time at which the build changed to the current build.
 */
@property (readonly, strong, nonatomic) NSDate *timeAtInstallBuild;


/**
 Initializes an `ApptentiveAppRelease` object by inspecting the running app,
 primarily values in the app's `Info.plist` file.

 @return The new initialized app release object.
 */
- (instancetype)initWithCurrentAppRelease;

#pragma mark - Mutation

/**
 Records that the build of the current app release changed from the previous
 value. This will update the `timeAtInstallBuild` value and may update the
 `isUpdateBuild` value.
 */
- (void)resetBuild;

/**
 Records that the version of the current app release changed from the previous
 value. This will update the `timeAtInstallVersion` value and may update the
 `isUpdateVersion` value.
 */
- (void)resetVersion;

/**
 Records that the app developer has accessed the style sheet object.
 */
- (void)setOverridingStyles;

@end

NS_ASSUME_NONNULL_END
