//
//  User.m
//  Twitter
//
//  Created by Gabriel Gayán on 11/5/15.
//  Copyright © 2015 Gabriel Gayan. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@interface User()

@property (nonatomic) NSDictionary *dictionary;

@end

@implementation User

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.userId = dictionary[@"id_str"];
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        if (dictionary[@"profile_banner_url"]) {
            self.profileBannerUrl = [[NSURL alloc] initWithString:dictionary[@"profile_banner_url"]];
        }
        if (dictionary[@"profile_image_url_https"]) {
            NSString *highResUrl = [dictionary[@"profile_image_url_https"] stringByReplacingOccurrencesOfString:@"_normal.png" withString:@".png"];
            self.profileImageUrl = [[NSURL alloc] initWithString:highResUrl];
        }
        self.tagline = dictionary[@"description"];
        self.tweets = dictionary[@"statuses_count"];
        self.following = dictionary[@"friends_count"];
        self.followers = dictionary[@"followers_count"];
    }
    return self;
}

static User *_currentUser = nil;

NSString * const kCurrentUserKey = @"kCurrentUserKey";

+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    return _currentUser;
}

+ (void)setCurrentuser:(User *)currentUser {
    _currentUser = currentUser;

    if (_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }

    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)logout {
    [self setCurrentuser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

@end
