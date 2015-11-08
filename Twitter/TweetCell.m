//
//  BusinessCell.m
//  Yelp
//
//  Created by Gabriel Gayan on 15/29/10.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"

@interface TweetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation TweetCell

- (void)awakeFromNib {
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;

}

- (void) setTweet:(Tweet *)tweet {
    _tweet = tweet;
    User *user = tweet.user;
    
    [self.profileImageView setImageWithURL:user.profileImageUrl];
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];

    self.contentLabel.text = tweet.text;
    [self.contentLabel sizeToFit];

    self.dateLabel.text = tweet.createdAt.shortTimeAgoSinceNow;
}

@end
