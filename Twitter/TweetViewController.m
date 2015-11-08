//
//  TweetViewController.m
//  Twitter
//
//  Created by Gabriel Gayan on 15/8/11.
//  Copyright © 2015 Gabriel Gayan. All rights reserved.
//

#import "TweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+DateTools.h"

@interface TweetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

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
    [self.contentLabel sizeToFit];

    self.dateLabel.text = self.tweet.createdAt.timeAgoSinceNow;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onHome {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)onReply {
    NSLog(@"onReply");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
