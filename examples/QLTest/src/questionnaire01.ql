import types.Money

form Box1HouseOwning {
	hasSoldHouse: "Did you sell a house in 2010?" boolean  (hasBoughtHouse )
	hasBoughtHouse: "Did you by a house in 2010?" boolean
	hasMaintLoan: "Did you enter a loan for maintenance/reconstruction?" boolean
	
	if (hasSoldHouse && hasBoughtHouse) {
		sellingPrice: "Price the house was sold for:" Money
		privateDebt: "Private debts for the sold house: " Money
		valueResidue: "Value residue: " Money (sellingPrice - privateDebt) 
	}  
}
