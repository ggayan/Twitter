//
//  ProfileViewController.m
//  Twitter
//
//  Created by Gabriel Gayán on 11/13/15.
//  Copyright © 2015 Gabriel Gayan. All rights reserved.
//

#import "User.h"
#import "TweetCell.h"
#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "HexColors.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *tweets;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;

    if (self.user == nil) {
        self.user = [User currentUser];
    }

    self.navigationController.navigationBar.barTintColor = [UIColor hx_colorWithHexString:@"55ACEE"];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(onBackButton)
                                   ];
    leftButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftButton;

    [self.backgroundImageView setImageWithURL:self.user.profileBannerUrl];
    [self.profileImageView setImageWithURL:self.user.profileImageUrl];

    self.nameLabel.text = self.user.name;
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", self.user.screenName];

    self.tweetsLabel.text = [self.user.tweets stringValue];
    self.followingLabel.text = [self.user.following stringValue];
    self.followersLabel.text = [self.user.followers stringValue];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setNeedsLayout];
    [self.tableView layoutIfNeeded];

    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil]
         forCellReuseIdentifier:@"TweetCell"];

    self.tweets = [NSMutableArray new];
    [self fetchTweets];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];

    cell.tweet = self.tweets[indexPath.row];

    return cell;
}

#pragma mark - Private methods

- (void)fetchTweets {
    [[TwitterClient sharedInstance] userTimeLineWithUserId:self.user.userId completion:^(NSArray *tweets, NSError *error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            return;
        }

        self.tweets = [[NSMutableArray alloc] initWithArray:tweets];
        [self.tableView reloadData];
    }];
}

- (void)onBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.masksToBounds = YES;
}

@end
