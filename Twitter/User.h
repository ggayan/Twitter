//
//  User.h
//  Twitter
//
//  Created by Gabriel Gayán on 11/5/15.
//  Copyright © 2015 Gabriel Gayan. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic) NSString *userId;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *screenName;
@property (nonatomic) NSURL *profileBannerUrl;
@property (nonatomic) NSURL *profileImageUrl;
@property (nonatomic) NSString *tagline;
@property (nonatomic) NSNumber *tweets;
@property (nonatomic) NSNumber *following;
@property (nonatomic) NSNumber *followers;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (User *)currentUser;
+ (void)setCurrentuser:(User *)currentUser;
+ (void)logout;

@end
