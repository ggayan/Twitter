//
//  TweetsViewController.m
//  Twitter
//
//  Created by Gabriel Gayan on 15/7/11.
//  Copyright © 2015 Gabriel Gayan. All rights reserved.
//

#import "TweetsViewController.h"
#import "TweetViewController.h"
#import "NewTweetViewController.h"
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"
#import "TweetCell.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate, NewTweetViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL fetching;

@end

@implementation TweetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Home";

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Sign Out"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onLogout)
     ];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"New"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onNew)
     ];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];

    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil]
         forCellReuseIdentifier:@"TweetCell"];

    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex: 0];

    self.tweets = [NSMutableArray new];

    self.fetching = NO;
    [self fetchTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onLogout {
    [User logout];
}

- (void)onNew {
    NewTweetViewController *ntvc = [[NewTweetViewController alloc] initWithNibName:@"NewTweetViewController" bundle:nil];
    ntvc.delegate = self;

    [self.navigationController pushViewController:ntvc animated:YES];
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];

    cell.delegate = self;
    cell.tweet = self.tweets[indexPath.row];

//  TODO: test this for infinite scrolling
//    if (self.tweets.count - indexPath.row < 10) {
//        [self fetchMoreTweets];
//    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    TweetViewController *tvc = [[TweetViewController alloc] initWithNibName:@"TweetViewController" bundle:nil];

    Tweet *cellTweet = self.tweets[indexPath.row];
    [[TwitterClient sharedInstance] getTweetWithTweetId:cellTweet.tweetId completion:^(Tweet *tweet, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return;
        }

        tvc.tweet = tweet;
        [self.navigationController pushViewController:tvc animated:YES];
    }];
}

#pragma mark - Cell delegate methods

- (void)TweetCell:(TweetCell *)cell didPushReplyWithTweet:(Tweet *)tweet {
    NewTweetViewController *ntvc = [[NewTweetViewController alloc] initWithNibName:@"NewTweetViewController" bundle:nil];
    ntvc.initialText = [NSString stringWithFormat:@"@%@ ", tweet.user.screenName];
    ntvc.replyingTweetId = tweet.tweetId;
    ntvc.delegate = self;

    [self.navigationController pushViewController:ntvc animated:YES];
}


- (void)TweetCell:(TweetCell *)cell didPushRetweetWithTweet:(Tweet *)tweet {
    if (!tweet.retweeted) {
        [[TwitterClient sharedInstance] retweetTweetId:tweet.tweetId completion:^(NSString *retweetId, NSError *error) {
            if (error) {
                NSLog(@"%@", [error localizedDescription]);
                return;
            }

            NSLog(@"retweet successful, tweet id %@", retweetId);
            tweet.retweeted = YES;
            tweet.retweetId = retweetId;
            cell.tweet = tweet;
        }];
    } else {
        [[TwitterClient sharedInstance] removeRetweetFromTweet:tweet completion:^(NSError *error) {
            if (error) {
                NSLog(@"could not remove retweet %@", tweet.retweetId);
                NSLog(@"%@", [error localizedDescription]);
                return;
            }

            tweet.retweeted = NO;
            tweet.retweetId = nil;
            cell.tweet = tweet;
        }];
    }
}

- (void)TweetCell:(TweetCell *)cell didPushFavoriteWithTweet:(Tweet *)tweet {
    void (^toggleFavoriteButton)(NSError *error) = ^void(NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }

        tweet.favorited = !tweet.favorited;
        cell.tweet = tweet;
    };

    if (!tweet.favorited) {
        [[TwitterClient sharedInstance] favoriteTweetId:tweet.tweetId completion:toggleFavoriteButton];
    } else {
        [[TwitterClient sharedInstance] removeFavoriteTweetId:tweet.tweetId completion:toggleFavoriteButton];
    }
}

#pragma mark - New tweet controller delegate methods

- (void)newTweetCreated:(Tweet *)tweet {
    NSLog(@"tweet received");
    [self.tweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

#pragma mark - Private methods

- (void)onRefresh {
    [self fetchTweets];
}

- (void)fetchTweets {
    if(self.fetching) {
        return;
    }
    self.fetching = YES;

    [[TwitterClient sharedInstance] homeTimeLineWithParams:nil completion:^(NSArray *tweets, NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            self.fetching = NO;
            return;
        }

        self.tweets = [[NSMutableArray alloc] initWithArray:tweets];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        self.fetching = NO;
    }];
}


- (void)fetchMoreTweets {
    if(self.fetching) {
        return;
    }
    self.fetching = YES;

    Tweet *lastTweet = [self.tweets lastObject];
    NSDictionary *params = @{@"max_id": lastTweet.tweetId};
    [[TwitterClient sharedInstance] homeTimeLineWithParams:params completion:^(NSArray *tweets, NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            self.fetching = NO;
            return;
        }

        [self.tweets addObjectsFromArray:tweets];
        [self.tableView reloadData];
        
        self.fetching = NO;
    }];
}

@end
