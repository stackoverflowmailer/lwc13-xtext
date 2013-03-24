import types.Money
 
form GarageOwningForm {
	hasSoldGarage: "Did you sell a garage in 2010?" boolean
	if (hasSoldGarage) {
		sellingPrice: "Price garage was sold for" Money
	}
	hasBoughtGarage: "Did you buy a garage in 2010?" boolean
	if (hasBoughtGarage) {
		buyingPrice: "Price garage was bought for" Money
	}
	
} 