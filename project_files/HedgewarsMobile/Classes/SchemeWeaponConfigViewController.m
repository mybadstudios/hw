//
//  SchemeWeaponConfigViewController.m
//  Hedgewars
//
//  Created by Vittorio on 13/06/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SchemeWeaponConfigViewController.h"
#import "CommodityFunctions.h"

@implementation SchemeWeaponConfigViewController
@synthesize listOfSchemes, listOfWeapons, lastIndexPath_sc, lastIndexPath_we, selectedScheme, selectedWeapon;

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return rotationManager(interfaceOrientation);
}

#pragma mark -
#pragma mark View lifecycle
-(void) viewDidLoad {
    [super viewDidLoad];

    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.view.frame = CGRectMake(0, 0, screenSize.height, screenSize.width - 44);
    
    self.selectedScheme = @"";
    self.selectedWeapon = @"";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.tableView setBackgroundView:nil]; 
        self.view.backgroundColor = [UIColor clearColor];
    }
    self.tableView.separatorColor = [UIColor colorWithRed:(CGFloat)0xFE/255 green:(CGFloat)0xCB/255 blue:0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void) viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];

    NSArray *contentsOfDir = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:SCHEMES_DIRECTORY() error:NULL];
    self.listOfSchemes = contentsOfDir;
    
    if ([listOfSchemes containsObject:@"Default.plist"])
         self.selectedScheme = @"Default.plist";
    
    contentsOfDir = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:WEAPONS_DIRECTORY() error:NULL];
    self.listOfWeapons = contentsOfDir;
         
    if ([listOfWeapons containsObject:@"Default.plist"])
         self.selectedWeapon = @"Default.plist";

    [self.tableView reloadData];
}



#pragma mark -
#pragma mark Table view data source
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) 
        return [self.listOfSchemes count];
    else
        return [self.listOfWeapons count];
}


// Customize the appearance of table view cells.
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    NSInteger row = [indexPath row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    if ([indexPath section] == 0) {
        cell.textLabel.text = [[self.listOfSchemes objectAtIndex:row] stringByDeletingPathExtension];
        if ([[self.listOfSchemes objectAtIndex:row] isEqualToString:self.selectedScheme]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.lastIndexPath_sc = indexPath;
        }
    } else {
        cell.textLabel.text = [[self.listOfWeapons objectAtIndex:row] stringByDeletingPathExtension];
        if ([[self.listOfWeapons objectAtIndex:row] isEqualToString:self.selectedWeapon]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.lastIndexPath_we = indexPath;
        }
    }
    return cell;
}


#pragma mark -
#pragma mark Table view delegate
-(void) tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *lastIndexPath;
    if ([indexPath section] == 0)
        lastIndexPath = self.lastIndexPath_sc;
    else
        lastIndexPath = self.lastIndexPath_we;
    
    int newRow = [indexPath row];
    int oldRow = (lastIndexPath != nil) ? [lastIndexPath row] : -1;
    
    if (newRow != oldRow) {
        //TODO: this code works only for a single section table
        UITableViewCell *newCell = [aTableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        UITableViewCell *oldCell = [aTableView cellForRowAtIndexPath:lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([indexPath section] == 0) {
            self.lastIndexPath_sc = indexPath;
            self.selectedScheme = [self.listOfSchemes objectAtIndex:newRow];
        } else {
            self.lastIndexPath_we = indexPath;
            self.selectedWeapon = [self.listOfWeapons objectAtIndex:newRow];
        }        
        
        [aTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    [aTableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return NSLocalizedString(@"Schemes",@"");
    } else {
        return NSLocalizedString(@"Weapons",@"");;
    }
}

#pragma mark -
#pragma mark Memory management
-(void) didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

-(void) viewDidUnload {
    self.listOfSchemes = nil;
    self.listOfWeapons = nil;
    self.lastIndexPath_sc = nil;
    self.lastIndexPath_we = nil;
    self.selectedScheme = nil;
    self.selectedWeapon = nil;
    MSG_DIDUNLOAD();
}


-(void) dealloc {
    [listOfSchemes release];
    [listOfWeapons release];
    [lastIndexPath_sc release];
    [lastIndexPath_we release];
    [selectedScheme release];
    [selectedWeapon release];
    [super dealloc];
}


@end

