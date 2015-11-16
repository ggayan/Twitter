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
#import "TwitterClient.h"
#import "HexColors.h"
#import "NewTweetViewController.h"

@interface TweetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetCell

- (void)awakeFromNib {
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageTapped:)];
    [self.profileImageView addGestureRecognizer:tapRecognizer];
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
    self.retweetsLabel.text = [self.tweet.retweets stringValue];
    self.favoritesLabel.text = [self.tweet.favorites stringValue];
    [self configureRetweetButtonColor];
    [self configureFavoriteButtonColor];
}

# pragma mark - Button methods

- (IBAction)onReplyButton:(id)sender {
    [self.delegate TweetCell:self didPushReplyWithTweet:self.tweet];
}

- (IBAction)onRetweetButton:(id)sender {
    [self.delegate TweetCell:self didPushRetweetWithTweet:self.tweet];
}

- (IBAction)onLikeButton:(id)sender {
    [self.delegate TweetCell:self didPushFavoriteWithTweet:self.tweet];
}

# pragma mark - Image tapped method

- (IBAction)onImageTapped:(id)sender {
        [self.delegate TweetCell:self didTapProfileImageWithTweet:self.tweet];
}

# pragma mark - Private methods

- (void)configureRetweetButtonColor {
    if (self.tweet.retweeted) {
        self.retweetButton.tintColor = [UIColor hx_colorWithHexString:@"#19CF86"];
    } else {
        self.retweetButton.tintColor = [UIColor hx_colorWithHexString:@"#AAB8C2"];
    }
}

- (void)configureFavoriteButtonColor {
    if (self.tweet.favorited) {
        self.favoriteButton.tintColor = [UIColor hx_colorWithHexString:@"#19CF86"];
    } else {
        self.favoriteButton.tintColor = [UIColor hx_colorWithHexString:@"#AAB8C2"];
    }
}


@end
