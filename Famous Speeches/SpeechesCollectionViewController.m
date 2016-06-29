//
//  SpeechesCollectionViewController.m
//  Famous Speeches
//
//  Created by Ahmed Sabry on 6/27/16.
//  Copyright © 2016 Sabry. All rights reserved.
//

#import "SpeechesCollectionViewController.h"
#import "DatabaseManager.h"
#import "SpeechDetailTableViewController.h"
#import "SpeechCollectionViewCell.h"
#import "SpeechDetailTableViewController.h"
#import "FamousSpeeches-Swift.h"


@interface SpeechesCollectionViewController ()
@property (nonatomic,readonly) NSArray<Speech*> *speeches;
@end

@implementation SpeechesCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


#pragma mark Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
   //[self.collectionView registerNib:[UINib nibWithNibName:@"SpeechCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

-(UIImageView*) selectedImageView
{
    SpeechCollectionViewCell* selectedCell = (SpeechCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:self.collectionView.indexPathsForSelectedItems.firstObject.item inSection:0]];
    return selectedCell.imageView;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"SpeechDetail"]) {
        SpeechDetailTableViewController* userViewController = (SpeechDetailTableViewController*)((UINavigationController*)[segue destinationViewController]).topViewController;
        
        
        [segue destinationViewController].transitioningDelegate = userViewController;
        [segue destinationViewController].modalPresentationStyle = UIModalPresentationCustom;
        
        NSUInteger selectedItem = self.collectionView.indexPathsForSelectedItems.firstObject.item;
        
        userViewController.speech = self.speeches[selectedItem];
    }
}


#pragma mark - helpers
-(NSArray<Speech*>*) speeches
{
    return [DatabaseManager sharedInstance].speeches;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.speeches.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SpeechCollectionViewCell *cell = (SpeechCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    Speech* speech = self.speeches[indexPath.item];
    
    cell.byLabel.text = speech.by;
    cell.nameLabel.text = speech.name;
    cell.dateLabel.text = speech.date;
    cell.imageView.image = speech.image;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout ratioForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize imageSize = self.speeches[indexPath.item].image.size;
    
    CGFloat noOfColumns = [self collectionViewNoOfColumns:collectionView];
    
    CGFloat cellSpacing = 10;
    
    CGFloat colWidth = (self.collectionView.bounds.size.width-(noOfColumns+1.0)*cellSpacing)/(noOfColumns);
    
    // add space for text
    return CGSizeMake(colWidth, imageSize.height*colWidth/imageSize.width + 100);
}

-(NSInteger) collectionViewCellSpacing:(UICollectionView *)collectionView
{
    return 10;
}

-(NSInteger) collectionViewNoOfColumns:(UICollectionView *)collectionView
{
    CGFloat noOfColumns = 2.0;
    
    if (self.view.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        // Compact width
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
        {
            // landscape
            noOfColumns = 3;
        }
        else
        {
            // Portait
            noOfColumns = 2;
        }
    }
    else {
        // iPad or wide width like iPhone6 Plus
        noOfColumns = 4;
    }
    
    return noOfColumns;
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
