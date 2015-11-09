//
//  Tweet.h
//  Twitter
//
//  Created by Gabriel Gayán on 11/5/15.
//  Copyright © 2015 Gabriel Gayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic) NSString *tweetId;
@property (nonatomic) Tweet *retweet;
@property (nonatomic) NSString *text;
@property (nonatomic) NSString *retweets;
@property (nonatomic) NSString *favorites;
@property (nonatomic) NSDate *createdAt;
@property (nonatomic) User *user;
@property (nonatomic) BOOL retweeted;
@property (nonatomic) BOOL favorited;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)tweetsWithArray:(NSArray *)array;

@end
