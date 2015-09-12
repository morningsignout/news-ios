//
//  ContainerViewController.m
//  ios-app
//
//  Created by Shannon Phu on 9/11/15.
//  Copyright (c) 2015 Morning Sign Out Incorporated. All rights reserved.
//

#import "ContainerViewController.h"
#import "FeatureCollectionViewController.h"
#import "SearchViewController.h"
#import "CategoryViewController.h"

#define FeatureSegueIdentifier @"toFeatured"
#define SearchSegueIdentifier @"toSearch"
#define CategorySegueIdentifier @"toCategory"

#define FEATURE_INDEX 0
#define SEARCH_INDEX 1
#define CATEGORIES_INDEX 2
#define BOOKMARKS_INDEX 3

@interface ContainerViewController ()

//@property (strong, nonatomic) UIViewController *initialVC;
//@property (strong, nonatomic) UIViewController *currentVC;

@property (strong, nonatomic) FeatureCollectionViewController *featureViewController;
@property (strong, nonatomic) SearchViewController *searchViewController;
@property (strong, nonatomic) CategoryViewController *categoryViewController;

@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property (assign, nonatomic) BOOL transitionInProgress;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.transitionInProgress = NO;
    self.currentSegueIdentifier = FeatureSegueIdentifier;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it. Remove the second condition of the following
    // two if statements to get new VC instances instead.
    if ([segue.identifier isEqualToString:FeatureSegueIdentifier]) {
        self.featureViewController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:SearchSegueIdentifier]) {
        self.searchViewController = segue.destinationViewController;
    } else if ([segue.identifier isEqualToString:CategorySegueIdentifier]) {
        self.categoryViewController = segue.destinationViewController;
    }
    
    // If we're going to the first view controller.
    if ([segue.identifier isEqualToString:FeatureSegueIdentifier]) {
        // If this is not the first time we're loading this.
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.featureViewController];
        }
        else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationViewController];
            UIView* destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    }
    // swap view controllers
    else if ([segue.identifier isEqualToString:SearchSegueIdentifier]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.searchViewController];
    }
    else if ([segue.identifier isEqualToString:CategorySegueIdentifier]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.categoryViewController];
    }
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        self.transitionInProgress = NO;
    }];
}

- (void)swapViewControllersToIndex:(int)index
{
    if (self.transitionInProgress) {
        return;
    }
    
    self.transitionInProgress = YES;
    
    UIViewController *oldViewController = [self getViewControllerFromSegueIdentifier:self.currentSegueIdentifier];
    
    switch (index) {
        case FEATURE_INDEX:
            self.currentSegueIdentifier = FeatureSegueIdentifier;
            break;
        case SEARCH_INDEX:
            self.currentSegueIdentifier = SearchSegueIdentifier;
            break;
        case CATEGORIES_INDEX:
            self.currentSegueIdentifier = CategorySegueIdentifier;
            break;
        default:
            break;
    }
    
    UIViewController *newViewController = [self getViewControllerFromSegueIdentifier:self.currentSegueIdentifier];
    
    // self.currentSegueIdentifier represents the view controller user is switching to

    if (newViewController) {
        [self swapFromViewController:oldViewController toViewController:newViewController];
        return;
    }
    
//    if (([self.currentSegueIdentifier isEqualToString:FeatureSegueIdentifier]) && self.featureViewController) {
//        
//        return;
//    }
//    else if (([self.currentSegueIdentifier isEqualToString:SearchSegueIdentifier]) && self.searchViewController) {
//        [self swapFromViewController:oldViewController toViewController:self.searchViewController];
//        return;
//    }
    
    // in process
//    if (([self.currentSegueIdentifier isEqualToString:CategorySegueIdentifier]) && self.categoryViewController) {
//        [self swapFromViewController:self.featureViewController toViewController:self.searchViewController];
//        return;
//    }
    
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (UIViewController *)getViewControllerFromSegueIdentifier:(NSString *)identifier {
    if ([identifier isEqualToString:FeatureSegueIdentifier]) {
        return self.featureViewController;
    } else if ([identifier isEqualToString:SearchSegueIdentifier]) {
        return self.searchViewController;
    } else if ([identifier isEqualToString:CategorySegueIdentifier]) {
        return self.categoryViewController;
    }
    return nil;
}


@end
