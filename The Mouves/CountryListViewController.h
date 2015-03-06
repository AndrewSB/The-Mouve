//
//  PACountryListViewController.h
//
//  Created by SANDY on 27/01/14.
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryDAO.h"
#import "BaseViewController.h"

@protocol PACountryListDelegate <NSObject>
@required

-(void)selectedCountry:(CountryDAO *)country;

@end

@interface CountryListViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>{
    CountryDAO *selectedCountry;
    CountryDAO *countryObj;
    NSArray *mainCountryList;
    NSArray *countryList;
    
id <PACountryListDelegate> delegate;

}
@property (nonatomic,strong) id delegate;
@property (nonatomic,strong) CountryDAO *selectedCountry;
@property (nonatomic,strong) CountryDAO *countryObj;
@property(nonatomic,strong) IBOutlet  UITableView  *tableScreen;
@property (nonatomic,strong) IBOutlet UISearchBar *searchBar;
@end
