package types;

import java.math.BigDecimal;

public class TypeFactory {
  public static Integer createInteger() {
    return 0;
  }

  public static Long createLong() {
    return 0l;
  }

  public static Double createDouble() {
    return 0.0d;
  }

  public static Float createFloat() {
    return 0.0f;
  }

  public static String createString() {
    return "";
  }

  public static Money createMoney() {
    return new Money(null);
  }

  public static Money createMoney(String value) {
    if (value == "" || value == null)
      return createMoney();

    BigDecimal amount = new BigDecimal(value);
    return createMoney(amount);
  }

  public static Money createMoney(BigDecimal value) {
    Money money = createMoney();
    money.setAmount(value.setScale(2));
    return money;
  }
}
