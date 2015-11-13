//
//  Tweet.m
//  Twitter
//
//  Created by Gabriel Gayán on 11/5/15.
//  Copyright © 2015 Gabriel Gayan. All rights reserved.
//

#import "Tweet.h"
#import "NSDate+DateTools.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.tweetId = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.retweets = dictionary[@"retweet_count"];
        self.favorites = dictionary[@"favorite_count"];
        self.createdAt = [NSDate dateWithString:dictionary[@"created_at"] formatString:@"EEE MMM d HH:mm:ss Z y"];
        self.favorited = [dictionary[@"favorited"] boolValue];
        [self configureRetweetedStatus:dictionary];
    }
    return self;
}

+ (NSArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];

    for (NSDictionary *tweet in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:tweet]];
    }

    return tweets;
}

- (void)configureRetweetedStatus:(NSDictionary *)dictionary {
    self.retweeted = [dictionary[@"retweeted"] boolValue];

    if (self.retweeted && dictionary[@"retweeted_status"]) {
        self.originalTweetId = dictionary[@"retweeted_status"][@"id_str"];
    } else {
        self.originalTweetId = self.tweetId;
    }

    if (dictionary[@"current_user_retweet"]) {
        self.retweetId = dictionary[@"current_user_retweet"][@"id_str"];
    }
}

@end
