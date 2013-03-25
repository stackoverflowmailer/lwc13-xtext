import types.Money

//TODO currently just a single model file is supported (generator overwrites /generated/forms/index.xhtml fore model resource)
//TODO the keyword this should not be used in expressions (current restriction in JSFGenerator.getDependentElementsWithExpression)

form HouseOwning {    
	hasSoldHouse: "Did you sell a house in 2010?" boolean
	hasBoughtHouse: "Did you by a house in 2010?" boolean  
	hasMaintLoan: "Did you enter a loan for maintenance/reconstruction?" boolean
	
	if (hasSoldHouse && hasBoughtHouse) {                   
		sellingPrice: "Price the house was sold for    :" Money 
		privateDebt: "Private debts for the sold house: " Money
		valueResidue: "Value residue: " Money (sellingPrice - privateDebt) 
	}       
}   

form CarOwning {    
	hasSoldCar: "Did you sell a car in 2010?" boolean
	if (hasSoldCar) {
		sellingPrice: "Price the car was sold for" Money
	}
	hasBoughtCar: "Did you buy a car in 2010?" boolean
	if (hasBoughtCar) {
		buyingPrice: "Price the car was bought for" Money
	}
}

form GarageOwning {    
	hasSoldGarage: "Did you sell a garage in 2010?" boolean
	if (hasSoldGarage) {
		sellingPrice: "Price the garage was sold for" Money
	}
	hasBoughtGarage: "Did you buy a garage in 2010?" boolean
	if (hasBoughtGarage) {
		buyingPrice: "Price the garage was bought for" Money
	}
} 