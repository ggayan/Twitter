//
//  MenuViewController.m
//  Twitter
//
//  Created by Gabriel Gayán on 11/12/15.
//  Copyright © 2015 Gabriel Gayan. All rights reserved.
//

#import "MenuViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *taglineLabel;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];

    User *user = [User currentUser];

    [self.profileImageView setImageWithURL:user.profileImageUrl];
    self.profileImageView.layer.cornerRadius = 3;
    self.profileImageView.clipsToBounds = YES;
    
    self.nameLabel.text = user.name;

    self.taglineLabel.text = user.tagline;
    [self.taglineLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [UITableViewCell new];

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Profile";
            break;
        case 1:
            cell.textLabel.text = @"Timeline";
            break;
        default:
            cell.textLabel.text = @"Mentions";
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didSelectView:indexPath.row];
}

@end
