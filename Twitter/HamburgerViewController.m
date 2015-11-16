//
//  MenuViewController.m
//  Twitter
//
//  Created by Gabriel Gayán on 11/12/15.
//  Copyright © 2015 Gabriel Gayan. All rights reserved.
//

#import "HamburgerViewController.h"
#import "MenuViewController.h"
#import "ProfileViewController.h"
#import "TimelineViewController.h"

@interface HamburgerViewController () <MenuViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic) MenuViewController *menuViewController;
@property (nonatomic) ProfileViewController *profileViewController;
@property (nonatomic) UINavigationController *timelineViewController;
@property (nonatomic) UINavigationController *mentionsViewController;
@property (nonatomic) UIViewController *selectedController;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginConstraint;
@property (nonatomic) CGFloat originalLeftMargin;

@end

@implementation HamburgerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuViewController = [MenuViewController new];
    self.profileViewController = [ProfileViewController new];
    self.timelineViewController = [[UINavigationController alloc] initWithRootViewController:[TimelineViewController new]];

    TimelineViewController *tvc = [TimelineViewController new];
    tvc.useMentions = YES;
    self.mentionsViewController = [[UINavigationController alloc] initWithRootViewController:tvc];

    [self addChildViewController:self.menuViewController];
    [self.menuView addSubview:self.menuViewController.view];
    self.menuViewController.delegate = self;

    self.profileViewController.view.frame = self.contentView.frame;
    self.timelineViewController.view.frame = self.contentView.frame;
    self.mentionsViewController.view.frame = self.contentView.frame;

    self.selectedController = self.timelineViewController;
    [self addChildViewController:self.timelineViewController];
    [self.contentView addSubview:self.timelineViewController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];

    if (sender.state == UIGestureRecognizerStateBegan) {
        self.originalLeftMargin = self.leftMarginConstraint.constant;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        if (self.leftMarginConstraint.constant + translation.x > self.originalLeftMargin) {
            self.leftMarginConstraint.constant = self.originalLeftMargin + translation.x;
        }

    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.3 animations:^{
            if (velocity.x > 0) {
                self.leftMarginConstraint.constant = self.view.frame.size.width - 50;
            } else {
                self.leftMarginConstraint.constant = 0;
            }
            [self.view layoutIfNeeded];
        }];
    }
}

-(void)didSelectView:(ControllerSelection)selection {
    UIViewController *oldController = self.selectedController;

    switch (selection) {
        case profile:
            self.selectedController = self.profileViewController;
            break;
        case timeline:
            self.selectedController = self.timelineViewController;
            break;
        case mentions:
            self.selectedController = self.mentionsViewController;
            break;
        default:
            break;
    }

    if (oldController == self.selectedController) {
        [UIView animateWithDuration:0.3 animations:^{
            self.leftMarginConstraint.constant = 0;
            [self.view layoutIfNeeded];
        }];
        return;
    }

    [oldController willMoveToParentViewController:nil];
    [oldController removeFromParentViewController];
    [oldController.view removeFromSuperview];

    [self addChildViewController:self.selectedController];
    [self.contentView addSubview:self.selectedController.view];
    [self.selectedController didMoveToParentViewController:self];

    [UIView animateWithDuration:0.3 animations:^{
        self.leftMarginConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

@end
