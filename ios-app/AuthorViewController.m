//
//  AuthorViewController.m
//  ios-app
//
//  Created by Shannon Phu on 9/14/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "AuthorViewController.h"
#import "DataParser.h"
#import "Constants.h"

@interface AuthorViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (strong, nonatomic) NSArray *authorPosts;
@end

@implementation AuthorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    [self setupNavigationBarStyle];
    self.collectionView.frame = CGRectMake(0, 300, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height - 300);
    self.view.backgroundColor = [UIColor kCollectionViewBackgroundColor];
}

- (void)viewWillAppear:(BOOL)animated {
    self.nameLabel.text = self.author.name;
    self.emailLabel.text = self.author.email;
    self.aboutLabel.text = self.author.about;
    
    [self.aboutLabel sizeToFit];
    
//    self.aboutLabel.lineBreakMode = UILinebreakmode.
//    self.aboutLabel.numberOfLines = 0;
    
    //[self.aboutLabel setPreferredMaxLayoutWidth:200.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupNavigationBarStyle {
    [self.navigationController.navigationBar setBarTintColor:[UIColor kNavBackgroundColor]];
    self.navigationController.navigationBar.tintColor = [UIColor kNavTextColor];
}

- (NSArray *)getDataForTypeOfView {
    self.authorPosts = [DataParser DataForAuthorInfoAndPostsWithAuthorID:self.author.ID];
    return self.authorPosts;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.authorPosts.count;
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
