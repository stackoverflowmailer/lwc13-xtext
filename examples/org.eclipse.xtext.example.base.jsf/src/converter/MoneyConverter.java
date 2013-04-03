package converter;

import java.math.BigDecimal;

import javax.faces.component.UIComponent;
import javax.faces.context.FacesContext;
import javax.faces.convert.Converter;
import javax.faces.convert.FacesConverter;

import types.Money;
import types.TypeFactory;

@FacesConverter("converter.Money")
public class MoneyConverter implements Converter {

  @Override
  public Object getAsObject(FacesContext ctx, UIComponent ui, String value) {
    return TypeFactory.createMoney(value);
  }

  @Override
  public String getAsString(FacesContext ctx, UIComponent ui, Object value) {
    BigDecimal amount = ((Money) value).getAmount();
    return amount == null ? "" : amount.toString();
  }
}