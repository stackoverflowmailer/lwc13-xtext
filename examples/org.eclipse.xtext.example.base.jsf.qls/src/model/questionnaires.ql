import types.Money

form HouseOwning {    
	hasSoldHouse: "Did you sell a house in 2010?" boolean
	hasBoughtHouse: "Did you buy a house in 2010?" boolean  
	hasMaintLoan: "Did you enter a loan for maintenance/reconstruction?" boolean
	
	if (hasSoldHouse) {                   
		sellingPrice: "Price the house was sold for:" Money 
		privateDebt: "Private debts for the sold house:" Money
		valueResidue: "Value residue: " Money (sellingPrice - privateDebt)
	}
}    

/* 
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
*/

