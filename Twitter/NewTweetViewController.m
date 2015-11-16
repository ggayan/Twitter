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
#import "HexColors.h"

@interface NewTweetViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainingTextLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation NewTweetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.navigationController.navigationBar.barTintColor = [UIColor hx_colorWithHexString:@"55ACEE"];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(onCancel)
                                   ];;
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(onTweet)
                                    ];;

    leftButton.tintColor = [UIColor whiteColor];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.rightBarButtonItem = rightButton;

    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;

    User *user = [User currentUser];

    [self.profileImageView setImageWithURL:user.profileImageUrl];
    self.nameLabel.text = user.name;
    self.screenNameLabel.text = user.screenName;

    self.textView.text = self.initialText ? self.initialText : @"";
    self.textView.delegate = self;
    self.remainingTextLabel.text = [@(140 - [self.textView.text length]) stringValue];
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

#pragma mark - Textview methods

- (void)textViewDidChange:(UITextView *)textView {
    self.remainingTextLabel.text = [@(140 - [self.textView.text length]) stringValue];
}

@end
