package forms;

import java.io.Serializable;

public class CarOwning implements Serializable {
  private final static long serialVersionUID = 1L;
  
  private boolean hasSoldCar;
  
  private boolean hasBoughtCar;
  
  public boolean isHasSoldCar() {
    return this.hasSoldCar;
  }
  
  public void setHasSoldCar(final boolean hasSoldCar) {
    this.hasSoldCar = hasSoldCar;
  }
  
  public boolean isHasSoldCarEnabled() {
    return true;
  }
  
  public boolean isHasBoughtCar() {
    return this.hasBoughtCar;
  }
  
  public void setHasBoughtCar(final boolean hasBoughtCar) {
    this.hasBoughtCar = hasBoughtCar;
  }
  
  public boolean isHasBoughtCarEnabled() {
    return true;
  }
}
