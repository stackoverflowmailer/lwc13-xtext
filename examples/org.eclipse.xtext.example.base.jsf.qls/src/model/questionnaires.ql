import types.Money
//TODO currently just a single modelfile is supported (generator executed fore resource and overwrites /generated/forms/index.xhtml)
form HouseOwning {    
	hasSoldHouse: "Did you sell a house in 2010?" boolean
	hasBoughtHouse: "Did you by a house in 2010?" boolean  
	hasMaintLoan: "Did you enter a loan for maintenance/reconstruction?" boolean
	
	if (this.hasSoldHouse && this.hasBoughtHouse) {                   
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