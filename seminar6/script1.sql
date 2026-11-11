SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`dim_customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dim_customer` (
  `customer_key` INT NOT NULL AUTO_INCREMENT,
  `customer_id` VARCHAR(45) NOT NULL,
  `customer_segment` VARCHAR(100) NULL,
  `first_name` VARCHAR(100) NULL,
  `last_name` VARCHAR(100) NULL,
  `start_date` DATE NULL,
  `end_date` DATE NULL,
  `is_current` TINYINT NULL,
  PRIMARY KEY (`customer_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dim_product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dim_product` (
  `product_key` INT NOT NULL AUTO_INCREMENT,
  `product_id` VARCHAR(45) NOT NULL,
  `product_category` VARCHAR(100) NULL,
  `product_name` VARCHAR(255) NULL,
  PRIMARY KEY (`product_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`dim_date`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`dim_date` (
  `date_key` INT NOT NULL,
  `full_date` DATE NULL,
  `day` INT NULL,
  `month` INT NULL,
  `quarter` INT NULL,
  `year` INT NULL,
  PRIMARY KEY (`date_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`fact_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`fact_orders` (
  `order_id` INT NOT NULL,
  `customer_key` INT NOT NULL,
  `product_key` INT NOT NULL,
  `date_key` INT NOT NULL,
  `order_quantity` INT NULL,
  `order_amount` DECIMAL(10,2) NULL,
  PRIMARY KEY (`order_id`, `customer_key`, `product_key`, `date_key`),
  INDEX `fk_fact_orders_dim_customer_idx` (`customer_key` ASC),
  INDEX `fk_fact_orders_dim_product_idx` (`product_key` ASC),
  INDEX `fk_fact_orders_dim_date_idx` (`date_key` ASC),
  CONSTRAINT `fk_fact_orders_dim_customer`
    FOREIGN KEY (`customer_key`)
    REFERENCES `mydb`.`dim_customer` (`customer_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_orders_dim_product`
    FOREIGN KEY (`product_key`)
    REFERENCES `mydb`.`dim_product` (`product_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_fact_orders_dim_date`
    FOREIGN KEY (`date_key`)
    REFERENCES `mydb`.`dim_date` (`date_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
