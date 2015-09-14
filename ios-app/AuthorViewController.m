//
//  AuthorViewController.m
//  ios-app
//
//  Created by Shannon Phu on 9/14/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "AuthorViewController.h"
#import "DataParser.h"

@interface AuthorViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;
@property (strong, nonatomic) NSArray *authorPosts;
@end

@implementation AuthorViewController

- (void)viewDidLoad {
    self.author = [[Author alloc] initWith:238 Name:@"example name" About:@"example about" AndEmail:@"example email"];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.collectionView.frame = CGRectMake(0, 150, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height - 150);
}

- (void)viewWillAppear:(BOOL)animated {
    self.nameLabel.text = self.author.name;
    self.emailLabel.text = self.author.email;
    self.aboutLabel.text = self.author.about;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
