//
//  NewTweetViewController.m
//  Twitter
//
//  Created by Gabriel Gayan on 15/8/11.
//  Copyright © 2015 Gabriel Gayan. All rights reserved.
//

#import "NewTweetViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

@interface NewTweetViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation NewTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onCancel)
     ];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Tweet"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onTweet)
     ];

    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;

    User *user = [User currentUser];

    [self.profileImageView setImageWithURL:user.profileImageUrl];
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = user.screenName;

    self.textView.text = self.initialText ? self.initialText : @"";
    [self.textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)onCancel {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)onTweet {
    [[TwitterClient sharedInstance] createTweetWithText:self.textView.text replyingTweetId:self.replyingTweetId completion:^(Tweet *tweet, NSError *error) {
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
            return;
        }

        [self.delegate newTweetCreated:tweet];
        [[self navigationController] popViewControllerAnimated:YES];
    }];
}

@end
