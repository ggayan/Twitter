//
//  BusinessCell.h
//  Yelp
//
//  Created by Gabriel Gayan on 15/29/10.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetCell;

@protocol TweetCellDelegate <NSObject>

- (void)TweetCell:(TweetCell *)cell didPushReplyWithTweet:(Tweet *)tweet;
- (void)TweetCell:(TweetCell *)cell didPushRetweetWithTweet:(Tweet *)tweet;
- (void)TweetCell:(TweetCell *)cell didPushFavoriteWithTweet:(Tweet *)tweet;

@end

@interface TweetCell : UITableViewCell

@property (nonatomic) Tweet *tweet;
@property (weak, nonatomic) id<TweetCellDelegate> delegate;

@end
