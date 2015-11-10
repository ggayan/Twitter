//
//  TweetViewController.m
//  Twitter
//
//  Created by Gabriel Gayan on 15/8/11.
//  Copyright © 2015 Gabriel Gayan. All rights reserved.
//

#import "TwitterClient.h"
#import "TweetViewController.h"
#import "NewTweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"
#import "HexColors.h"

@interface TweetViewController ()

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

@implementation TweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tweet";

    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onHome)
     ];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Reply"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onReply)
     ];

    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;

    User *user = self.tweet.user;

    [self.profileImageView setImageWithURL:user.profileImageUrl];
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];

    self.contentLabel.text = self.tweet.text;
    self.dateLabel.text = [self.tweet.createdAt formattedDateWithFormat:@"M/dd/yy hh:mm a"];

    self.retweetsLabel.text = [self.tweet.retweets stringValue];
    self.favoritesLabel.text = [self.tweet.favorites stringValue];

    [self.contentLabel sizeToFit];
    [self.retweetsLabel sizeToFit];
    [self.favoritesLabel sizeToFit];

    [self configureFavoriteButtonColor];
    [self configureRetweetButtonColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onHome {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)onReply {
    NewTweetViewController *ntvc = [[NewTweetViewController alloc] initWithNibName:@"NewTweetViewController" bundle:nil];
    ntvc.initialText = [NSString stringWithFormat:@"@%@ ", self.tweet.user.screenName];

    [self.navigationController pushViewController:ntvc animated:YES];
}

# pragma mark - Button methods

- (IBAction)onReplyButton:(id)sender {
    [self onReply];
}

- (IBAction)onRetweetButton:(id)sender {
    if (!self.tweet.retweeted) {
        [[TwitterClient sharedInstance] retweetTweetId:self.tweet.tweetId completion:^(NSString *retweetId, NSError *error) {
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
                return;
            }

            self.tweet.retweeted = YES;
            self.tweet.retweetId = retweetId;
            self.tweet.retweets = @([self.tweet.retweets integerValue] + 1);
            self.retweetsLabel.text = [self.tweet.retweets stringValue];
            [self configureRetweetButtonColor];

        }];
    } else {
        [[TwitterClient sharedInstance] removeRetweetFromTweet:self.tweet completion:^(NSError *error) {
            if (error) {
                NSLog(@"could not remove retweet %@", self.tweet.retweetId);
                NSLog(@"%@", [error localizedDescription]);
                return;
            }

            self.tweet.retweeted = NO;
            self.tweet.retweetId = nil;
            self.tweet.retweets = @([self.tweet.retweets integerValue] - 1);
            self.retweetsLabel.text = [self.tweet.retweets stringValue];
            [self configureRetweetButtonColor];
        }];
    }
}

- (IBAction)onLikeButton:(id)sender {
    void (^toggleFavoriteButton)(NSError *error) = ^void(NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }

        self.tweet.favorited = !self.tweet.favorited;
        if (self.tweet.favorited) {
            self.tweet.favorites = @([self.tweet.favorites integerValue] + 1);
        } else {
            self.tweet.favorites = @([self.tweet.favorites integerValue] - 1);
        }
        self.favoritesLabel.text = [self.tweet.favorites stringValue];

        [self configureFavoriteButtonColor];
    };

    if (!self.tweet.favorited) {
        [[TwitterClient sharedInstance] favoriteTweetId:self.tweet.tweetId completion:toggleFavoriteButton];
    } else {
        [[TwitterClient sharedInstance] removeFavoriteTweetId:self.tweet.tweetId completion:toggleFavoriteButton];
    }
}

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
