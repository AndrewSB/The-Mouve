//
//  PACountryListViewController.m
//
//  Created by SANDY on 27/01/14.
//  Copyright (c) 2014. All rights reserved.
//

#import "CountryListViewController.h"

#import "Constant.h"
#import "CountryDAO.h"

#define TITLE @"Your Country"

@interface CountryListViewController ()

@end

@implementation CountryListViewController

@synthesize tableScreen,selectedCountry,countryObj,searchBar,delegate;

-(void)setDefaultView{
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem *newBackButton =
    [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(backButtonPressed)];
    [[self navigationItem] setBackBarButtonItem:newBackButton];
    
    tableScreen = [[UITableView alloc] initWithFrame:CGRectMake(0,0 , self.view.frame.size.width,self.view.frame.size.height) style:UITableViewStylePlain];
    tableScreen.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    tableScreen.backgroundColor=[UIColor clearColor];
    tableScreen.delegate = self;
    tableScreen.dataSource = self;
    
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, tableScreen.frame.size.width, 44)];
    
    searchBar.delegate = self;
    
    tableScreen.tableHeaderView = searchBar;
    
    [self.view addSubview:tableScreen];
    
    countryObj=[[CountryDAO alloc] init];
    
    mainCountryList=[countryObj getCountryData];
    
    countryList=[mainCountryList copy];
    int i;
    NSIndexPath *index;
    
    for (i=0; i< [countryList count]; i++) {
        CountryDAO *temp=[countryList objectAtIndex:i];
        if ([selectedCountry.nicename isEqualToString:temp.nicename]) {
            index=[NSIndexPath indexPathForRow:i  inSection:0];
        }
    }
    
    [tableScreen reloadData];
    [tableScreen scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
 
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)search_Bar
{
    return YES;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)search_Bar
{
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        countryList=[mainCountryList copy];
    }
    else
    {
        
        NSMutableArray *filteredTableData = [[NSMutableArray alloc] init];
        
        for (CountryDAO* country in mainCountryList)
        {
            NSRange nicename = [country.nicename rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange name = [country.name rangeOfString:text options:NSCaseInsensitiveSearch];
            NSRange iso = [country.iso3 rangeOfString:text options:NSCaseInsensitiveSearch];
            if(nicename.location != NSNotFound || name.location != NSNotFound || iso.location != NSNotFound)
            {
                [filteredTableData addObject:country];
            }
        }
        countryList=[filteredTableData copy];
    }
    
    [tableScreen reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [countryList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:MyIdentifier];
    }
   
    //cell.backgroundColor=[UIColor clearColor];
    CountryDAO *obj=[countryList objectAtIndex:[indexPath row]];
   cell.textLabel.text=obj.nicename;
    cell.textLabel.textColor=[UIColor darkGrayColor];
    cell.detailTextLabel.textColor=[UIColor darkGrayColor];
   cell.detailTextLabel.text=[NSString stringWithFormat:@"+%@",obj.phonecode];
    if([[NSString stringWithFormat:@"%@",selectedCountry.nicename] isEqualToString:[NSString stringWithFormat:@"%@",obj.nicename]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   // self.navigationController.navigationBar.topItem.title =@"Your Phone Number";
    CountryDAO *obj=[countryList objectAtIndex:[indexPath row]];
    [self.delegate selectedCountry:obj];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    
    [self setDefaultView];
    [self setSearcBarKeyboardType];
}

-(void)setSearcBarKeyboardType{
    @try {
        for(UIView *subView in [searchBar subviews]) {
            if([subView conformsToProtocol:@protocol(UITextInputTraits)]) {
                [(UITextField *)subView setReturnKeyType: UIReturnKeyDone];
            } else {
                for(UIView *subSubView in [subView subviews]) {
                    if([subSubView conformsToProtocol:@protocol(UITextInputTraits)]) {
                        [(UITextField *)subSubView setReturnKeyType: UIReturnKeyDone];
                    }
                }
                
            }
        }
    }
    @catch (NSException *exception) {
        
    }
}

#pragma mark Keyboard Delegates Methods

- (void)keyboardDidShow:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    
    
    
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow *window = [[[UIApplication sharedApplication] windows]objectAtIndex:0];
    UIView *mainSubviewOfWindow = window.rootViewController.view;
    CGRect keyboardFrameConverted = [mainSubviewOfWindow convertRect:keyboardFrame fromView:window];
    [tableScreen setFrame:CGRectMake(0,65 , self.view.frame.size.width,self.view.frame.size.height-keyboardFrameConverted.size.height)];
    
    [UIView commitAnimations];
}
-(void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [tableScreen setFrame:CGRectMake(0,65 , self.view.frame.size.width,self.view.frame.size.height)];
    [UIView commitAnimations];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
