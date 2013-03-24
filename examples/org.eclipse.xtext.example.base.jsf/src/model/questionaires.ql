import types.Money
//TODO currently just a single modelfile is supported (generator executed fore resource and overwrites /generated/forms/index.xhtml)
form BoxHouseOwning {    
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
	hasBoughtCar: "Did you buy a car in 2010?" boolean    
} 