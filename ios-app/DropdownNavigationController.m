//
//  NavDropdownController.m
//  ios-app
//
//  Created by Shannon Phu on 9/7/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "DropdownNavigationController.h"
#import "ContainerViewController.h"
#import "Constants.h"

#define FEATURE_INDEX 0
#define SEARCH_INDEX 1
#define CATEGORIES_INDEX 2
#define BOOKMARKS_INDEX 3

NSString * const section[] = {
    @"Featured", @"Search", @"Categories", @"Bookmarks"
};

@interface DropdownNavigationController () {
    int sectionCurrentlyOn;
}

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonOutletArray;
@property (strong, nonatomic) ContainerViewController *containerVC;

@end

@implementation DropdownNavigationController

@synthesize buttons = _buttons;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customizeMenu];
    sectionCurrentlyOn = FEATURE_INDEX;
}

-(void) customizeMenu {
    // To set the menubar background colour programmatically.
    [self setMenubarBackground:[UIColor kNavBackgroundColor]];
    
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

- (IBAction)swapButtonPressed:(UIButton *)sender
{
    int index = (int)[self.buttonOutletArray indexOfObject:sender];
    
    if (index == sectionCurrentlyOn) {
        return;
    }
    
    [self.containerVC swapViewControllersToIndex:index];
    sectionCurrentlyOn = index;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        self.containerVC = segue.destinationViewController;
    }
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
