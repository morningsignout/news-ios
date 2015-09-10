//
//  NavDropdownController.m
//  ios-app
//
//  Created by Shannon Phu on 9/7/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "NavDropdownController.h"
#import "FadeSegue.h"

NSString * const section[] = {
    @"Featured", @"Search", @"Categories", @"Bookmarks"
};

@interface NavDropdownController ()

@end

@implementation NavDropdownController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    // Customize your menu programmatically here.
    [self customizeMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) customizeMenu {
    // EXAMPLE: To set the menubar background colour programmatically.
    // FYI: There is a bug where the color comes out differently when set programmatically
    // than when set in XCode Interface builder, and I don't know why.
    [self setMenubarBackground:[UIColor darkGrayColor]];
    
    // Replace menu button with an IonIcon.
    [self.menuButton setTitle:@"Menu" forState:UIControlStateNormal];
    
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton *button = self.buttons[i];
        [button setTitle:section[i] forState:UIControlStateNormal];
    }

    
    //Uncomment to stop drop 'Triangle' from appearing
    //[self dropShapeShouldShowWhenOpen:NO];
    
    //Uncomment to fade to white instead of default (black)
    [self setFadeTintWithColor:[UIColor blackColor]];
    
    //Uncomment for increased fade effect (default is 0.5f)
    //[self setFadeAmountWithAlpha:0.2f];
    
    
}

//- (IBAction)tapFeaturedButton:(id)sender {
//    NSLog(@"tapped feature");
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self performSegueWithIdentifier:@"toFeatured" sender:self];
//    });
//    
//}

- (IBAction)unwindToFeatureView:(UIStoryboardSegue *)unwindSegue {

}

- (IBAction)tapSearchButton:(id)sender {
    NSLog(@"tapped Search");
    [self performSegueWithIdentifier:@"toSearch" sender:self];
}

- (IBAction)tapCategoryButton:(id)sender {
    NSLog(@"tapped category");
}

- (IBAction)tapBookmarkButton:(id)sender {
    NSLog(@"tapped bookmark");
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
